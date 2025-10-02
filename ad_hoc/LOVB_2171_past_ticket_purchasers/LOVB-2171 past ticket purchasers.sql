with _select as (
	select 
		first_name,
		last_name, 
		email, 
		address_city, 
		address_state
	from prod_intermediate.int_shopify_customers
	where coalesce(first_name, last_name, '') != ''
), 

_unique as (
	select 
		first_name,
		last_name, 
		email, 
		address_city, 
		address_state
	from _select
	group by first_name, last_name, email, address_city, address_state
), 

_final as (
	select * 
	from _unique as a
	where not exists (select 1 from prod_raw.stg_braze_unsub as b where a.email = b.email)
)

select first_name, last_name, email, address_city, address_state from _final order by address_state, address_city, last_name;