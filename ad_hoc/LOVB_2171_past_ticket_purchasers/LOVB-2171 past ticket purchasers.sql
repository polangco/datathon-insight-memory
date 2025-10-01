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
		extract(week from match_date) as match_week
	from prod_intermediate.int_single_ticket_purchase
	where coalesce(first_name, last_name, '') != ''
), 

_adj_match_week as (
	select 
		first_name,
		last_name, 
		email, 
		phone_number,
		address_city, 
		address_state,
		event_code, 
		match_date,
		match_week - (select min(match_week) from _select) + 1 as match_week
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
		row_number() over(partition by email order by last_name, first_name, phone_number, match_week) as row_id
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

_email_weeks as (

	select email, 
		max(case when match_week = 1 then 1 else 0 end) :: BOOLEAN as week_1,
		max(case when match_week = 2 then 1 else 0 end) :: BOOLEAN as week_2,
		max(case when match_week = 3 then 1 else 0 end) :: BOOLEAN as week_3,
		max(case when match_week = 4 then 1 else 0 end) :: BOOLEAN as week_4,
		max(case when match_week = 5 then 1 else 0 end) :: BOOLEAN as week_5,
		max(case when match_week = 6 then 1 else 0 end) :: BOOLEAN as week_6,
		max(case when match_week = 7 then 1 else 0 end) :: BOOLEAN as week_7,
		max(case when match_week = 8 then 1 else 0 end) :: BOOLEAN as week_8,
		max(case when match_week = 9 then 1 else 0 end) :: BOOLEAN as week_9,
		max(case when match_week = 10 then 1 else 0 end) :: BOOLEAN as week_10,
		max(case when match_week = 11 then 1 else 0 end) :: BOOLEAN as week_11,
		max(case when match_week = 12 then 1 else 0 end) :: BOOLEAN as week_12,
		max(case when match_week = 13 then 1 else 0 end) :: BOOLEAN as week_13
	from _adj_match_week
	group by email
),

_combined as (
	select 
		a.*,
		b.week_1,
		b.week_2,
		b.week_3,
		b.week_4,
		b.week_5,
		b.week_6,
		b.week_7,
		b.week_8,
		b.week_9,
		b.week_10,
		b.week_11,
		b.week_12,
		b.week_13
	from _unique as a
	left join _email_weeks as b 
	on a.email = b.email
),

_final as (
	select * 
	from _combined as a
	where not exists (select 1 from prod_raw.stg_braze_unsub as b where a.email = b.email)
)

select * from _final order by address_state, address_city, last_name;
;

