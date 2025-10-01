select max(created_at) from shopify_prod.orders;

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

select * from tmp_shopify_orders;

select min(order_date), max(order_date) from tmp_shopify_orders;

-- total
SELECT 
	customer_status,
	case when customer_status = 'unknown' then NULL else count(distinct customer_id) end as number_of_customers,
	sum(quantity) as number_of_items, 
	round(sum(quantity * price), 2) as revenue,
	round(sum(quantity * price) / sum(quantity), 2) as avg_price_per_item,
	case when customer_status = 'unknown' then NULL else round(sum(quantity * price) / count(distinct customer_id), 2) end as avg_rev_per_cust
FROM tmp_shopify_orders 
group by customer_status;


-- year over year
SELECT 
	order_year,
	customer_status,
	case when customer_status = 'unknown' then NULL else count(distinct customer_id) end as number_of_customers,
	sum(quantity) as number_of_items, 
	round(sum(quantity * price), 2) as revenue,
	round(sum(quantity * price) / sum(quantity), 2) as avg_price_per_item,
	case when customer_status = 'unknown' then NULL else round(sum(quantity * price) / count(distinct customer_id), 2) end as avg_rev_per_cust
FROM tmp_shopify_orders 
GROUP BY
ROLLUP(order_year, customer_status);

-- year over year
SELECT 
	order_year,
	customer_status,
	case when customer_status = 'unknown' then NULL else count(distinct customer_id) end as number_of_customers,
	sum(quantity) as number_of_items, 
	round(sum(quantity * price), 2) as revenue,
	round(sum(quantity * price) / sum(quantity), 2) as avg_price_per_item,
	case when customer_status = 'unknown' then NULL else round(sum(quantity * price) / count(distinct customer_id), 2) end as avg_rev_per_cust
FROM tmp_shopify_orders 
GROUP BY
ROLLUP(order_year, customer_status);

-- year over year by merc category
SELECT 
	case 
		when order_date < to_date('20250108', 'YYYYMMDD') then 'Prior to 2025 Season' 
		when order_date between to_date('20250214', 'YYYYMMDD') and to_date('20250216', 'YYYYMMDD') then 'During LOVB Classic'
		else 'During 2025 season'
	end as time_period,
	customer_status,
	merch_category,
	case when customer_status = 'unknown' then NULL else count(distinct customer_id) end as number_of_customers,
	sum(quantity) as number_of_items, 
	round(sum(quantity * price), 2) as revenue,
	round(sum(quantity * price) / sum(quantity), 2) as avg_price_per_item,
	case when customer_status = 'unknown' then NULL else round(sum(quantity * price) / count(distinct customer_id), 2) end as avg_rev_per_cust
FROM tmp_shopify_orders 
GROUP BY
ROLLUP (
	case 
		when order_date < to_date('20250108', 'YYYYMMDD') then 'Prior to 2025 Season' 
		when order_date between to_date('20250214', 'YYYYMMDD') and to_date('20250216', 'YYYYMMDD') then 'During LOVB Classic'
		else 'During 2025 season'
	end, 
	customer_status, 
	merch_category
);



-- join with club, insider, ticket purchaser
WITH _club_people as (
	SELECT distinct
		email,
		club_id, 
		club_name,
		active_status
	FROM prod_marketing.dim_braze_families as a
	WHERE is_valid
), 

_insiders as (
	SELECT distinct email FROM prod_marketing.dim_braze_insiders where is_valid
),

_season_ticket as (
	SELECT distinct email FROM prod_marketing.dim_braze_season_tickets
),

_single_match_ticket as (
	SELECT distinct email FROM prod_marketing.dim_braze_single_ticket_purchase
),

_coaches as (
	SELECT email, club_id, club_name, is_club_coach, is_club_director 
	FROM prod_marketing.dim_braze_coaches_20250331
	WHERE email is not null
),

_shopify as (
	SELECT
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

_final as (
	SELECT 
		a.email, 
		a.order_year, 
		a.address_state, 
		a.address_country,
		a.merch_category,
		a.merch_category_details, 
		a.number_of_products, 
		a.number_of_orders, 
		a.revenue,
		
		case when b.email is not null then 1 else 0 end as is_club_family,
		case when c.email is not null then 1 else 0 end as is_insider,
		case when d.email is not null then 1 else 0 end as is_season_ticket_holder,
		case when e.email is not null then 1 else 0 end as is_single_match_ticket,
		case when f.is_club_coach then 1 else 0 end as is_club_coach,
		case when f.is_club_director then 1 else 0 end as is_club_director,
		
		coalesce(b.club_id, f.club_id, -1) as club_id,
		coalesce(b.club_name, f.club_name, 'None') as club_name,
		coalesce(b.active_status, 'None') as club_familya_active_status
		
	FROM _shopify as a
	
	LEFT JOIN _club_people as b
	ON a.email = b.email
	
	LEFT JOIN _insiders as c 
	ON a.email = c.email 
	
	LEFT JOIN _season_ticket as d
	ON a.email = d.email
	
	LEFT JOIN _single_match_ticket as e
	ON a.email = e.email
	
	LEFT JOIN _coaches as f
	ON a.email = f.email

)

SELECT * FROM _final order by email, order_year, merch_category, merch_category_details
;


SELECT distinct email FROM prod_marketing.dim_braze_single_ticket_purchase;

SELECT email, club_id, club_name, is_club_coach, is_club_director 
	FROM prod_marketing.dim_braze_coaches_20250331
	WHERE email is not null;
