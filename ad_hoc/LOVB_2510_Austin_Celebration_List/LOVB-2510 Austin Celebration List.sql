WITH _season_ticks AS (
  SELECT
    "First Name" AS first_name, 
    "Last Name" AS last_name,
    lower("Email") AS email,
    CASE 
      WHEN length(cleaned) = 10 THEN '+1' || cleaned
      WHEN length(cleaned) = 11 AND left(cleaned, 1) = '1' THEN '+' || cleaned
      WHEN length(cleaned) > 11 AND left(cleaned, 1) = '1' THEN '+' || left(cleaned, 11)
      ELSE NULL
    END AS phone_number,
    CASE
      WHEN "I agree to receive marketing and promotional materials from LOV" = 'Yes' THEN TRUE
      WHEN "I agree to receive marketing and promotional materials from LOV" = 'No' THEN NULL
    END AS marketing_promotion_consent,
    'Austin' AS pro_team,
    'rsvp' AS source
  FROM (
    SELECT *, regexp_replace("Phone Number", '[^0-9]', '', 'g') AS cleaned
    FROM public.lovb_austin_championship_celebration_rsvp
  ) AS sub_rsvp

  UNION ALL

  SELECT
    "First Name" AS first_name, 
    "Last Name" AS last_name,
    lower("Email") AS email,
    CASE 
      WHEN length(cleaned) = 10 THEN '+1' || cleaned
      WHEN length(cleaned) = 11 AND left(cleaned, 1) = '1' THEN '+' || cleaned
      WHEN length(cleaned) > 11 AND left(cleaned, 1) = '1' THEN '+' || left(cleaned, 11)
      ELSE NULL
    END AS phone_number,
    CASE
      WHEN "I agree to receive marketing and promotional materials from LOV" = 'Yes' THEN TRUE
      WHEN "I agree to receive marketing and promotional materials from LOV" = 'No' THEN NULL
    END AS marketing_promotion_consent,
    'Austin' AS pro_team,
    'season_ticket_holder' AS source
  FROM (
    SELECT *, regexp_replace("Phone Number", '[^0-9]', '', 'g') AS cleaned
    FROM public.lovb_austin_celebration_season_ticket_holder
  ) AS sub_season
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
),

_external_id as (
	SELECT 
		coalesce(b.external_id, gen_random_uuid()) as external_id,
		a.first_name, 
		a.last_name, 
		a.email,
	    a.phone_number,
	    a.marketing_promotion_consent,
		a.pro_team,
	    a.source
	FROM _season_ticks as a
	LEFT JOIN _select as b
	ON a.email = b.email
),

_final as (
	SELECT 
		external_id, 
		email, 
		max(phone_number) as phone, 
		max(marketing_promotion_consent::INT)::BOOLEAN as marketing_promotion_consent
	FROM _external_id
	GROUP BY external_id, email
)

SELECT * FROM _final
;
