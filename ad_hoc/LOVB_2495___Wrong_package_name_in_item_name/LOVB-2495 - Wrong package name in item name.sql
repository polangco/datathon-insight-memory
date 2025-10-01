-- ISSUE 
-- multiple instances of the same program and package ids historically in the data
-- logic will take the first option as long as it's not null for acct, dept, and program_type
with _ranked as (
	select program_id, program_name, package_id, package_name, last_modified,
		row_number() over(partition by program_id, program_name, package_id, package_name
						  order by last_modified) as row_id 
	from public.playmetrics_all_programs
	where program_id = 54338 and package_id = 213036
)

select program_id, program_name, package_id, package_name, last_modified
from _ranked 
where row_id = 1
order by last_modified
;



-- FIX 
-- Invoices fix
with _bad_invoices as (
	select *  
	from lovb_491.netsuite_invoices_april_2025
	where item_name ~* '5/4/2025 2pm-3:30pm 13s/14s Open Gym'
), 

_ids as (
	select distinct 
		club_id,
		item_id, 
		split_part(item_id, '-', 1) :: int as program_id, 
		split_part(item_id, '-', 2) :: int as package_id
	from _bad_invoices
),

_correct_items as (
	select
		a.club_id,
		a.item_id,
		b.program_name || '|' || b.package_name as item_name,
		b.program_id,
		b.program_name,
		b.package_id,
		b.package_name,
		b.package_start_date :: date as program_start_date,
		b.package_end_date :: date as program_end_date,
		trim(split_part(b.program_acct_code, ',', 1)) as acct_code,
		trim(split_part(b.program_acct_code, ',', 2)) as dept_code,
		type as program_type
		
	from _ids as a 
	left join public.playmetrics_all_programs_latest as b
	on a.program_id = b.program_id and a.package_id = b.package_id

),

_corrected_invoices as (
	select 
		a.source_system, 
		a.club_id,
		a.club_name, 
		a.invoice_id, 
		a.created_date, 
		a.item_id,
		b.item_name, 
		b.program_type,
		a.item_type, 
		to_char(b.program_start_date, 'MM/DD/YYYY') as program_start_date,
		to_char(b.program_end_date, 'MM/DD/YYYY') as program_end_date,	
		a.due_date, 
		a.budget, 
		a.discount, 
		a.adjustment, 
		a.amount,
		a.billing_account_id, 
		a.invoice_status,
		a.notes

	from _bad_invoices as a
	left join _correct_items as b
	on a.club_id = b.club_id and a.item_id = b.item_id
)

select * from _corrected_invoices
;


-- Invoices fix
with _bad_invoices as (
	select *  
	from lovb_491.netsuite_invoices_april_2025
	where item_name ~* '5/4/2025 2pm-3:30pm 13s/14s Open Gym'
), 

_ids as (
	select distinct 
		club_id,
		item_id, 
		split_part(item_id, '-', 1) :: int as program_id, 
		split_part(item_id, '-', 2) :: int as package_id
	from _bad_invoices
),

_correct_items as (
	select
		a.club_id,
		a.item_id,
		b.program_name || '|' || b.package_name as item_name,
		b.program_id,
		b.program_name,
		b.package_id,
		b.package_name,
		b.package_start_date :: date as program_start_date,
		b.package_end_date :: date as program_end_date,
		trim(split_part(b.program_acct_code, ',', 1)) as acct_code,
		trim(split_part(b.program_acct_code, ',', 2)) as dept_code,
		type as program_type
		
	from _ids as a 
	left join public.playmetrics_all_programs_latest as b
	on a.program_id = b.program_id and a.package_id = b.package_id

),

_corrected_items_out as (
	select 
		a.source_system, 
		a.club_id,
		a.club_name, 
		a.program_id,
		b.program_name, 
		a.package_id,
		b.package_name,
		a.item_id,
		b.item_name, 
		b.program_type,
		a.item_type, 
		b.acct_code,
		b.dept_code

	from lovb_491.netsuite_items_april_2025 as a
	inner join _correct_items as b
	on a.club_id = b.club_id and a.item_id = b.item_id
)

select * from _corrected_items_out
;