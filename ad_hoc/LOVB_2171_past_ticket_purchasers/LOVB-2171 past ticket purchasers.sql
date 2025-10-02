with _select as (
	select 
		first_name,
		last_name, 
		email, 
		address_city, 
		address_state
	from prod_intermediate.int_shopify_customer_profiles
	where coalesce(first_name, last_name, '') != ''
), 

_rank as (
	select
		first_name,
		last_name, 
		email, 
		address_city, 
		address_state,
		row_number() over(partition by email order by last_name, first_name) as row_id
	from _select
), 

_unique as (
	select 
		first_name,
		last_name, 
		email, 
		address_city, 
		address_state
	from _rank
	where row_id = 1
),

_final as (
	select * 
	from _unique as a
	where not exists (select 1 from prod_raw.stg_braze_unsub as b where a.email = b.email)
)

select first_name, last_name, email, address_city, address_state from _final order by address_state, address_city, last_name;