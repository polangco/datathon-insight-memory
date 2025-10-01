drop table if exists lovb_491.netsuite_invoices_76_79_80_May_to_Dec_2024;
create table lovb_491.netsuite_invoices_76_79_80_May_to_Dec_2024 as 
	select
		a.source_system,
		a.club_id,
		a.club_name,
		a.invoice_id,
		to_char(a.created_date, 'MM/DD/YYYY') as created_date,
		b.item_id,
		b.item_name,
		b.program_type,
		b.item_type,
		to_char(a.package_start_date, 'MM/DD/YYYY') as program_start_date,
		to_char(a.package_end_date, 'MM/DD/YYYY') as program_end_date,
		to_char(a.latest_due_date, 'MM/DD/YYYY') as due_date,
		a.budget, 
		a.discount,
		a.adjustment,
		coalesce (a.amount, a.amount_paid - a.amount_refunded) as amount,
		a.billing_account_id,
		a.invoice_status,
		a.notes
	from lovb_491.unified_invoices_latest as a
	left join lovb_491.unified_programs_latest b
	on	
		coalesce (a.program_id, 0) = coalesce (b.program_id, 0) and 
		coalesce (a.package_id, 0) = coalesce (b.package_id, 0) and
		a.club_id = b.club_id
	where 
		a.club_id in (79, 76, 81)
		and created_date > to_date('20240501', 'YYYYMMDD')
	order by a.club_id, created_date
;

drop table if exists lovb_491.netsuite_items_76_79_80_May_to_Dec_2024; 
create table lovb_491.netsuite_items_76_79_80_May_to_Dec_2024 as
	select 
		a.source_system,
		a.club_id, 
		a.club_name, 
		a.program_id,
		a.program_name,
		a.package_id,
		a.package_name,
		a.item_id,
		a.item_name,
		a.program_type,
		a.item_type,
		a.acct_code,
		a.dept_code
	from lovb_491.unified_programs_latest a
	inner join (select distinct club_id, item_id from lovb_491.netsuite_invoices_76_79_80_May_to_Dec_2024) b
	on a.item_id = b.item_id and a.club_id = b.club_id
	order by a.club_id, a.item_id
;


select * from lovb_491.netsuite_invoices_76_79_80_May_to_Dec_2024;
select * from lovb_491.netsuite_items_76_79_80_May_to_Dec_2024;