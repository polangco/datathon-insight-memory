-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_adjustments;
-- Cases where there is some adjustment observed over entire history
-- table with all adjustments across both datasets
with _playmetrics as (
	SELECT distinct
		'Playmetrics' as source_system,
		subscription_id :: numeric :: int as invoice_id
	FROM public.playmetrics_subscriptions
	WHERE 
		abs(discounts + adjustments + cancellations + late_fees + additional_fees + service_fees) :: numeric > 0 
		OR budget != projected_total
),

_playmetrics_distinct as (
	SELECT distinct
		'Playmetrics' as source_system, 
		subscription_id :: numeric :: int as invoice_id,
		projected_total
	FROM public.playmetrics_subscriptions
),

_leagueapps_distinct as (
	SELECT distinct 
		'LeagueApps' as source_system,
		invoice_id :: int as invoice_id, 
		round(total_amount_due::numeric, 2) as projected_total
	FROM public.leagueapps_registrations
),

_union as (
	SELECT source_system, invoice_id, projected_total FROM _playmetrics_distinct
	UNION
	SELECT source_system, invoice_id, projected_total FROM _leagueapps_distinct
),

_variance as (
	SELECT 
		source_system,
		invoice_id
	FROM _union
	GROUP BY invoice_id, source_system
	HAVING max(projected_total) - min(projected_total) > 0
),

_leagueapps as (
	SELECT distinct
		'LeagueApps' as source_system,
	    invoice_id  :: numeric :: bigint as invoice_id
	FROM public.leagueapps_registrations
	WHERE abs(total_amount_due :: numeric - price :: numeric) > 0
)

SELECT source_system, invoice_id
INTO TEMPORARY TABLE tmp_adjustments
FROM _playmetrics
UNION
SELECT source_system, invoice_id
FROM _leagueapps
UNION 
SELECT source_system, invoice_id
FROM _variance
;

SELECT COUNT(*) FROM tmp_adjustments;

-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_invoice_ids;
-- get all invoice_ids from the registrations tables
SELECT distinct source_system, invoice_id
INTO TEMPORARY TABLE tmp_invoice_ids
FROM lovb_491.unified_invoices
WHERE source_table in ('subscriptions', 'registrations');

-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_refunds_amount;
-- get all of the refunds and calculate how much revenue is refunded by invoice
with _refund as (
	SELECT distinct
		source_system,
		invoice_id, 
		line_item_id, 
		max(payout_date) as payout_date, 
		min(abs(amount)) as refund
	FROM lovb_491.unified_refunds
	GROUP BY 
		source_system,
		invoice_id, 
		line_item_id
)

SELECT source_system, invoice_id, sum(refund) as refund 
INTO TEMPORARY TABLE tmp_refunds_amount
FROM _refund
GROUP BY source_system, invoice_id
;

-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_invoices_changed_after_the_fact;
-- get all invoices for the specified time period
-- remove all invoices with refunds
-- remove any invoices for Eastside Columbus (club_id = 80) prior to June 2024
WITH _base_data as (
	SELECT 
		source_system, 
		source_table,
		club_id, 
		club_name, 
		invoice_id,
		billing_account_id, 
		created_date,
		amount,
		invoice_status,
		vintage
	FROM lovb_491.unified_invoices a
	WHERE 
		created_date BETWEEN '2024-01-01' and '2025-06-30'
		-- exclude Eastside Athletics prior to June 2024
		AND NOT (club_id = 80 and created_date < '2024-06-01')
		-- include only cases with observed adjustment
		AND EXISTS (
			SELECT 1
			FROM tmp_adjustments as c
			WHERE a.source_system = c.source_system AND a.invoice_id = c.invoice_id
		)
		-- exclude cases where the invoice_id exists in registration and line time tables from the line item tables
		AND NOT EXISTS (
			SELECT 1 
			FROM tmp_invoice_ids as d
			WHERE 
				a.source_system = d.source_system 
				AND a.invoice_id = d.invoice_id 
				AND a.source_table in ('subscriptions line item', 'transactions') 
		)
), 

-- create an identifier for when the amount changes for a given invoice_id
_partition as (
	SELECT 
		source_system, 
		source_table,
		club_id, 
		club_name, 
		invoice_id,
		billing_account_id, 
		created_date,
		amount,
		invoice_status,
		vintage,
		row_number() OVER(PARTITION BY source_system, invoice_id, amount ORDER BY vintage) as row_id
	FROM _base_data
),

-- Take just the first instance of each change for a given invoice
_slice as (
	SELECT 
		source_system,
		source_table, 
		club_id, 
		club_name, 
		invoice_id,
		billing_account_id, 
		created_date,
		amount,
		invoice_status,
		vintage
	FROM _partition
	WHERE row_id = 1
), 

-- Identify those cases where a change exists
_has_changes as (
	SELECT source_system, invoice_id
	FROM _slice
	GROUP BY source_system, invoice_id
	HAVING count(1) > 1
),

_filter_to_changes as (
	SELECT 
		a.source_system, 
		a.source_table,
		a.club_id, 
		a.club_name, 
		a.invoice_id,
		a.billing_account_id, 
		a.created_date,
		CASE WHEN a.amount is null THEN 0 ELSE a.amount END as amount,
		a.invoice_status,
		a.vintage,
		row_number() OVER(PARTITION BY a.source_system, a.invoice_id ORDER BY vintage) as instance_id
	FROM _slice as a
	INNER JOIN _has_changes as b
	ON a.source_system = b.source_system AND a.invoice_id = b.invoice_id
), 

-- create a mask to exclude cases where they are canceled and would not have been included in the original Netsuite uplaod
_not_canceled as (
	SELECT distinct source_system, invoice_id
	FROM _filter_to_changes
	WHERE NOT (instance_id = 1 and invoice_status in ('Canceled', 'Void', 'Deleted'))
)

-- package all changes
SELECT
	a.source_system, 
	a.source_table,
	a.club_id, 
	a.club_name, 
	a.invoice_id,
	a.billing_account_id, 
	a.created_date,
	a.amount,
	a.invoice_status,
	a.vintage,
	a.instance_id
INTO TEMPORARY TABLE tmp_invoices_changed_after_the_fact
FROM _filter_to_changes as a
RIGHT JOIN _not_canceled as b
ON a.source_system = b.source_system AND a.invoice_id = b.invoice_id
ORDER BY source_system, club_id, invoice_id, vintage
;


-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_summary_changes;
-- get all of the first instances of an invoice
WITH _first as (
	SELECT * 
	FROM tmp_invoices_changed_after_the_fact
	WHERE instance_id = 1
), 

-- get all of the last instances of an invoice
_last_id as (
	SELECT source_system, invoice_id, max(instance_id) as instance_id
	FROM tmp_invoices_changed_after_the_fact
	GROUP BY source_system, invoice_id
),

_last as (
	SELECT a.*
	FROM tmp_invoices_changed_after_the_fact as a
	INNER JOIN _last_id as b
	ON a.source_system = b.source_system 
		AND a.invoice_id = b.invoice_id 
		AND a.instance_id = b.instance_id
), 

-- compile first and last into a single table
_merge as (
	SELECT 
		a.source_system, 
		a.source_table,
		a.club_id, 
		a.club_name, 
		a.invoice_id,
		a.billing_account_id, 
		a.created_date,
		a.vintage as original_reported_date,
		a.amount as original_reported_amount,
		a.invoice_status as original_reported_status,
		b.vintage as last_reported_date,
		b.amount as last_reported_amount,
		b.invoice_status as last_reported_status,
		b.amount - a.amount as amount_change,
		CASE WHEN a.amount > b.amount THEN 'Discount Applied' ELSE 'Fees Applied' END as change_type
	FROM _first as a 
	LEFT JOIN _last as b
	ON a.source_system = b.source_system AND a.invoice_id = b.invoice_id
), 

-- make sure that a reported refund doesn't cover the amount_change
_exclude_covered_by_refunds as (
	SELECT a.*, b.refund
	FROM _merge as a
	LEFT JOIN tmp_refunds_amount as b
	ON a.source_system = b.source_system and a.invoice_id = b.invoice_id
	WHERE 
		b.refund is null
		or abs(a.amount_change) != b.refund
),

-- Make sure that the first and the last are in different months
_final as (
	SELECT * 
	FROM _exclude_covered_by_refunds 
	WHERE 
		(
			extract(year from original_reported_date) = extract(year from last_reported_date)
			AND extract(month from original_reported_date) < extract(month from last_reported_date)
		)
		OR extract(year from original_reported_date) < extract(year from last_reported_date)
)

SELECT 
	* 
INTO TEMPORARY TABLE tmp_summary_changes
FROM _final
ORDER BY source_system, club_id, created_date, invoice_id
;

-----------------------------------------------------------------------------------------------------------------------------
-- pull detailed view of invoices with changes - event table with each instances of the invoice with changes
SELECT * 
FROM tmp_invoices_changed_after_the_fact as a 
WHERE EXISTS (SELECT 1 FROM tmp_summary_changes as b WHERE a.source_system = b.source_system and a.invoice_id = b.invoice_id);

-- format summary table
SELECT 
	source_system, 
	source_table,
	club_id, 
	club_name, 
	invoice_id,
	billing_account_id, 
	created_date,
	original_reported_date,
	original_reported_amount,
	original_reported_status,
	extract(year from original_reported_date) :: text || '-' || extract(month from original_reported_date) :: text as original_month_year,
	last_reported_date,
	last_reported_amount,
	last_reported_status,
	extract(year from last_reported_date) :: text || '-' || extract(month from last_reported_date) :: text as last_month_year,
	amount_change,
-- 	refund,
	change_type 
FROM tmp_summary_changes;

-----------------------------------------------------------------------------------------------------------------------------
-- check by source
select source_system, change_type, sum(amount_change) as delta, count(*) as n 
from tmp_summary_changes 
group by source_system, change_type
order by source_system, change_type;

-- check by by club
select club_id, club_name, change_type, sum(amount_change) as delta, count(*) as n 
from tmp_summary_changes 
where change_type = 'Discount Applied'
group by club_id, club_name, change_type
order by club_id, club_name, change_type;

-- check against 10 cases from Jill
SELECT *
FROM tmp_summary_changes
WHERE invoice_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982);

SELECT *
FROM tmp_invoices_changed_after_the_fact
WHERE invoice_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982);

-----------------------------------------------------------------------------------------------------------------------------


SELECT * FROM tmp_summary_changes WHERE club_name ~* 'boomers';