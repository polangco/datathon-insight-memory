/***********************************************************************************************/
DROP TABLE IF EXISTS tmp_graph;

with _pre_id_graph as (
	SELECT distinct email, person_id as lovpid FROM prod_marketing.dim_braze_families WHERE is_valid
	UNION
	SELECT distinct email, person_id as lovpid FROM prod_marketing.dim_braze_insiders WHERE is_valid
	UNION
	SELECT distinct email, person_id as lovpid FROM prod_marketing.dim_braze_season_tickets
	UNION
	SELECT distinct email, person_id as lovpid FROM prod_marketing.dim_braze_single_match_tickets
	
), 

_rank as (
	SELECT 
		*, 
		row_number() over(partition by email order by lovpid) as row_id
	FROM _pre_id_graph
	WHERE email is not null
),

_final as (
	SELECT email, lovpid
	FROM _rank
	WHERE row_id = 1
)

SELECT *
INTO TEMPORARY TABLE tmp_graph
FROM _final
;

SELECT count(*) as n, count(distinct email) as n_email, count(distinct lovpid) as n_id 
FROM tmp_graph;


/***********************************************************************************************/
-- Shopify

DROP TABLE IF EXISTS tmp_shopify_orders;
with _parse as (
	SELECT  
		id as order_id, 
		created_at :: date as order_date,
		current_total_price :: numeric as total_invoice_amount,
		customer ->> 'id' as customer_id,
		customer ->> 'email' as email,
		customer -> 'default_address' ->> 'phone' as phone_number,
		customer ->> 'first_name' as first_name,
		customer ->> 'last_name' as last_name,
		customer -> 'default_address' ->> 'address1' as address_street,
		customer -> 'default_address' ->> 'zip' as address_zip,
		customer -> 'default_address' ->> 'city' as address_city,
		customer -> 'default_address' ->> 'province' as address_state,
		customer -> 'default_address' ->> 'country' as address_country,
		line_items as line_items_object
			
	FROM shopify_prod.orders
	WHERE not test and financial_status = 'paid'
),

_unnested_items as (
    SELECT 
        _parse.*,
        jsonb_array_elements(line_items_object) as line_item
    FROM _parse
),

_parse_items as (
	SELECT 
		order_id, 
		order_date,
		total_invoice_amount,
		customer_id, 
		email, 
		phone_number, 
		first_name, 
		last_name, 
		address_street, 
		address_zip, 
		address_state, 
		address_country, 
		line_item ->> 'id' as item_id,
		line_item ->> 'name' as item_name,
		line_item ->> 'price' as price, 
		line_item ->> 'quantity' as quantity
	FROM _unnested_items
),

_final as (
	SELECT
		order_id :: bigint as order_id, 
		order_date,
		extract(day from order_date) :: int as order_day,
		extract(month from order_date) :: int as order_month,
		extract(year from order_date) :: int as order_year,
		total_invoice_amount :: float as total_invoice_amount,
		customer_id :: bigint as customer_id, 
		case when customer_id is null then 'unknown' else 'known' end as customer_status,
		email, 
		regexp_replace(phone_number, '[^0-9]', '', 'g') as phone_number,
		first_name, 
		last_name, 
		address_street, 
		address_zip, 
		address_state, 
		address_country, 
		item_id :: bigint item_id, 
		price :: numeric as price, 
		quantity :: numeric as quantity,
		case 
			when item_name ~* 'adidas' then 'adidas'
			when item_name ~* 'atlanta' then 'atlanta'
			when item_name ~* 'austin' then 'austin'
			when item_name ~* 'houston' then 'houston'
			when item_name ~* 'madison' then 'madison'
			when item_name ~* 'omaha' then 'omaha'
			when item_name ~* 'salt lake' then 'salt lake'
			else 'lovb'
		end as merch_category_details,
		case 
			when item_name ~* 'adidas' then 'league'
			when item_name ~* 'atlanta' then 'team'
			when item_name ~* 'austin' then 'team'
			when item_name ~* 'houston' then 'team'
			when item_name ~* 'madison' then 'team'
			when item_name ~* 'omaha' then 'team'
			when item_name ~* 'salt lake' then 'team'
			else 'league'
		end as merch_category
	FROM _parse_items
) 

SELECT * 
INTO TEMPORARY TABLE tmp_shopify_orders
FROM _final
; 

-----------------
-- quick checks
SELECT count(*) as n_r, count(distinct customer_id) as n_id, count(distinct email) as n_email FROM tmp_shopify_orders;
SELECT count(*) as n_r, count(distinct customer_id) as n_id, count(distinct email) as n_email FROM tmp_shopify_orders WHERE email is not null;
SELECT * FROM tmp_shopify_orders LIMIT 10;

-----------------
DROP TABLE IF EXISTS tmp_shopify_profile;
-- add in lovpid 
-- filter to appropriate date range and append lovpid
with _identifiable as (
	SELECT
		* 
	FROM tmp_shopify_orders
	WHERE email is not null and order_date >= '2024-10-01' and email != 'jesse.hahn@lovb.com'
),

_add_id as (
	SELECT 
		a.*,
		coalesce(b.lovpid, gen_random_uuid()) as lovpid
	FROM _identifiable as a
	LEFT JOIN tmp_graph as b
	ON a.email = b.email
), 

-- handle defining the market
_market as (
	SELECT
		lovpid,
		address_zip, 
		address_country,
		case 
			when address_zip ~ '^(300|301|302|303|305|306|310|311|312)' and address_country = 'United States' then 'Atlanta'
			when address_zip ~ '^(787|786|789)' and address_country = 'United States' then 'Austin'
			when address_zip ~ '^(770|773|774|775|776|777)' and address_country = 'United States' then 'Houston'
			when address_zip ~ '^(53|61|52|54)' and address_country = 'United States' then 'Madison'
			when address_zip ~ '^(68|51|54|66)' and address_country = 'United States' then 'Omaha'
			when address_zip ~ '^(840|841|842|843|844)' and address_country = 'United States' then 'Salt Lake'
			when address_country = 'United States' then 'Non-Market US'
			when coalesce(address_country, '') = '' then 'Unknown'
			else 'International'
		end as shopify_market,
		max(order_date) as order_date
	FROM _add_id
	GROUP BY lovpid, address_zip, address_country
),

_market_rank as (
	SELECT 
		*,
		row_number() over(partition by lovpid order by order_date desc) as row_id
	FROM _market 
),

_market_select as (
	SELECT * 
	FROM _market_rank
	WHERE row_id = 1
),

-- merch preference
_merch_detail_type as (
	SELECT 
		lovpid, 
		merch_category_details,
		count(*) as n
	FROM _add_id
	GROUP BY lovpid, merch_category_details
),

_merch_details_rank as (
	SELECT 
		*, 
		row_number() over(partition by lovpid order by n) as row_id
	FROM _merch_detail_type
),

_merch_details_select as (
	SELECT lovpid, merch_category_details
	FROM _merch_details_rank
	WHERE row_id = 1
),

_merch_cat_type as (
	SELECT 
		lovpid, 
		merch_category,
		count(*) as n
	FROM _add_id
	GROUP BY lovpid, merch_category
), 

_merch_cat_rank as (
	SELECT 
		*, 
		row_number() over(partition by lovpid order by n) as row_id
	FROM _merch_cat_type
),

_merch_cat_select as (
	SELECT lovpid, merch_category
	FROM _merch_cat_rank
	WHERE row_id = 1
),

-- get deduplicated revenue by person
_order_amount as (
	SELECT 
		order_id, 
		max(total_invoice_amount) as revenue,
		lovpid
	FROM _add_id
	GROUP BY order_id, lovpid
),

_revenue as (
	SELECT 
		lovpid,
		sum(revenue) as revenue
	FROM _order_amount
	GROUP BY lovpid
),

-- count orders and items
_counts as (
	SELECT 
		lovpid,
		sum(quantity) as quantity,
		count(distinct order_id) as n_orders
	FROM _add_id
	GROUP BY lovpid
)

SELECT 
	a.lovpid,
	d.merch_category_details,
	e.merch_category,
	COALESCE(c.shopify_market, 'Unknown') as shopify_market,
	a.quantity,
	a.n_orders, 
	COALESCE(b.revenue, 0) as revenue
INTO TEMPORARY TABLE tmp_shopify_profile
FROM _counts as a
LEFT JOIN _revenue as b
on a.lovpid = b.lovpid
LEFT JOIN _market_select as c
on a.lovpid = c.lovpid
LEFT JOIN _merch_details_select as d
on a.lovpid = d.lovpid
LEFT JOIN _merch_cat_select as e
on a.lovpid = e.lovpid
;

-----------------
-- quick checks
SELECT count(*) as n, count(distinct lovpid) as n_id FROM tmp_shopify_profile;
SELECT * FROM tmp_shopify_profile LIMIT 10;
SELECT shopify_market, count(*) as n FROM tmp_shopify_profile GROUP BY shopify_market;
-----------------


/***********************************************************************************************/
-- Club
DROP TABLE IF EXISTS tmp_club_profile;

-- base club profile
with _club_profile as (
	SELECT 
		person_id as lovpid,
		case 
			when home_zip ~ '^(300|301|302|303|305|306|310|311|312)' or club_id in(19, 29, 123) then 'Atlanta'
			when home_zip ~ '^(787|786|789)' and club_id in (10, 9, 76) then 'Austin'
			when home_zip ~ '^(770|773|774|775|776|777)' or club_id in (5, 44) then 'Houston'
			when home_zip ~ '^(53|61|52|54)' or club_id in (15, 23, 33) then 'Madison'
			when home_zip ~ '^(68|51|54|66)' or club_id in (50) then 'Omaha'
			when home_zip ~ '^(840|841|842|843|844)' or club_id in (28, 40, 121) then 'Salt Lake'
			else 'Non-Market US'
		end as club_market,
		case when active_status = 'Not Active' then 0 else 1 end as is_active_club_member,
		case when active_status = 'Not Active' then 1 else 0 end as is_non_active_club_member,
		last_updated
	FROM prod_marketing.dim_braze_families as a
	WHERE is_valid and exists (SELECT 1 FROM tmp_graph as b WHERE a.person_id = b.lovpid)
), 

_club_rank as (
	SELECT 
		*, 
		row_number() over(partition by lovpid order by last_updated desc) as row_id
	FROM _club_profile
),

_club_select as (
	SELECT 
		*
	FROM _club_rank
	WHERE row_id = 1
),

-- revenue metrics
_club_revenue as (
	SELECT 
		lovpid, 
		sum(case when payout_date >= '2024-10-01' then amount else 0 end) as revenue_since_oct,
		sum(amount) as revenue_life_time
	FROM prod_id_graph.fct_transactions_lovid
	WHERE lovpid is not null
	GROUP BY lovpid
),

_club_revenue_parent as (
	SELECT 
		unique_parent_id as lovpid, 
		sum(case when payout_date >= '2024-10-01' then amount else 0 end) as revenue_since_oct,
		sum(amount) as revenue_life_time
	FROM prod_id_graph.fct_transactions_lovid
	WHERE unique_parent_id is not null
	GROUP BY unique_parent_id
),

_club_revenue_player as (
	SELECT 
		unique_player_id as lovpid, 
		sum(case when payout_date >= '2024-10-01' then amount else 0 end) as revenue_since_oct,
		sum(amount) as revenue_life_time
	FROM prod_id_graph.fct_transactions_lovid
	WHERE unique_player_id is not null
	GROUP BY unique_player_id
)

SELECT 
	a.lovpid, 
	a.is_active_club_member, 
	a.is_non_active_club_member,
	a.club_market, 
	coalesce(b.revenue_since_oct, c.revenue_since_oct, d.revenue_since_oct, 0) as revenue_since_oct,
	coalesce(b.revenue_life_time, c.revenue_life_time, d.revenue_life_time, 0) as revenue_life_time
INTO TEMPORARY TABLE tmp_club_profile
FROM _club_select as a
LEFT JOIN _club_revenue as b 
ON a.lovpid = b.lovpid
LEFT JOIN _club_revenue_parent as c
ON a.lovpid = c.lovpid
LEFT JOIN _club_revenue_player as d
ON a.lovpid = d.lovpid
;

-----------------
-- quick checks
SELECT count(*) as n, count(distinct lovpid) as n_id FROM tmp_club_profile;
SELECT * FROM tmp_club_profile LIMIT 10;
SELECT club_market, count(*) as n FROM tmp_club_profile GROUP BY club_market;
-----------------


/***********************************************************************************************/
-- insider

DROP TABLE IF EXISTS tmp_insider;

with _insider_profile as (
	SELECT 
		person_id as lovpid,
		case 
			when home_zip ~ '^(300|301|302|303|305|306|310|311|312)' and country = 'United States' then 'Atlanta'
			when home_zip ~ '^(787|786|789)' and country = 'United States' then 'Austin'
			when home_zip ~ '^(770|773|774|775|776|777)' and country = 'United States' then 'Houston'
			when home_zip ~ '^(53|61|52|54)' and country = 'United States' then 'Madison'
			when home_zip ~ '^(68|51|54|66)' and country = 'United States' then 'Omaha'
			when home_zip ~ '^(840|841|842|843|844)' and country = 'United States' then 'Salt Lake'
			when country = 'United States' then 'Non-Market US'
			when coalesce(country, '') = '' then 'Unknown'
			else 'International'
		end as insider_market,
		max(last_updated) as last_updated
	FROM prod_marketing.dim_braze_insiders a 
	WHERE is_valid and not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email)
	GROUP BY person_id, home_zip, country
), 

_insider_rank as (
	SELECT 
		*,
		row_number() over(partition by lovpid order by last_updated desc) as row_id
	FROM _insider_profile
)

SELECT 
	lovpid, 
	insider_market
INTO TEMPORARY TABLE tmp_insider
FROM _insider_rank
WHERE row_id = 1;

-----------------
-- quick checks
SELECT count(*) as n, count(distinct lovpid) as n_id FROM tmp_insider;
SELECT * FROM tmp_insider LIMIT 10;
SELECT insider_market, count(*) as n FROM tmp_insider GROUP BY insider_market;
-----------------

/***********************************************************************************************/
-- ticket purchaser 

DROP TABLE IF EXISTS tmp_single_match;

with _single_profile as (
	SELECT email, count(distinct event_code) as n_matches
	FROM prod_intermediate.int_single_ticket_purchase
	GROUP BY email 
),

-- markets
_single_markets as (
	SELECT
		email,
		pro_market,
		count(*) n
	FROM prod_intermediate.int_single_ticket_purchase
	GROUP BY email , pro_market
),

_single_markets_rank as (
	SELECT 
		*,
		row_number() over(partition by email order by n desc) as row_id
	FROM _single_markets
),

_single_markets_select as (
	SELECT 
		email,
		case 
			when pro_market ~* 'lovb' then 'Kansas City' 
			else pro_market 
		end as single_market
	FROM _single_markets_rank
	WHERE row_id = 1
),

-- revenue
_single_event as (
	SELECT regexp_split_to_table(event_code, '/') AS event_code, email
	FROM prod_intermediate.int_single_ticket_purchase
	WHERE email is not null
), 

_single_cust_count as (
	SELECT 
		event_code,
		count(distinct email) as n_cust
	FROM _single_event
	GROUP BY event_code
),

_per_cust_rev as (
	SELECT 
		email, 
		sum(tickets_sold / n_cust :: numeric) as n_single_tickets, 
		sum(gross_amount / n_cust :: numeric) as apportioned_single_revenue
	FROM _single_event as a
	LEFT JOIN _single_cust_count as b
	ON a.event_code = b.event_code
	LEFT JOIN public.segment_venn_single_ticket_revenue as c
	ON a.event_code = c.event_code
	GROUP BY email
),

_single_final as (
	SELECT
		COALESCE(d.lovpid, gen_random_uuid()) as lovpid, 
		a.n_matches, 
		c.n_single_tickets, 
		c.apportioned_single_revenue,
		b.single_market
	FROM _single_profile as a
	LEFT JOIN _single_markets_select as b
	on a.email = b.email
	LEFT JOIN _per_cust_rev as c
	ON a.email = c.email
	LEFT JOIN tmp_graph as d
	ON a.email = d.email
)

SELECT * 
INTO TEMPORARY TABLE tmp_single_match
FROM _single_final
;

-----------------
-- quick checks
SELECT count(*) as n, count(distinct lovpid) as n_id FROM tmp_single_match;
SELECT * FROM tmp_single_match LIMIT 10;
SELECT single_market, count(*) as n , sum(apportioned_single_revenue) as r FROM tmp_single_match GROUP BY single_market;
-----------------

/***********************************************************************************************/
-- Season Ticket Holder

DROP TABLE IF EXISTS tmp_sth_profile;

with _sth_profile as (
	SELECT person_id as lovpid, pro_team as sth_market 
	FROM prod_marketing.dim_braze_season_tickets
	WHERE pro_team != 'Employee'
),

_sth_cust_n as (
	SELECT 
		sth_market,
		count(*) as n
	FROM _sth_profile
	GROUP BY sth_market
)

SELECT 
	a.lovpid, 
	a.sth_market, 
	c.tickets_sold :: numeric / b.n :: numeric as n_sth_tickets,
	c.gross_amount / b.n :: numeric as apportioned_sth_revenue
INTO TEMPORARY TABLE tmp_sth_profile
FROM _sth_profile as a
LEFT JOIN _sth_cust_n as b
ON a.sth_market = b.sth_market
LEFT JOIN public.segment_venn_season_ticket_revenue as c
ON a.sth_market = c.market
;

-----------------
-- quick checks
SELECT count(*) as n, count(distinct lovpid) as n_id FROM tmp_sth_profile;
SELECT * FROM tmp_sth_profile LIMIT 10;
SELECT sth_market, count(*) as n , sum(apportioned_sth_revenue) as r FROM tmp_sth_profile GROUP BY sth_market;
-----------------

/***********************************************************************************************/
-- Merge all of the tables
DROP TABLE IF EXISTS tmp_customer_profile ;

with _club_insider as (
	SELECT 
		COALESCE(a.lovpid, b.lovpid) as lovpid, 
		COALESCE(a.club_market, b.insider_market) as market, 
		COALESCE(a.is_active_club_member, 0) as is_active_club_member,
		COALESCE(a.is_non_active_club_member, 0) as is_non_active_club_member,
		CASE WHEN b.lovpid is null then 0 else 1 end as is_insider, 
		COALESCE(a.revenue_since_oct, 0) as ltv_club_revenue
	FROM tmp_club_profile as a
	FULL JOIN tmp_insider as b
	ON a.lovpid = b.lovpid
), 

_club_insder_shopify as (
	SELECT
		COALESCE(a.lovpid, b.lovpid) as lovpid, 
		COALESCE(a.market, b.shopify_market) as market, 
		b.merch_category,
		COALESCE(a.is_active_club_member, 0) as is_active_club_member,
		COALESCE(a.is_non_active_club_member, 0) as is_non_active_club_member,
		COALESCE(a.is_insider, 0) as is_insider, 
		CASE WHEN b.lovpid is null then 0 else 1 end as is_merch_purchaser,
		COALESCE(a.ltv_club_revenue, 0) as ltv_club_revenue, 
		COALESCE(b.n_orders, 0) as ltv_merch_orders, 
		COALESCE(b.quantity, 0) as ltv_merch_items, 
		COALESCE(b.revenue, 0) as ltv_merch_revenue
	FROM _club_insider as a
	FULL JOIN tmp_shopify_profile as b
	ON a.lovpid = b.lovpid
), 

_club_insider_shopify_singles as (
	SELECT
		COALESCE(a.lovpid, b.lovpid) as lovpid, 
		COALESCE(a.market, b.single_market) as market, 
		b.single_market as match_market,
		a.merch_category,
		COALESCE(a.is_active_club_member, 0) as is_active_club_member,
		COALESCE(a.is_non_active_club_member, 0) as is_non_active_club_member,
		COALESCE(a.is_insider, 0) as is_insider, 
		COALESCE(a.is_merch_purchaser, 0) as is_merch_purchaser,
		CASE WHEN b.lovpid is null then 0 else 1 end as is_single_match_purchaser,
		COALESCE(a.ltv_club_revenue, 0) as ltv_club_revenue, 
		COALESCE(a.ltv_merch_orders, 0) as ltv_merch_orders, 
		COALESCE(a.ltv_merch_items, 0) as ltv_merch_items, 
		COALESCE(a.ltv_merch_revenue, 0) as ltv_merch_revenue, 
		COALESCE(b.n_matches, 0) as ltv_single_match_events, 
		COALESCE(b.n_single_tickets, 0) as ltv_single_match_tickets, 
		COALESCE(b.apportioned_single_revenue, 0) as ltv_single_match_revenue
	FROM _club_insder_shopify as a
	FULL JOIN tmp_single_match as b
	ON a.lovpid = b.lovpid
),

_final as (
	SELECT
		COALESCE(a.lovpid, b.lovpid) as lovpid, 
		COALESCE(a.market, b.sth_market) as market, 
		COALESCE(b.sth_market, a.match_market) as match_market,
		a.merch_category,
		COALESCE(a.is_active_club_member, 0) as is_active_club_member,
		COALESCE(a.is_non_active_club_member, 0) as is_non_active_club_member,
		COALESCE(a.is_insider, 0) as is_insider, 
		COALESCE(a.is_merch_purchaser, 0) as is_merch_purchaser,
		COALESCE(a.is_single_match_purchaser, 0) as is_single_match_purchaser,
		CASE WHEN b.lovpid is null then 0 else 1 end as is_season_ticket_holder,
		COALESCE(a.ltv_club_revenue, 0) as ltv_club_revenue, 
		COALESCE(a.ltv_merch_orders, 0) as ltv_merch_orders, 
		COALESCE(a.ltv_merch_items, 0) as ltv_merch_items, 
		COALESCE(a.ltv_merch_revenue, 0) as ltv_merch_revenue, 
		COALESCE(a.ltv_single_match_events, 0) as ltv_single_match_events, 
		COALESCE(a.ltv_single_match_tickets, 0) as ltv_single_match_tickets, 
		COALESCE(a.ltv_single_match_revenue, 0) as ltv_single_match_revenue,
		COALESCE(b.n_sth_tickets, 0) as ltv_sth_tickets,
		COALESCE(b.apportioned_sth_revenue, 0) as ltv_sth_revenue
	FROM _club_insider_shopify_singles as a
	FULL JOIN tmp_sth_profile as b
	ON a.lovpid = b.lovpid
)

SELECT 
	*, 
	ltv_club_revenue + ltv_merch_revenue + ltv_single_match_revenue + ltv_sth_revenue as ltv_revenue
INTO TEMPORARY TABLE tmp_customer_profile
FROM _final
;

-----------------
-- quick checks
SELECT count(*) as n, count(distinct lovpid) as n_id FROM tmp_customer_profile;
SELECT * FROM tmp_customer_profile LIMIT 10;
SELECT market, count(*) as n FROM tmp_customer_profile GROUP BY market;
-----------------

SELECT * FROM tmp_customer_profile;

SELECT 
	a.lovpid, 
	b.email, 
	a.match_market,
	a.ltv_single_match_events as number_of_matches_purchased
FROM tmp_customer_profile as a
LEFT JOIN tmp_graph as b
ON a.lovpid = b.lovpid
WHERE a.is_single_match_purchaser = 1;

/***********************************************************************************************
DROP TABLE IF EXISTS tmp_lovb_segment_venn;
WITH club_people as (
	SELECT distinct
		person_id as lovpid,
		email,
		club_id, 
		club_name,
		active_status
	FROM prod_marketing.dim_braze_families as a
	WHERE is_valid 
), 

insiders as (
	SELECT distinct 
		person_id as lovpid, 
		email, 
		home_zip as address_zip,
		country as address_country
	FROM prod_marketing.dim_braze_insiders a 
	WHERE is_valid and not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email)
),

season_ticket as (
	SELECT distinct 
		person_id as lovpid, 
		email,
		pro_market as sth_market, 
	FROM prod_marketing.dim_braze_season_tickets
),

single_match_ticket as (
	SELECT distinct 
		person_id, 
		email 
	FROM prod_marketing.dim_braze_single_ticket_purchase
),

shopify as (
	select distinct
		email, 
		order_year,
		address_state,
		address_country,
		merch_category,
		merch_category_details, 
		count(distinct item_id) as number_of_products,
		count(distinct order_id) as number_of_orders,
		sum(quantity * price) as revenue
	FROM tmp_shopify_orders
	WHERE customer_status = 'known'
	GROUP BY email, order_year, address_state, address_country, merch_category_details, merch_category
), 

-- Step 1: Merge club + insiders
club_and_insiders AS (
	SELECT 
		coalesce(c.person_id, i.person_id) as person_id,	
		COALESCE(c.email, i.email) AS email,
		c.person_id AS club_person_id,
		i.person_id AS insider_person_id,
		c.email as club_email,
		i.email as insider_email,
		c.club_id,
		c.club_name,
		c.active_status
	FROM club_people c
	FULL JOIN insiders i ON c.person_id = i.person_id
),

-- Step 2: Add season tickets
add_season_tickets AS (
	SELECT 
		COALESCE(ci.person_id, s.person_id) AS person_id,
		COALESCE(ci.email, s.email) AS email,
		ci.club_person_id,
		ci.insider_person_id,
		s.person_id AS season_person_id,
		ci.club_email,
		ci.insider_email,
		s.email as season_email,
		ci.club_id,
		ci.club_name,
		ci.active_status
	FROM club_and_insiders ci
	FULL JOIN season_ticket s ON ci.person_id = s.person_id
),

-- Step 3: Add single match tickets
add_single_match AS (
	SELECT 
		COALESCE(st.person_id, sm.person_id) AS person_id,	
		COALESCE(st.email, sm.email) AS email,
		st.club_person_id,
		st.insider_person_id,
		st.season_person_id,
		st.club_email,
		st.insider_email,
		st.season_email,
		sm.person_id AS single_person_id,
		sm.email as single_email,
		st.club_id,
		st.club_name,
		st.active_status
	FROM add_season_tickets st
	FULL JOIN single_match_ticket sm ON st.person_id = sm.person_id
),

final as (
	SELECT distinct
		coalesce(a.person_id, gen_random_uuid()) as lovpid,
		coalesce(a.email, b.email) as email, 
		case when a.club_email is not null then 1 else 0 end as is_club_family,
		case when a.insider_email is not null then 1 else 0 end as is_insider,
		case when a.single_email is not null then 1 else 0 end as is_single_match_ticket_purchaser,
		case when a.season_email is not null then 1 else 0 end as is_season_ticket_holder,
		case when b.email is not null then 1 else 0 end as is_merchandise_purchaser,
		case when a.active_status like 'Active%' then 1 else 0 end as is_active_club_member,
		case when a.active_status not like 'Active%' then 1 else 0 end as is_non_active_club_member
		
	FROM add_single_match as a
	
	FULL JOIN shopify as b
	ON a.email = b.email
	where a.email is not null
)

SELECT * into temporary table tmp_lovb_segment_venn FROM final
;
DROP TABLE IF EXISTS export_lovb_segment_venn;

CREATE TABLE export_lovb_segment_venn AS
SELECT * FROM tmp_lovb_segment_venn;



with main as (
	select 
		lovpid, 
		email,
		is_insider, 
		is_single_match_ticket_purchaser, 
		is_season_ticket_holder, 
		is_merchandise_purchaser, 
		is_active_club_member, 
		is_non_active_club_member
	from export_lovb_segment_venn
),

club_market as (
	SELECT distinct
		person_id,
		home_zip,
		country,
		case 
			when home_zip ~ '^(300|301|302|303|305|306|310|311|312)' and country = 'United States' then 'Atlanta'
			when home_zip ~ '^(787|786|789)' and country = 'United States' then 'Austin'
			when home_zip ~ '^(770|773|774|775|776|777)' and country = 'United States' then 'Houston'
			when home_zip ~ '^(53|61|52|54)' and country = 'United States' then 'Madison'
			when home_zip ~ '^(68|51|54|66)' and country = 'United States' then 'Omaha'
			when home_zip ~ '^(840|841|842|843|844)' and country = 'United States' then 'Salt Lake'
			when country = 'United States' then 'Non-Market US'
			when coalesce(country, '') = '' then 'Unknown'
			else 'International'
		end as club_market
	FROM prod_marketing.dim_braze_families as a
	WHERE is_valid 
), 

insider_market as (
	SELECT 
		person_id, 
		home_zip, 
		country,
		case 
			when home_zip ~ '^(300|301|302|303|305|306|310|311|312)' and country = 'United States' then 'Atlanta'
			when home_zip ~ '^(787|786|789)' and country = 'United States' then 'Austin'
			when home_zip ~ '^(770|773|774|775|776|777)' and country = 'United States' then 'Houston'
			when home_zip ~ '^(53|61|52|54)' and country = 'United States' then 'Madison'
			when home_zip ~ '^(68|51|54|66)' and country = 'United States' then 'Omaha'
			when home_zip ~ '^(840|841|842|843|844)' and country = 'United States' then 'Salt Lake'
			when country = 'United States' then 'Non-Market US'
			WHEN home_zip ~ '^\d{5}$' THEN 'Non-Market US'
			when coalesce(country, '') = '' then 'Unknown'
			else 'International'
		end as insider_market
	FROM prod_marketing.dim_braze_insiders a 
	where is_valid and not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email)
),

single_match as (
	select distinct 
		email, 
		pro_market, 
		case 
			when match_date BETWEEN DATE '2025-01-08' AND DATE '2025-04-13' THEN '2025'
	  		ELSE NULL
		END AS pro_season 
	from prod_intermediate.int_single_ticket_purchase istp
),

season_match_market as (
	SELECT 
		person_id,
		pro_team as season_market
	FROM prod_marketing.dim_braze_season_tickets 
	where pro_team not in ('Employee')
),

merch_purchase as (
	SELECT
		email, 
		order_year,
		address_state,
		address_country,
		merch_category,
		merch_category_details, 
		count(distinct item_id) as number_of_products,
		count(distinct order_id) as number_of_orders,
		sum(quantity * price) as revenue,
		case 
			when address_zip ~ '^(300|301|302|303|305|306|310|311|312)' and address_country = 'United States' then 'Atlanta'
			when address_zip ~ '^(787|786|789)' and address_country = 'United States' then 'Austin'
			when address_zip ~ '^(770|773|774|775|776|777)' and address_country = 'United States' then 'Houston'
			when address_zip ~ '^(53|61|52|54)' and address_country = 'United States' then 'Madison'
			when address_zip ~ '^(68|51|54|66)' and address_country = 'United States' then 'Omaha'
			when address_zip ~ '^(840|841|842|843|844)' and address_country = 'United States' then 'Salt Lake'
			when address_country = 'United States' then 'Non-Market US'
			when coalesce(address_country, '') = '' then 'Unknown'
			else 'International'
		end as merch_market
	FROM export_shopify_orders
	WHERE customer_status = 'known'
	and order_date > '2024-10-01'
	GROUP BY email, order_year, address_state, address_country, address_zip, merch_category_details, merch_category
),

ltv_tickets_purchased as (
	select email, count(*) as tickets_purchased
	from prod_intermediate.int_single_ticket_purchase istp 
	where email is not null
	group by email
),

ltv_tickets_revenue as (
	select 
		a.email,
		SUM(ROUND(b.gross_amount / NULLIF(b.tickets_sold, 0), 2)) as tickets_revenue
    from prod_intermediate.int_single_ticket_purchase a
    join segment_venn_single_ticket_revenue b
    on a.event_code = b.event_code
    where a.email is not null
    group by a.email
),

ltv_season_tickets_purchased as (
	SELECT email, count(*) as tickets_purchased
	FROM prod_marketing.dim_braze_season_tickets 
	group by email
),

ltv_season_tickets_revenue as (
	select
		a.email,
		sum(round(b.gross_amount / nullif(b.tickets_sold, 0), 2)) as tickets_revenue
	from prod_marketing.dim_braze_season_tickets a
	join segment_venn_season_ticket_revenue b
	on a.pro_team = b.market
	group by a.email
),

ltv_merch_purchased as (
	select email, count(distinct item_id) as items_purchased
	from export_shopify_orders
	where email is not null
	and customer_status = 'known'
	and order_date > '2024-10-01'
	group by email
),

ltv_merch_revenue as (
	select email, sum(quantity * price) as revenue
	from export_shopify_orders
	where email is not null
	and customer_status = 'known'
	and order_date > '2024-10-01'
	group by email
),

ltv_club_revenue as (
	select lovpid, sum(amount) as club_revenue
	from prod_id_graph.fct_transactions_lovid ftl
	group by lovpid
),

final as (
	SELECT distinct 
		a.lovpid, 
		coalesce(h.club_market, b.pro_market, j.season_market, c.merch_market, i.insider_market) as pro_market,
		b.pro_season,
		c.merch_category,
		c.merch_category_details,
		a.is_insider, 
		a.is_single_match_ticket_purchaser, 
		a.is_season_ticket_holder, 
		a.is_merchandise_purchaser, 
		a.is_active_club_member, 
		a.is_non_active_club_member,
		case 
			when a.is_single_match_ticket_purchaser = 1 then coalesce(d.tickets_purchased, 0) 
			else 0
		end as life_time_tickets_purchased,
		case 
			when a.is_single_match_ticket_purchaser = 1 then coalesce(k.tickets_revenue, 0) 
			else 0
		end as life_time_tickets_revenue,
		case 
			when a.is_season_ticket_holder = 1 then coalesce(l.tickets_purchased, 0) 
			else 0
		end as life_time_season_tickets_purchased,
		case 
			when a.is_season_ticket_holder = 1 then coalesce(m.tickets_revenue, 0) 
			else 0
		end as life_time_season_tickets_revenue,
		case
			when a.is_merchandise_purchaser = 1 then coalesce(e.items_purchased, 0)
			else 0
		end as life_time_items_purchased,
		case
			when a.is_merchandise_purchaser = 1 then coalesce(f.revenue, 0)
			else 0
		end as life_time_merch_revenue,
		case
			when a.is_active_club_member = 1 then coalesce(g.club_revenue, 0)
			else 0
		end as life_time_club_revenue
		
	FROM main as a
	
	left JOIN single_match as b
	ON a.email = b.email
	
	left JOIN merch_purchase as c 
	ON a.email = c.email 
	
	left JOIN ltv_tickets_purchased as d
	ON a.email = d.email
	
	left JOIN ltv_merch_purchased as e
	ON a.email = e.email
	
	left join ltv_merch_revenue as f
	on a.email = f.email
	
	left join ltv_club_revenue as g
	on a.lovpid = g.lovpid
	
	left join club_market as h
	on a.lovpid = h.person_id
	
	left join insider_market as i
	on a.lovpid = i.person_id
	
	left join season_match_market as j
	on a.lovpid = j.person_id
	
	left join ltv_tickets_revenue as k
	on a.email = k.email

	left join ltv_season_tickets_purchased as l
	on a.email = l.email
	
	left join ltv_season_tickets_revenue as m
	on a.email = m.email
)

SELECT * into temporary table tmp_lovb_final_venn FROM final
;
DROP TABLE IF EXISTS export_lovb_final_venn;

CREATE TABLE export_lovb_final_venn AS
SELECT * FROM tmp_lovb_final_venn;
*/