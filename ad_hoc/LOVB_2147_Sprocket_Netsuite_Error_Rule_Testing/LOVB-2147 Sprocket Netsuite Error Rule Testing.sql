/**************************************************************************************************
Build out the testing dataset
**************************************************************************************************/
/**************************************************************************************************
create schema lovb_2147;
drop table if exists lovb_2147.invoices_0101_0127;

with sprocket_accrual as (
    select 
        registration_id,
        billing_account_id,
        accrual_start_date,
        accrual_end_date
    from prod_intermediate.int_sprocket_registrations
),

club_mapping as (
    select distinct club_id, rcl_name 
    from prod_raw.club_mapping
),

registrations as (
    select
        a.source_system, 
        a.club_id, 
        a.club_name, 
        d.rcl_name,
        a.program_id, 
        a.program_name, 
        a.package_id, 
        a.package_name, 
        case 
            when a.source_system = 'Sprocket' then c.accrual_start_date
            else a.package_start_date
        end as package_start_date, 
        case 
            when a.source_system = 'Sprocket' then c.accrual_end_date
            else a.package_end_date
        end as package_end_date, 
        a.program_type,
        b.acct_code, 
        b.dept_code,
        a.created_date,
        a.invoice_id,
        a.registration_id,
        a.billing_account_id

    from prod_composable.fct_registrations as a

    left join prod_composable.dim_programs as b 
    on 
        a.source_system = b.source_system
        and a.club_id = b.club_id
		and COALESCE(a.program_id,0) = COALESCE(b.program_id, 0) 
		and COALESCE(a.package_id,0) = COALESCE(b.package_id, 0)

    left join sprocket_accrual as c
    on 
        a.source_system = 'Sprocket'
        and a.registration_id = c.registration_id
        and a.billing_account_id = c.billing_account_id
        
	left join club_mapping as d 
	on a.club_id = d.club_id

    where created_date >= to_date('20240101', 'YYYYMMDD')
)

select * 
into table lovb_2147.invoices_0101_0127
from registrations
;
**************************************************************************************************/
/**************************************************************************************************
Run the current checks to get the baseline
**************************************************************************************************/

with error_flags as (
    select
        *, 

        case
            when package_start_date is null and package_end_date is null then 'Failed: start_date and end_date null' 
            when package_start_date is null then 'Failed: start_date null'
            when package_end_date is null then 'Failed: end_date null'
            else 'Passed'
    	end as start_end_date_qa_check, 

        case
            when 
                (
                    lower(program_name) like '%camp%'
                    or lower(package_name) like '%camp%'
                )
                and age(package_end_date, package_start_date) > interval '3 months' 
            then 'Failed: camp > 3 months'
            when 
                (
                    lower(program_name) like '%tryout%'
                    or lower(package_name) like '%tryout%'
                )
                and age(package_end_date, package_start_date) > interval '1 months' 
            then 'Failed: tryout > 1 months'
            when age(package_end_date, package_start_date) > interval '7 months' then 'Failed: program > 7 months'
            else 'Passed'
        end as too_long_qa_check,

        case 
			when age(package_start_date, created_date) < INTERVAL '-3 months' then 'Failed: program too far in the past'
			else 'Passed'
		end as in_past_qa_check, 

        case
            when acct_code is null and dept_code is null then 'Failed: accouting and dept code null'
            when acct_code is null then 'Failed: accouting code null'
            when dept_code is null then 'Failed: deptartment code null'
            else 'Passed'
    	end as no_acct_qa_check,

        case
            when (program_name || package_name) ~* 'lesson' and not acct_code like '%41001' then 'Failed: lessons wrong code'
            when (program_name || package_name) ~* 'lesson' and not dept_code like '%106' then 'Failed: lessons wrong code'
            when (program_name || package_name) ~* '(court rental|rental)' and not acct_code like '%42005' then 'Failed: court rental wrong code'
            when (program_name || package_name) ~* '(court rental|rental)' and not dept_code like '%106' then 'Failed: court rental wrong code'
            when (program_name || package_name) ~* 'boys.*(dues|club|team)' and not dept_code like '%103' then 'Failed: boys registration wrong code'
            else 'Passed'
        end as acct_wrong_qa_check,

        case
            when 
                (program_name || package_name) ~* 'girls.*(registration|club|team|dues)' 
                and not (program_name || package_name) ~* '(tryout|academy)'
                and extract(month from package_start_date) < 10
            then 'Failed: girls registration before 10/1' 
            else 'Passed'
        end as girls_oct_qa_check, 

        case
            when coalesce(program_name, package_name, '') = '' then 'Failed: program and package name null' 
            else 'Passed'
        end as program_package_name_qa_check

    from lovb_2147.invoices_0101_0127
),

filter_errors as (
    select *
    from error_flags
    where 
    	source_system = 'Sprocket'
    	and (
	        start_end_date_qa_check ~* 'failed'
	        or too_long_qa_check   ~* 'failed'
	        or in_past_qa_check  ~* 'failed'
	        or no_acct_qa_check  ~* 'failed'
	        or acct_wrong_qa_check  ~* 'failed'
	        or girls_oct_qa_check  ~* 'failed'
	        or program_package_name_qa_check ~* 'failed'
		)
)

select * from filter_errors;



/**************************************************************************************************
Alter just the time periods
**************************************************************************************************/

with error_flags as (
    select
        *, 

        case
            when package_start_date is null and package_end_date is null then 'Failed: start_date and end_date null' 
            when package_start_date is null then 'Failed: start_date null'
            when package_end_date is null then 'Failed: end_date null'
            else 'Passed'
    	end as start_end_date_qa_check, 

        case
            when 
                (
                    lower(program_name) like '%camp%'
                    or lower(package_name) like '%camp%'
                )
                and age(package_end_date, package_start_date) > interval '3 months' 
            then 'Failed: camp > 3 months'
            when 
                (
                    lower(program_name) like '%tryout%'
                    or lower(package_name) like '%tryout%'
                )
                and age(package_end_date, package_start_date) > interval '50 days' 
            then 'Failed: tryout > 1.5 months'
            when age(package_end_date, package_start_date) > interval '9 months' then 'Failed: program > 9 months'
            else 'Passed'
        end as too_long_qa_check,

        case 
			when age(package_start_date, created_date) < INTERVAL '-4 months' then 'Failed: program too far in the past'
			else 'Passed'
		end as in_past_qa_check, 

        case
            when acct_code is null and dept_code is null then 'Failed: accouting and dept code null'
            when acct_code is null then 'Failed: accouting code null'
            when dept_code is null then 'Failed: deptartment code null'
            else 'Passed'
    	end as no_acct_qa_check,

        case
            when (program_name || package_name) ~* 'lesson' and not acct_code like '%41001' then 'Failed: lessons wrong code'
            when (program_name || package_name) ~* 'lesson' and not dept_code like '%106' then 'Failed: lessons wrong code'
            when (program_name || package_name) ~* '(court rental|rental)' and not acct_code like '%42005' then 'Failed: court rental wrong code'
            when (program_name || package_name) ~* '(court rental|rental)' and not dept_code like '%106' then 'Failed: court rental wrong code'
            when (program_name || package_name) ~* 'boys.*(dues|club|team)' and not dept_code like '%103' then 'Failed: boys registration wrong code'
            else 'Passed'
        end as acct_wrong_qa_check,

        case
            when 
                (program_name || package_name) ~* 'girls.*(registration|club|team|dues)' 
                and not (program_name || package_name) ~* '(tryout|academy)'
                and extract(month from package_start_date) < 10
            then 'Failed: girls registration before 10/1' 
            else 'Passed'
        end as girls_oct_qa_check, 

        case
            when coalesce(program_name, package_name, '') = '' then 'Failed: program and package name null' 
            else 'Passed'
        end as program_package_name_qa_check

    from lovb_2147.invoices_0101_0127
),

filter_errors as (
    select *
    from error_flags
    where 
    	source_system = 'Sprocket'
    	and (
	        start_end_date_qa_check ~* 'failed'
	        or too_long_qa_check   ~* 'failed'
	        or in_past_qa_check  ~* 'failed'
	        or no_acct_qa_check  ~* 'failed'
	        or acct_wrong_qa_check  ~* 'failed'
	        or girls_oct_qa_check  ~* 'failed'
	        or program_package_name_qa_check ~* 'failed'
		)
)

select * from filter_errors;