with _select as (
	select 
		first_name,
		last_name, 
		email, 
		phone_number,
		address_city, 
		address_state,
		event_code, 
		match_date,
		extract(month from match_date) as match_month,
		extract(year from match_date) as match_year
	from prod_intermediate.int_single_ticket_purchase
	where coalesce(first_name, last_name, '') != ''
		and match_date >= '2024-10-01' and match_date < '2025-01-01'
), 

_rank as (
	select
		first_name,
		last_name, 
		email, 
		phone_number,
		address_city, 
		address_state,
		row_number() over(partition by email order by last_name, first_name, phone_number) as row_id
	from _select
), 

_unique as (
	select 
		first_name,
		last_name, 
		email, 
		phone_number,
		address_city, 
		address_state
	from _rank
	where row_id = 1
), 

_email_months as (
	select email, 
		count(case when match_month = 10 then 1 end) as october_purchases,
		count(case when match_month = 11 then 1 end) as november_purchases,
		count(case when match_month = 12 then 1 end) as december_purchases
	from _select
	group by email
),

_combined as (
	select 
		a.*,
		b.october_purchases,
		b.november_purchases,
		b.december_purchases
	from _unique as a
	left join _email_months as b 
	on a.email = b.email
),

_final as (
	select * 
	from _combined as a
	where not exists (select 1 from prod_raw.stg_braze_unsub as b where a.email = b.email)
)

select * from _final order by address_state, address_city, last_name;