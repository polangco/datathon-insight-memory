/*
Boomer cases that exist in [LOVB-2251 PM and LA 2024 Discounts - Version 2 - Excluding Type 2]
But not in current version
{
	3862990 -- refunded amount covers the difference, 
	2320437, -- was dropped from the subscription table, but not identified as type 2
	2322167, -- was dropped from the subscription table, but not identified as type 2
	2319512, -- was dropped from the subscription table, but not identified as type 2
	4215034, -- refund amount covers difference
	2320029  -- was dropped from the subscription table, but not identified as type 2
}

In current version but not in [Version 2]
{
	2447360, -- type 2 case that should be captured 
	4224000, -- reported refund in subscription but no completed refund transaction in payouts, paid original amount
	2395655, -- reported refund in subscription but no completed refund transaction in payouts, paid original amount
	2970250, -- type 2 case that should be captured
	2687515, -- reported refund in subscription but no completed refund transaction in payouts, paid original amount
	4113076, -- reported refund in subscription but no completed refund transaction in payouts, paid original amount
	3693825, -- type 2 case that should be captured
	4081480, -- reported refund in subscription but no completed refund transaction in payouts, no transactions showing
	4125097, -- reported refund in subscription but no completed refund transaction in payouts, paid original amount
	2887081, -- type 2 case that should be captured
	2752016, 2538003, 4128788, 2401817, 2401818, 2688028, 4224031, 4446759, 3835949, 
	3093042, 2440243, 2953267, 2774587, 2537567, 2537568, 2537569, 3209826, 2328167, 
	2540660, 2540661, 2540662, 4350071, 2406537, 2970251, 2970253, 4051086, 3802767, 
	2688672, 2688673, 2390698, 4019371, 4112555, 2390712, 2434744, 4579517, 2390719, 
	2390728, 4324051, 2395860, 2395861, 2752213, 2834134, 3372244, 4475603, 4113117, 
	4080869, 2968807, 2573035, 2390772, 2394365, 2927869, 2536707, 2536719, 2536720, 
	4380444, 3301668, 4158764, 4119341, 4033330, 2534707, 2391348, 2536761, 2535742, 
	2437952, 2437954, 4081475, 2953541, 2437958, 2953542, 4081479, 2692425, 2360650, 
	2437962, 4081481, 2536785, 2632022, 2821464, 2821465, 2496864, 3781989, 3975953, 
	3699480, 4136817, 4122482, 2392437, 4114307, 4223995, 2418058, 2953610, 2953611, 
	2953613, 2418063, 2419600, 4096399, 2972562, 4136335, 4112790, 2530199, 4124570, 
	2940828, 4112797, 2434463, 2927522, 4051363, 4131239, 2554792, 2953132, 2953612, 
	4174770, 2554809, 4428731, 2603459, 2409418, 2418124, 2543078, 2543079, 2692072, 
	2345961, 4332532, 4115963, 2447359
}
*/

-------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_id;
SELECT 4224000 as invoice_id INTO TEMP TABLE tmp_id;

-- invoices
SELECT
	* 
FROM lovb_491.unified_invoices
WHERE invoice_id = (SELECT invoice_id FROM tmp_id) AND source_system = 'Playmetrics' and source_table = 'subscriptions'
ORDER BY vintage
;
/*
-- subscriptions
SELECT 
	club_name,
	subscription_id, 
	subscription_date,
	status,
	budget, 
	discounts, 
	adjustments, 
	canceled_date, 
	late_fees, 
	additional_fees, 
	service_fees, 
	projected_total, 
	paid_to_date, 
	refunded_to_date,
	min(last_modified) as last_modified
FROM public.playmetrics_subscriptions
WHERE subscription_id = (SELECT invoice_id FROM tmp_id)
GROUP BY 
	club_name,
	subscription_id, 
	subscription_date,
	status,
	budget, 
	discounts, 
	adjustments, 
	canceled_date, 
	late_fees, 
	additional_fees, 
	service_fees, 
	projected_total, 
	paid_to_date, 
	refunded_to_date
ORDER BY last_modified;

-- line items
SELECT 
	club_name, 
	subscription_id, 
	subscription_purchase_date,
	line_item_id, 
	amount,
	amount_refunded,
	status, 
	subscription_status
FROM public.playmetrics_subscription_line_items_latest
WHERE subscription_id = (SELECT invoice_id FROM tmp_id);
*/
-- payouts
SELECT 
	club_name,
	subscription_id, 
	line_item_id,
	receipt,
	payout_date,
	status,
	type,
	line_item_gross,
	line_item_net,
	min(last_modified) as last_modified
FROM public.playmetrics_payouts
WHERE subscription_id = (SELECT invoice_id FROM tmp_id)
GROUP BY
	club_name,
	subscription_id, 
	line_item_id,
	receipt,
	payout_date,
	status,
	type,
	line_item_gross,
	line_item_net
ORDER BY subscription_id, line_item_id, receipt, last_modified
;
/*
-- latest registrations
SELECT * FROM prod_raw.stg_playmetrics_registrations WHERE registration_id = (SELECT invoice_id FROM tmp_id);


-- tracked refunds
SELECT * FROM tmp_refunds_amount WHERE invoice_id = (SELECT invoice_id FROM tmp_id);


-- adjustment candidates
SELECT * FROM tmp_adjustments WHERE invoice_id = (SELECT invoice_id FROM tmp_id);

-- adjusted candidates
SELECT * FROM tmp_invoices_changed_after_the_fact WHERE invoice_id = (SELECT invoice_id FROM tmp_id);

-- summary
SELECT * FROM tmp_summary_changes WHERE invoice_id = (SELECT invoice_id FROM tmp_id);

*/
-------------------------------------------------------------------


