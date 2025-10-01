
with atl_sales as (
    select * 
    from public.ticketmaster_events
    where 
        "event_date":: date > to_date('20250130', 'YYYYMMDD') 
        and "event_date" :: date <= to_date('20250204', 'YYYYMMDD')
        and "proMarket" = 'Atlanta'
), 

atl_sales_tidy as (
	select 
		trim(initcap("firstName")) as first_name,
		trim(initcap("lastName")) as last_name,
		trim(lower("email")) as email, 
		trim(regexp_replace(trim("phoneNumber"), '[^0-9]', '', 'g')) as phone,
		left(trim("postalCode"), 5) as home_zip,
		"proMarket" as event_market,
		"venue" as event_venue,
		"event_name" as event_name, 
		"event_date"::date as event_date
	from atl_sales
	where "email" ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
),

email_ext_id as (
	select email,gen_random_uuid() as external_id
	from atl_sales_tidy
	group by email
),

final as (
	select 
		coalesce(b.external_id, c.external_id) as external_id,
		a.first_name,
		a.last_name, 
		a.email, 
		a.phone,
		a.event_name,
		a.event_market,
		a.event_venue, 
		a.event_date
	from atl_sales_tidy as a
	left join (select distinct email, external_id from prod_marketing.dim_braze_single_match_tickets) as b
	on a.email = b.email
	left join email_ext_id as c
	on a.email = c.email
)

select * from final

;