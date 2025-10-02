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
	from prod_intermediate.int_purchase_history
	where coalesce(first_name, last_name, '') != ''
), 

_adj_match_month as (
	select 
		first_name,
		last_name, 
		email, 
		phone_number,
		address_city, 
		address_state,
		event_code, 
		match_date,
		match_month - (select min(match_month) from _select) + 1 as match_month
	from _select
), 

_rank as (
	select
		first_name,
		last_name, 
		email, 
		phone_number,
		address_city, 
		address_state,
		row_number() over(partition by email order by last_name, first_name, phone_number, match_month) as row_id
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
		max(case when match_month = 1 then 1 else 0 end) :: BOOLEAN as month_1,
		max(case when match_month = 2 then 1 else 0 end) :: BOOLEAN as month_2,
		max(case when match_month = 3 then 1 else 0 end) :: BOOLEAN as month_3,
		max(case when match_month = 4 then 1 else 0 end) :: BOOLEAN as month_4,
		max(case when match_month = 5 then 1 else 0 end) :: BOOLEAN as month_5,
		max(case when match_month = 6 then 1 else 0 end) :: BOOLEAN as month_6,
		max(case when match_month = 7 then 1 else 0 end) :: BOOLEAN as month_7,
		max(case when match_month = 8 then 1 else 0 end) :: BOOLEAN as month_8,
		max(case when match_month = 9 then 1 else 0 end) :: BOOLEAN as month_9,
		max(case when match_month = 10 then 1 else 0 end) :: BOOLEAN as month_10,
		max(case when match_month = 11 then 1 else 0 end) :: BOOLEAN as month_11,
		max(case when match_month = 12 then 1 else 0 end) :: BOOLEAN as month_12
	from _adj_match_month
	group by email
),

_combined as (
	select 
		a.*,
		b.month_1,
		b.month_2,
		b.month_3,
		b.month_4,
		b.month_5,
		b.month_6,
		b.month_7,
		b.month_8,
		b.month_9,
		b.month_10,
		b.month_11,
		b.month_12
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