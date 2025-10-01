-------------------------------------------------------------------
-- latest subscriptions
SELECT
	club_name,
	subscription_id,
	subscription_date,
	billing_account_id,
	player_id, 
	program_name, 
	package_name, 
	budget,
	discounts, 
	adjustments, 
	cancellations,
	late_fees, 
	additional_fees, 
	service_fees,
	projected_total, 
	paid_to_date,
	refunded_to_date,
	outstanding, 
	status,
	last_modified
FROM public.playmetrics_subscriptions_latest
WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982); 

/*
Query 1 OK: SELECT 0
*/

------------------------------------------------------------------- 
-- Check full history for these cases
SELECT
	club_name,
	subscription_id,
	subscription_date,
	billing_account_id,
	player_id, 
	program_name, 
	package_name, 
	budget,
	discounts, 
	adjustments, 
	cancellations,
	late_fees, 
	additional_fees, 
	service_fees,
	projected_total, 
	paid_to_date,
	refunded_to_date,
	outstanding, 
	status,
	min(last_modified) as last_modified
FROM public.playmetrics_subscriptions
WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982)
GROUP BY
	club_name,
	subscription_id,
	subscription_date,
	billing_account_id,
	player_id, 
	program_name, 
	package_name, 
	budget,
	discounts, 
	adjustments, 
	cancellations,
	late_fees, 
	additional_fees, 
	service_fees,
	projected_total, 
	paid_to_date,
	refunded_to_date,
	outstanding, 
	status
ORDER BY subscription_id, min(last_modified); 


-------------------------------------------------------------------
-- checking to see if there is something with completed status
SELECT distinct status FROM public.playmetrics_subscriptions;

/*
| status            |
|-------------------|
|                   |
| Overdue           |
| Canceled          |
| On Hold           |
| On Hold (Overdue) |
| Current           |
| Completed         |
*/

SELECT
	extract(year from subscription_date :: DATE) as sub_year,
	extract(quarter from subscription_date :: DATE) as sub_quarter,
	count(distinct subscription_id) as num_registrations
FROM public.playmetrics_subscriptions_latest
WHERE status = 'Completed'
GROUP BY 
	extract(year from subscription_date :: DATE),
	extract(quarter from subscription_date :: DATE)
ORDER BY
	extract(year from subscription_date :: DATE),
	extract(quarter from subscription_date :: DATE)
;

/*
| sub_year | sub_quarter | num_registrations |
|----------|-------------|-------------------|
|     2022 |           4 |                63 |
|     2023 |           1 |               555 |
|     2023 |           2 |               621 |
|     2023 |           3 |             3,307 |
|     2023 |           4 |             4,923 |
|     2024 |           1 |             2,669 |
|     2024 |           2 |             9,079 |
|     2024 |           3 |             7,428 |
|     2024 |           4 |             6,779 |
|     2025 |           1 |             3,870 |
|     2025 |           2 |             3,691 |
*/

-------------------------------------------------------------------
-- Check last last_modified by club
SELECT club_name, max(last_modified)
FROM public.playmetrics_subscriptions
GROUP BY club_name
ORDER BY club_name;

/*
| club_name                  | last_modified              |
|----------------------------|----------------------------|
| Aspire VB                  | 2025-06-02 08:30:42.810187 |
| Athena Volleyball Academy  | 2025-06-02 08:30:45.995984 |
| Boomers Volleyball Academy | 2025-06-02 08:30:43.8927   |
| Chi City Volleyball Club   | 2025-06-02 08:30:47.680704 |
| Club 801 Volleyball        | 2025-06-02 08:30:48.157422 |
| Club V                     | 2025-06-02 08:30:46.619607 |
| Colorado Juniors VB        | 2025-06-02 08:30:43.372187 |
| KC Power                   | 2025-06-02 08:30:47.171142 |
| Madtown Juniors VB         | 2025-06-02 08:30:44.873729 |
| Meraki VB                  | 2025-06-02 08:30:41.583737 |
| Nova Volleyball Ohio       | 2024-09-18 08:30:33.668994 |***
| One Wisconsin Volleyball   | 2025-06-02 08:30:44.358572 |
| Roots VB                   | 2023-11-29 00:00:27.598308 |***
| Southern California VB     | 2025-06-02 08:30:42.125977 |
| Summerlin                  | 2024-09-25 08:30:33.297893 |***
| Union VB                   | 2025-06-02 08:30:41.271813 |
| VC United                  | 2025-06-02 08:30:45.45646  |
*/


-------------------------------------------------------------------
-- latest subscriptions line item
SELECT
	club_name, 
	line_item_id, 
	subscription_id, 
	subscription_purchase_date,
	due_date, 
	paid_receipt_date,
	program_name, 
	package_name,
	user_id, 
	amount, 
	amount_refunded, 
	service_fee, 
	service_fee_refunded, 
	subscription_status
	status,
	last_modified
FROM public.playmetrics_subscription_line_items_latest
WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982); 

-- compare with last invoice
with _summed_line_item as (
	SELECT
		club_name,  
		subscription_id, 
		max(subscription_purchase_date) as subscription_date,
		sum(amount) as summed_amount, 
		sum(amount_refunded) as summed_refund
	FROM public.playmetrics_subscription_line_items_latest
	WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982)
	GROUP BY club_name, subscription_id
), 

_invoice_history as (
	SELECT
		club_name,
		subscription_id,
		budget,
		discounts, 
		adjustments, 
		cancellations,
		late_fees, 
		additional_fees, 
		service_fees,
		projected_total, 
		paid_to_date,
		refunded_to_date,
		outstanding, 
		status as invoice_status,
		min(last_modified) as last_modified
	FROM public.playmetrics_subscriptions
	WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982)
	GROUP BY
		club_name,
		subscription_id,
		budget,
		discounts, 
		adjustments, 
		cancellations,
		late_fees, 
		additional_fees, 
		service_fees,
		projected_total, 
		paid_to_date,
		refunded_to_date,
		outstanding, 
		status
),

_last_invoice as (
	SELECT subscription_id, max(last_modified) as _last_ 
	FROM _invoice_history 
	GROUP BY subscription_id
), 

_get_last_invoice as (
	SELECT a.*
	FROM _invoice_history as a
	INNER JOIN _last_invoice as b
	ON a.subscription_id = b.subscription_id and a.last_modified = b._last_
)

SELECT 
	a.*,
	budget,
	discounts, 
	adjustments, 
	cancellations,
	late_fees, 
	additional_fees, 
	service_fees,
	projected_total, 
	paid_to_date,
	refunded_to_date,
	outstanding,  
	invoice_status
FROM _summed_line_item as a
LEFT JOIN _get_last_invoice as b
ON a.subscription_id = b.subscription_id
; 


-------------------------------------------------------------------
-- payouts latest
SELECT * 
FROM public.playmetrics_payouts_latest
WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982); 

/*
Query 1 OK: SELECT 0
*/

-- look at full history
SELECT 
	club_name,
	transaction,
	payout_date, 
	receipt, 
	line_item_id, 
	subscription_id, 
	status,
	line_item_gross, 
	line_item_fees, 
	line_item_net,
	min(last_modified) as last_modified
FROM public.playmetrics_payouts
WHERE subscription_id in (2330486, 2357173, 2388089, 2354282, 2342875, 2336320, 2437808, 4112498, 2764974, 2694982)
GROUP BY 
	club_name,
	transaction,
	payout_date, 
	receipt, 
	line_item_id, 
	subscription_id, 
	status,
	line_item_gross, 
	line_item_fees, 
	line_item_net
ORDER BY
	club_name,
	transaction,
	subscription_id, 
	min(last_modified)
;
/*
For each of cases of interest, they exists in a single vintage of the data. For example:
| club_name | transaction | payout_date | receipt | line_item_id | subscription_id | status    | line_item_gross | line_item_fees | line_item_net | last_modified              |
|-----------|-------------|-------------|---------|--------------|-----------------|-----------|-----------------|----------------|---------------|----------------------------|
| Meraki VB |    15745158 | 2024-08-27  | 7169273 |      8698100 |         4112498 | completed |             500 |           14.8 |         485.2 | 2024-08-29 08:33:10.959972 |
| Meraki VB |    17248263 | 2024-10-13  | 7664169 |      8698101 |         4112498 | completed |             400 |           11.9 |         388.1 | 2024-10-15 08:32:01.173673 |
| Meraki VB |    18328041 | 2024-11-12  | 8031764 |      8698102 |         4112498 | completed |             400 |           11.9 |         388.1 | 2024-11-14 09:33:39.899264 |

Note each record has a unique transaction, receipt, and line item. This is pulled from the full history.

Based on output the payouts are windowed to approx. 2 months based on when the payout date occured.
*/

-- check range of payouts and purchase in latest
SELECT 
	min(payout_date::date) min_payout, 
	max(payout_date::date) max_payout, 
	min(purchase_date::date) min_purchase, 
	max(purchase_date::date) max_purchase
FROM public.playmetrics_payouts_latest;

/*
| min_payout | max_payout | min_purchase | max_purchase |
|------------|------------|--------------|--------------|
| 2025-03-29 | 2025-05-31 | 2023-10-02   | 2025-05-29   |
*/

-- checking out the purchase_date = 2023-10-02 case
SELECT 
	club_name,
	subscription_id,
	subscription_date,
	budget,
	discounts, 
	adjustments, 
	projected_total, 
	paid_to_date,
	outstanding, 
	status,
	min(last_modified) :: date as last_modified
FROM public.playmetrics_subscriptions as a
WHERE exists (
	SELECT distinct subscription_id
	FROM public.playmetrics_payouts_latest as b
	WHERE purchase_date = '2023-10-02' and a.subscription_id = b.subscription_id
)
GROUP BY
	club_name,
	subscription_id,
	subscription_date,
	budget,
	discounts, 
	adjustments, 
	projected_total, 
	paid_to_date,
	outstanding, 
	status
ORDER BY min(last_modified)
;

/*
| club_name | subscription_id | subscription_date | budget | discounts | adjustments | projected_total | paid_to_date | outstanding | status            | last_modified |
|-----------|-----------------|-------------------|--------|-----------|-------------|-----------------|--------------|-------------|-------------------|---------------|
| Club V    |         2047722 | 2023-10-02        |   2200 |         0 |           0 |            2200 |          500 |             | Current           | 2023-10-04    |
| Club V    |         2047722 | 2023-10-02        |   2200 |         0 |           0 |            2200 |          500 |        1700 | Current           | 2023-10-30    |
| Club V    |         2047722 | 2023-10-02        |   2200 |         0 |           0 |            2200 |          500 |        1700 | On Hold (Overdue) | 2023-11-04    |
| Club V    |         2047722 | 2023-10-02        |   2200 |         0 |           0 |            2200 |          500 |        1700 | On Hold           | 2023-11-05    |
| Club V    |         2047722 | 2023-10-02        |   2200 |         0 |         0.1 |          2200.1 |        688.9 |      1511.2 | Current           | 2023-11-08    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |        688.9 |      1311.2 | Current           | 2024-02-15    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |        877.8 |      1122.3 | Current           | 2024-12-02    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |       1066.7 |       933.4 | Current           | 2025-01-02    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |       1255.6 |       744.5 | Current           | 2025-02-02    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |       1444.5 |       555.6 | Current           | 2025-03-02    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |       1633.4 |       366.7 | Current           | 2025-04-02    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |       1822.3 |       177.8 | Current           | 2025-05-02    |
| Club V    |         2047722 | 2023-10-02        |   2200 |      -200 |         0.1 |          2000.1 |       2000.1 |           0 | Completed         | 2025-06-02    |
*/

-------------------------------------------------------------------
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


_leagueapps as (
	SELECT distinct
		'LeagueApps' as source_system,
	    invoice_id  :: numeric :: bigint as invoice_id
	FROM public.leagueapps_registrations
	WHERE abs(total_amount_due :: numeric - price :: numeric) > 0
)

SELECT source_system, invoice_id
FROM _playmetrics
UNION
SELECT source_system, invoice_id
FROM _leagueapps
;



