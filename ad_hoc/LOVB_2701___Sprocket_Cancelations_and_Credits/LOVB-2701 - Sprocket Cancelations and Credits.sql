SELECT * FROM sprocket_invoice_details limit 10;;
SELECT * FROM sprocket_registration_details limit 10;
SELECT * FROM sprocket_ar_aging limit 10;

SELECT * FROM sprocket_registration_details WHERE player_registration_id = 1239824;

SELECT 
	club,
	program,
	invoice_id,
	registration_id, 
	unique_transaction_id, 
	player_name,
	total_fee, 
	paid_cash,
	paid_credit,
	total_paid, 
	outstanding
FROM sprocket_ar_aging WHERE registration_id = 61820;

SELECT 
	club,
	invoice_id,
	description,
	item_name
	item_price, 
	item_quantity,
	item_total_price,
	invoice_date :: date as invoice_date, 
	due_date :: date as due_date,
	status
FROM sprocket_invoice_details
WHERE left(invoice_id, 5) = '11737';


WITH _format as (
	SELECT distinct
		club_name,
		accounting_class,
		program_id,
		program_name,
		registration_id, 
		registration,
		registration_season,
		coalesce(accrual_start_date, registration_accrual_start_date, program_accrual_start_date) :: date as accrual_start_date,
		coalesce(accrual_end_date, registration_accrual_end_date, program_accrual_end_date) :: date as accrual_end_date,
		player_registration_id,
		user_id, 
		completed_by,
		completed_date :: date as completed_date,
		family_id, 
		player_id,
		program_list_price,
		discount_amount,
		financial_aid_amount,
		program_fee, 
		admin_fee,
		fee_adjustment,
		total_fee,
		total_paid,
		outstanding, 
		refunded_amount, 
		credited_amount
		
	FROM sprocket_registration_details
)

SELECT 
	max(club_name) as club_name,
	max(accounting_class) as accounting_class,
	max(program_id) as program_id,
	max(program_name) as program_name,
	max(registration_id) as registration_id, 
	max(registration) as registration,
	max(accrual_start_date) as accrual_start_date,
	max(accrual_end_date) as accrual_end_date,
	player_registration_id,
	max(user_id) as user_id, 
	max(completed_by) as completed_by,
	max(completed_date :: date) as completed_date,
	max(family_id) as family_id, 
	max(player_id) as player_id,
	max(program_list_price) as program_list_price,
	max(discount_amount) as discount_amount,
	max(financial_aid_amount) as financial_aid_amount,
	max(program_fee) as program_fee, 
	max(admin_fee) as admin_fee,
	max(fee_adjustment) as fee_adjustment,
	max(total_fee) as total_fee,
	max(total_paid) as total_paid,
	max(outstanding) as outstanding, 
	max(refunded_amount) as refunded_amount, 
	max(credited_amount) as credited_amount
FROM _format
WHERE 
	completed_date BETWEEN '2025-05-01' AND '2025-05-31'
	AND 
	abs(refunded_amount) + abs(credited_amount) > 0
GROUP BY 
	player_registration_id
ORDER BY
	max(club_name),
	max(program_id),
	max(registration_id),
	player_registration_id
;

---------------------------
WITH _format as (
	SELECT distinct
		club_name,
		accounting_class,
		program_id,
		program_name,
		registration_id, 
		registration,
		coalesce(accrual_start_date, registration_accrual_start_date, program_accrual_start_date) :: date as accrual_start_date,
		coalesce(accrual_end_date, registration_accrual_end_date, program_accrual_end_date) :: date as accrual_end_date,
		player_registration_id,
		user_id, 
		completed_by,
		completed_date :: date as completed_date,
		family_id, 
		player_id,
		program_list_price,
		discount_amount,
		financial_aid_amount,
		program_fee, 
		admin_fee,
		fee_adjustment,
		total_fee,
		total_paid,
		outstanding, 
		refunded_amount, 
		credited_amount
		
	FROM sprocket_registration_details
),


_full_credit_issued as (
	SELECT 
		max(club_name) as club_name,
		family_id,
		min(completed_date) as completed_date
	FROM _format
	WHERE 
		completed_date BETWEEN '2025-05-01' AND '2025-05-31'
		AND 
		abs(credited_amount) + abs(refunded_amount) > 0
	GROUP BY 
		family_id
), 

_all_registrations_post_may_1 as (
	SELECT a.*
	FROM _format as a
	WHERE completed_date > '2025-05-01' and exists (
		SELECT 1 
		FROM _full_credit_issued as b
		WHERE (a.family_id = b.family_id and a.club_name = b.club_name) and a.completed_date >= b.completed_date
	)
), 

_more_than_one as (
	SELECT family_id
	FROM _all_registrations_post_may_1
	GROUP BY family_id
	HAVING count(*) > 1
)


SELECT *
FROM _all_registrations_post_may_1 as a 
WHERE exists (
	SELECT 1
	FROM _more_than_one as b 
	WHERE a.family_id = b.family_id
)
ORDER BY family_id, completed_date


;