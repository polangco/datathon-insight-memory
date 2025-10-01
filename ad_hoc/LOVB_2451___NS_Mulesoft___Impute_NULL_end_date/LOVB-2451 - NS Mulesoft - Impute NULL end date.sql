-- This first step is just to structure the data to be more easier to work with
WITH _format_data as (
	SELECT 
		club,
		unique_transaction_id,
		accounting_class,
		accrual_start_date :: date as accrual_start_date, 
		accrual_end_date :: date as accrual_end_date,
		completed_date :: TIMESTAMP as completed_date
	FROM public.invoices_error_march
)

-- Here is the logic to be implemented	
/************************************************************************************
Need confirmation from Jill and team that the impute for accrual_start_date 
should be applied as shown below. 

If yes, then both accrual start date and accrual end date imputations should be 
applied in full. 

If no, 
 - Then the accrual_start_date imputation can be ignored.
 - The accrual_end_date cases with "WHEN accrual_start_date IS NULL" can be ignored
 - But the remaining accrual_end_date imputation should be applied  
************************************************************************************/
SELECT
	club,
	unique_transaction_id,
	accounting_class,
	
	-- Accrual start date imputation - TBC by jill
	CASE
		-- if the start date is null then assign completed date 
		WHEN accounting_class IS NULL THEN accrual_start_date
		WHEN accrual_start_date IS NULL THEN completed_date :: date
		ELSE accrual_start_date
	END accrual_start_date,
	
	-- Accrual end date imputation
	CASE
		WHEN accounting_class IS NULL THEN accrual_end_date

		-- if accrual start and end date are null and Lessons or Merchandise then set to completed date - TBC by jill
		WHEN accrual_start_date IS NULL AND accrual_end_date IS NULL AND accounting_class ~* '(Lessons|Merchandise)' THEN completed_date :: date 
		-- if accrual start and end date are null and NOT Lessons or Merchadise then set to completed date + 2 months - TBC by jill
		WHEN accrual_start_date IS NULL AND accrual_end_date IS NULL THEN (completed_date + INTERVAL '2 months') :: date

		-- if accrual end date is null and Lessons or Merchandise then set to start date
		WHEN accrual_end_date IS NULL AND accounting_class ~* '(Lessons|Merchandise)' THEN accrual_start_date
		-- if accrual end date is null and NOT Lessons or Merchadise then set to start date + 2 months
		WHEN accrual_end_date IS NULL THEN (accrual_start_date + INTERVAL '2 months') :: date
		ELSE accrual_end_date
	END as accrual_end_date,
	
	completed_date
FROM _format_data
;