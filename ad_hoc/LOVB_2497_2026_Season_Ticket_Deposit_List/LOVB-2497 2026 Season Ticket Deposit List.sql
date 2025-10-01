WITH _season_ticks as (
	SELECT
		acct_id as archtics_accounts_id,
		split_part(owner_name, ', ', 2) as first_name, 
		split_part(owner_name, ', ', 1) as last_name,
		lower(email_addr) as email,
		CASE 
			WHEN acct_type_desc || group_codes ~* 'salt' then 'Salt Lake City'
			WHEN acct_type_desc || group_codes ~* 'omaha' then 'Omaha'
			WHEN acct_type_desc || group_codes ~* 'madison' then 'Madison'
			WHEN acct_type_desc || group_codes ~* 'houston' then 'Houston'
			WHEN acct_type_desc || group_codes ~* 'austin' then 'Austin'
			WHEN acct_type_desc || group_codes ~* 'atlanta' then 'Atlanta'
			ELSE 'UNKNOWN'
		END as pro_team
	FROM public.archtics_2026_season_ticket_deposit
),

_id as (

	SELECT external_id, email, max(last_updated) as last_updated FROM prod_marketing.dim_braze_families WHERE is_valid GROUP BY external_id, email
	UNION
	SELECT external_id, email, max(last_updated) as last_updated FROM prod_marketing.dim_braze_insiders WHERE is_valid GROUP BY external_id, email
	UNION
	SELECT external_id, email, CURRENT_DATE as last_updated FROM prod_marketing.dim_braze_season_tickets
	UNION
	SELECT external_id, email, CURRENT_DATE as last_updated FROM prod_marketing.dim_braze_single_match_tickets
	UNION
	SELECT external_id, email, CURRENT_DATE as last_updated FROM prod_marketing.dim_braze_coaches_20250505
),

_rank as (
	SELECT
		external_id,
		email,
		row_number() OVER(PARTITION BY email ORDER BY last_updated desc) as row_id
	FROM _id
),

_select as (
	SELECT external_id, email FROM _rank where row_id = 1
)

SELECT 
	coalesce(b.external_id, gen_random_uuid()) as external_id,
	a.first_name, 
	a.last_name, 
	a.email,
	a.pro_team,
	TRUE as deposit_2026
FROM _season_ticks as a
LEFT JOIN _select as b
ON a.email = b.email
;

