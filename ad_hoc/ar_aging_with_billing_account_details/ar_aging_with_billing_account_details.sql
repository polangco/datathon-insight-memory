with _past_year as (
	select * 
	from metabase.ar_aging
-- 	where created_date > to_date('20231201', 'YYYYMMDD') and created_date < to_date('20250501', 'YYYYMMDD')
), 

_unique_billing_account as (
	select source_system, billing_account_id, 
		max(first_name) as first_name, 
		max(last_name) as last_name, 
		max(email) as email, 
		max(phone_number) as phone_number
	from lovb_491.unified_customers_latest
	group by source_system, billing_account_id
),

_stich_ as (
	select 
		a.source_system, 
		a.rcl_name, 
		a.club_id,
		a.club_name, 
		a.invoice_id,
		a.created_date, 
		a.item_id, 
		a.item_name, 
		a.item_type, 
		a.package_start_date,
		a.package_end_date, 
		a.latest_due_date, 
		a.invoice_status,
		a.billing_account_id, 
		b.first_name,
		b.last_name, 
		b.email, 
		b.phone_number,
		a.amount, 
		a.owing, 
		a.days_to_due_date, 
		a.standing_flag, 
		a.standing_desc 
	from _past_year as a 
	left join _unique_billing_account as b
	on a.source_system = b.source_system and a.billing_account_id = b.billing_account_id
)

select * from _stich_ order by created_date desc, invoice_id
;