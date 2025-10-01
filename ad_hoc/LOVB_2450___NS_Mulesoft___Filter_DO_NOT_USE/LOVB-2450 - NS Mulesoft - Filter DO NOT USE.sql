-- This first step is just to structure the data to be more aligned to the data pulled for mulesoft
WITH _format_data as (
	SELECT 
		club_name,
		program_type,
		registration_name as registration,
		player_name,
		accounting_class, 
		accrual_start_date :: date as accrual_start_date,
		accrual_end_date :: date as accrual_end_date,
		completed_date :: TIMESTAMP as completed_date
	FROM public.sprocket_registration_details as a
	LEFT JOIN (
		SELECT DISTINCT
			player_id, player_name
		FROM public.sprocket_player_contacts
	) as b
	ON a.player_id = b.player_id
),

-- Here is the logic for checking the accounting class relative to "DO NOT USE"
-- If the accounting class includes is "Club Dues" and includes "DO NOT USE" and has an accrual start date > April 1, 2025 then fail
-- If the accounting class does not include "Club Dues" and includes "DO NOT USE" and has an accrual start date > September 8, 2025 then fail
_apply_logic as (
	SELECT
	  *,
	  CASE
	  	WHEN accounting_class ~ 'DO NOT USE' --- new exception
	  		THEN 'Failed: DO NOT USE - Assign location manually' -- new flag
	    WHEN accounting_class ~ 'DO NOT USE' AND accounting_class ~* 'club dues' AND accrual_start_date > to_date('20250401', 'YYYYMMDD')
	    	THEN  'Failed: Club Dues with DNU after 2025-04-01'
	    WHEN  accounting_class ~ 'DO NOT USE' AND accrual_start_date > to_date('20250908', 'YYYYMMDD')
	    	THEN 'Failed: Program with DNU after 2025-09-08'
	    ELSE 'Passed'
	  end as flag_do_not_use
	FROM _format_data
) 

-- Should return 292 records as of April 28, 2025
-- All flagged cases will be 'Failed: DO NOT USE - Assign location manually'
SELECT * 
FROM _apply_logic 
WHERE 
	flag_do_not_use ~ 'Failed' 
	AND completed_date BETWEEN to_date('20250401', 'YYYYMMDD') AND to_date('20250430', 'YYYYMMDD')
;



-- example of combo of program type and accounting class where DO NOT USE present
SELECT DISTINCT
	club_name, 
	program_type, 
	accounting_class
FROM public.sprocket_registration_details
WHERE accounting_class ~ 'DO NOT USE'
ORDER BY club_name, program_type
;