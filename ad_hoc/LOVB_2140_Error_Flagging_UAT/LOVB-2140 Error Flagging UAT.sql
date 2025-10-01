select * from public.invoices_error_jan;

-- align column formating and run provided data validation
drop table if exists tmp_sprocket_nov_errors;
with sprocket_invoices as (
	 select 
	 	"club" as club_name,  
	 	"registration_id" ::int registration_id,
		"user_name" as user_name,
	 	"completed_date"::date as completed_date,
	 	coalesce("program", '') as program_name,  
	 	coalesce("registration", '') as registration,
		"accrual_start_date"::date as accrual_start_date, 
		"accrual_end_date"::date as accrual_end_date, 
		"accounting_class" as accounting_class,
		trim(split_part("accounting_class", ',', 1)) as acct_code,
		trim(split_part("accounting_class", ',', 2)) as dept_code,
		"failedvalidations" as mulesoft_fail_code
		
	from public.invoices_error_jan
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
			case when completed_date - accrual_start_date < -90 then 'Failed: program registration 90 days prior to accrual start'
				 when completed_date - accrual_end_date > 30 then 'Failed: program registration 30 days after accrual end'
			     when completed_date - accrual_start_date > 120 then 'Failed; program registration 4 mnths after accrual start'
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

-- check for instance of start and end date check inconsistency
select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'start_date and end_date null' and start_end_date_qa_check ~* 'start_date and end_date null';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'start_date null' and start_end_date_qa_check ~* 'start_date null';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'end_date null' and start_end_date_qa_check ~* 'end_date null';

select * from tmp_sprocket_nov_errors where mulesoft_fail_code ~* 'start_date and end_date null' and start_end_date_qa_check !~* 'start_date and end_date null';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code ~* 'start_date null' and start_end_date_qa_check !~* 'start_date null' and start_end_date_qa_check !~* 'start_date and end_date null';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code ~* 'end_date null' and start_end_date_qa_check !~* 'end_date null';

-- check for instances of too far in the past inconsistency
select * from tmp_sprocket_nov_errors where in_past_qa_check != 'Passed';
select *, accrual_start_date - completed_date
from tmp_sprocket_nov_errors 
where mulesoft_fail_code ~* 'program too far in the past' and in_past_qa_check = 'Passed';

with outside_period as (
	select club_name, completed_date, accrual_start_date, accrual_end_date, in_past_qa_check,
		case when completed_date - accrual_start_date < -90 then 'Failed: program registration 90 days prior to accrual start'
			 when completed_date - accrual_end_date > 30 then 'Failed: program registration 30 days after accrual end'
			 when completed_date - accrual_start_date > 120 then 'Failed; program registration 4 mnths after accrual start'
			 else 'Passed'
		end as in_past_qa_check_alt
	from tmp_sprocket_nov_errors
)

select club_name, completed_date, accrual_start_date, accrual_end_date, in_past_qa_check, in_past_qa_check_alt
from outside_period 
where in_past_qa_check != 'Passed';
/*
Some of these records deserve to be flagged
but we aren't replicating the consistent logic. 
*/

-- check for instances of accounting code inconsistency
select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'accounting and dept code null' and no_acct_qa_check != 'Passed';

-- check for instances of
select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'lessons wrong code' and acct_wrong_qa_check ~* 'lessons wrong code';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code ~* 'lessons wrong code' and acct_wrong_qa_check !~* 'lessons wrong code';

select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'boys registration wrong code' and acct_wrong_qa_check ~* 'boys registration wrong code';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code ~* 'boys registration wrong code' and acct_wrong_qa_check !~* 'boys registration wrong code';

select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'court rental wrong code' and acct_wrong_qa_check ~* 'court rental wrong code';
select * from tmp_sprocket_nov_errors where mulesoft_fail_code ~* 'court rental wrong code' and acct_wrong_qa_check !~* 'court rental wrong code';

-- check for instances of program namming insconsistency
select * from tmp_sprocket_nov_errors where mulesoft_fail_code !~* 'program and package name null' and program_package_name_qa_check != 'Passed';




/***********************************************************************************************************/
-- investigation into canceled invoices with no accrual end date

select * from tmp_sprocket_nov_errors where start_end_date_qa_check ~ 'Failed';

select * from prod_raw.stg_sprocket_registrations where accrual_end_date is null;
select * from prod_raw.stg_sprocket_registrations order by created_date desc limit 20;


select * 
from public.sprocket_registration_details 
where player_registration_cancelled or registration_cancelled_date is not null
; 
