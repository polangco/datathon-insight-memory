with sprocket_invoices as (
	select distinct
		-- mapped column names our db table to match those in invoice-errors-2025-01-22
	 	club_name, 
	    registration_id :: bigint as registration_id,
	    player_registration_id :: bigint as player_registration_id, -- added this just so we have something unique to the specific registration
	    completed_date :: date as completed_date,
	    completed_by, 
	    accrual_start_date :: date as accrual_start_date,
	    accrual_end_date :: date as accrual_end_date,
	    program_name,
	    registration_name as registration,
	    accounting_class, 
	    trim(split_part(accounting_class, ',', 1)) as acct_code, -- added this to make it easier to do the accounting code checks
		trim(split_part(accounting_class, ',', 2)) as dept_code -- added this to make it easer to do the department code checks 
	
	from public.sprocket_registration_details
	
	where completed_date :: date >= to_date('20250101', 'YYYYMMDD') and completed_date :: date < to_date('20250201', 'YYYYMMDD')
), 

error_flags as (
	select *, 
			
			-- No change
			case
	            when accrual_start_date is null and accrual_end_date is null then 'Failed: start_date and end_date null' 
	            when accrual_start_date is null then 'Failed: start_date null'
	            when accrual_end_date is null then 'Failed: end_date null'
	            else 'Passed'
	    	end as start_end_date_qa_check, 
	    	
	    	-- extend the top end from 7 months to 9 months
	    	-- extend tryouts from 1 month to 50 days
	    	case 
	    		when accrual_start_date is null or accrual_end_date is null then 'Passed'
	    		when accrual_end_date - accrual_start_date > 270 then 'Failed: program longer than 9 months'
	    		when 
	    			accrual_end_date - accrual_start_date > 50
	    			and (program_name ~* 'tryout' or registration ~* 'tryout')
	    		then 'Failed: tryout > 1.5 months'
	    		when 
	    			accrual_end_date - accrual_start_date > 90
	    			and (program_name ~* 'camp' or registration ~* 'camp')
	    		then 'Failed: camp > 3 months'
	    		else 'Passed'
	    	end as program_too_long_qa_check, 
	    	
	    	-- extend period from 3 months to 4 months in the past
	    	case 
				when accrual_start_date - completed_date > 120 then 'Failed: program too far in the past'
				else 'Passed'
			end as in_past_qa_check, 
			
			-- No change
			case
				when accounting_class is null then 'Failed: accounting and dept code null'
				when acct_code is null then 'Failed: accounting code null'
				when dept_code is null then 'Failed: department code null'
	            else 'Passed'
	    	end as no_acct_qa_check,
	
			-- No change
	        case
	            when (program_name || registration) ~* 'lesson' and not acct_code like '%41001' then 'Failed: lessons wrong code'
	            when (program_name || registration) ~* 'lesson' and not dept_code like '%106' then 'Failed: lessons wrong code'
	            when (program_name || registration) ~* '(court rental|rental)' and not acct_code like '%42005' then 'Failed: court rental wrong code'
	            when (program_name || registration) ~* '(court rental|rental)' and not dept_code like '%106' then 'Failed: court rental wrong code'
	            when (program_name || registration) ~* 'boys.*(dues|club|team)' and not dept_code like '%103' then 'Failed: boys registration wrong code'
	            else 'Passed'
	        end as acct_wrong_qa_check,
	        
	        -- Dropped the Girls Program start before October check, it should be captured by the 9 month program too long check
	
			-- No change
	        case
	            when coalesce(program_name, registration, '') = '' then 'Failed: program and package name null' 
	            else 'Passed'
	        end as program_package_name_qa_check
	
	from sprocket_invoices
)

select * 
into temporary table tmp_sprocket_nov_errors
from error_flags
;

-- get counts by error check for benchmark based on November 2024 data
-- this may not exactly match the testing data because of manipulations to the testing data applied by Cassandra and Jill

select start_end_date_qa_check, count(*) from tmp_sprocket_nov_errors group by start_end_date_qa_check;

/*
| start_end_date_qa_check | count |
|-------------------------|-------|
| Passed                  | 10443 |
*/

select program_too_long_qa_check, count(*) from tmp_sprocket_nov_errors group by program_too_long_qa_check;

/*
| program_too_long_qa_check            | count |
|--------------------------------------|-------|
| Failed: program longer than 9 months |   217 |
| Failed: tryout > 1.5 months          |   265 |
| Passed                               |  9961 |
*/

select in_past_qa_check, count(*) from tmp_sprocket_nov_errors group by in_past_qa_check;

/*
| in_past_qa_check                    | count |
|-------------------------------------|-------|
| Failed: program too far in the past |    17 |
| Passed                              | 10426 |
*/

select no_acct_qa_check, count(*) from tmp_sprocket_nov_errors group by no_acct_qa_check;

/*
| no_acct_qa_check | count |
|------------------|-------|
| Passed           | 10443 |
*/

select acct_wrong_qa_check, count(*) from tmp_sprocket_nov_errors group by acct_wrong_qa_check;

/*
| acct_wrong_qa_check                  | count |
|--------------------------------------|-------|
| Failed: boys registration wrong code |    31 |
| Failed: lessons wrong code           |     6 |
| Passed                               | 10406 |
*/

select program_package_name_qa_check, count(*) from tmp_sprocket_nov_errors group by program_package_name_qa_check;

/*
| program_package_name_qa_check | count |
|-------------------------------|-------|
| Passed                        | 10443 |
*/


