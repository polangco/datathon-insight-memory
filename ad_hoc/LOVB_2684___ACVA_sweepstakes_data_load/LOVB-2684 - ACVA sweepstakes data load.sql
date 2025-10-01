DROP TABLE IF EXISTS public.avca_sweeps_submissions;
CREATE TABLE public.avca_sweeps_submissions (
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    phone TEXT,
    zip TEXT,
    marketing_opt_in_email BOOLEAN,
    marketing_opt_in_phone BOOLEAN
);

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- counts
WITH _distinct as (
	SELECT distinct * FROM public.avca_sweeps_submissions
)

SELECT 
	count(*) as n, 
	count(distinct email) as unique_emails, 
	count(distinct phone) as unique_phone, 
	count(distinct first_name || last_name || zip) as unique_name
FROM _distinct;

/*
| n    | unique_emails | unique_phone | unique_name |
|------|---------------|--------------|-------------|
| 3601 |          3413 |         3381 |        3451 |
*/

WITH _distinct as (
	SELECT distinct * FROM public.avca_sweeps_submissions
), 

_dup_phone as (
	SELECT phone
	FROM _distinct
	GROUP BY phone
	HAVING count(*) > 1
)

SELECT *
FROM _distinct as a
WHERE exists (SELECT 1 FROM _dup_phone as b WHERE a.phone = b.phone)
ORDER BY phone;

/*
| email                   | first_name | last_name     | phone        | zip   | marketing_opt_in_email | marketing_opt_in_phone |
|-------------------------|------------|---------------|--------------|-------|------------------------|------------------------|
| jayrdub1979@hotmail.com | Jamie      | Michaud       | +12083712010 | 68123 | t                      | f                      |
| jayrdub1979@hotmail.com | Jamie      | Michaud       | +12083712010 | 68123 | t                      | t                      |

| aerojosh02@gmail.com    | Joshua     | Ballard       | +12148029668 | 75087 | t                      | t                      |
| aerojosh02@gmail.com    | Joshua     | Ballard       | +12148029668 | 75087 | f                      | f                      |

| ishuler39@gmail.com     | Iris       | Shuler-Holmes | +12819145389 | 77083 | t                      | f                      |
| ishuler39@gmail.com     | Iris       | Shuler-Holmes | +12819145389 | 77083 | t                      | t                      |

| juliekutzer@gmail.com   | Julie      | Hostetter     | +13073153211 | 82240 | f                      | f                      |
| juliekutzer@gmail.com   | Julie      | Hostetter     | +13073153211 | 82240 | t                      | t                      |

| katierieken@yahoo.com   | Katie      | Rieken        | +13082491027 | 69125 | f                      | f                      |
| katierieken@gmail.com   | Katie      | Rieken        | +13082491027 | 69125 | f                      | f                      |
*/

-- match to insider ---> matches with 1,454 existing Insiders
SELECT count(distinct insider_id)
FROM prod_raw.stg_insider_demographics as a
WHERE exists (
	SELECT 1 
	FROM public.avca_sweeps_submissions as b
	WHERE 
		trim(lower(a.email)) = trim(lower(b.email))
		or trim(lower(a.first_name || a.last_name)) = trim(lower(b.first_name || b.last_name))
		or '+' || a.phone_number = b.phone
);

-- match to graph
with _matched as (
	SELECT source_dataset, profile_id
	FROM public.id_graph_inheritence as a
	WHERE exists (
		SELECT 1 
		FROM public.avca_sweeps_submissions as b
		WHERE 
			a.email = lower(b.email)
	-- 		or a.first_name || a.last_name = trim(lower(b.first_name || b.last_name))
	-- 		a.phone = b.phone
	)
	UNION 
	SELECT source_dataset, profile_id
	FROM public.id_graph_inheritence as a
	WHERE exists (
		SELECT 1 
		FROM public.avca_sweeps_submissions as b
		WHERE 
	-- 		a.email = lower(b.email)
			a.first_name || a.last_name = trim(lower(b.first_name || b.last_name))
	-- 		a.phone = b.phone
	)
	UNION 
	SELECT source_dataset, profile_id
	FROM public.id_graph_inheritence as a
	WHERE exists (
		SELECT 1 
		FROM public.avca_sweeps_submissions as b
		WHERE 
	-- 		a.email = lower(b.email)
	-- 		a.first_name || a.last_name = trim(lower(b.first_name || b.last_name))
			a.phone = b.phone
	)
)

SELECT count(distinct profile_id) FROM _matched;

SELECT source_dataset, count(distinct profile_id)
FROM _matched
GROUP BY source_dataset
;



with _matched as (
	SELECT a.email, a.phone
	FROM public.avca_sweeps_submissions as a
	WHERE exists (
		SELECT 1 
		FROM public.id_graph_inheritence as b
		WHERE 
			lower(a.email) = lower(b.email)
	-- 		or a.first_name || a.last_name = trim(lower(b.first_name || b.last_name))
	-- 		a.phone = b.phone
	)
	UNION 
	SELECT a.email, a.phone
	FROM public.avca_sweeps_submissions as a
	WHERE exists (
		SELECT 1 
		FROM public.id_graph_inheritence as b
		WHERE 
	-- 		a.email = lower(b.email)
			trim(lower(a.first_name || a.last_name)) = trim(lower(b.first_name || b.last_name))
	-- 		a.phone = b.phone
	)
	UNION 
	SELECT a.email, a.phone
	FROM public.avca_sweeps_submissions as a
	WHERE exists (
		SELECT 1 
		FROM public.id_graph_inheritence as b
		WHERE 
	-- 		a.email = lower(b.email)
	-- 		a.first_name || a.last_name = trim(lower(b.first_name || b.last_name))
			a.phone = b.phone
	)
)

SELECT count(distinct email || phone) FROM _matched;


--- by market

WITH _distinct as (
	SELECT distinct * FROM public.avca_sweeps_submissions
), 

_assign_market as (
	SELECT 
		*,
		case 
			when zip ~ '^(300|301|302|303|305|306|310|311|312)' then 'Atlanta'
			when zip ~ '^(787|786|789)' then 'Austin'
			when zip ~ '^(770|773|774|775|776|777)' then 'Houston'
			when zip ~ '^(53|61|52|54)' then 'Madison'
			when zip ~ '^(68|51|54|66)' then 'Omaha'
			when zip ~ '^(840|841|842|843|844)' then 'Salt Lake'
			when COALESCE(zip, '') = '' then 'Unknown'
			else 'Non-Market USA'
		end as pro_market
	FROM _distinct
) 

SELECT 
	pro_market, 
	count(*) as n, 
	count(distinct email) as unique_emails, 
	count(distinct phone) as unique_phone, 
	count(distinct first_name || last_name || zip) as unique_name
FROM _assign_market
GROUP BY pro_market
ORDER BY pro_market;



----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS public.avca_sweeps_submissions;
CREATE TABLE public.avca_sweeps_submissions (
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    phone TEXT,
    zip TEXT,
    marketing_opt_in_email BOOLEAN,
    marketing_opt_in_phone BOOLEAN
);

WITH _distinct as (
	SELECT 
		email,
		max(first_name) as first_name,
		max(last_name) as last_name,
		max(phone) as phone, 
		max(zip) as zip,
		max(marketing_opt_in_email :: INT) :: BOOLEAN as marketing_opt_in_email,
    	max(marketing_opt_in_phone :: INT) :: BOOLEAN  as marketing_opt_in_phone
	FROM public.avca_sweeps_submissions
	GROUP BY email
), 

_assign_market as (
	SELECT 
		*, 
		case 
			when zip ~ '^(300|301|302|303|305|306|310|311|312)' then 'Atlanta'
			when zip ~ '^(787|786|789)' then 'Austin'
			when zip ~ '^(770|773|774|775|776|777)' then 'Houston'
			when zip ~ '^(53|61|52|54)' then 'Madison'
			when zip ~ '^(68|51|54|66)' then 'Omaha'
			when zip ~ '^(840|841|842|843|844)' then 'Salt Lake'
			when COALESCE(zip, '') = '' then 'Unknown'
			else 'Non-Market USA'
		end as pro_market
	FROM _distinct
), 

match_email_id as (
    select email, external_id, person_id
    from prod_marketing.dim_braze_families
    where is_valid
    
    union

    select email, external_id, person_id
    from prod_marketing.dim_braze_insiders
    where is_valid

    union

    select email, external_id, person_id
    from prod_marketing.dim_braze_season_tickets
),

rank_email as (
    select 
        *,
        row_number() over (partition by email order by external_id) as row_id
    from match_email_id
), 

unique_email as (
    select * from rank_email
    where row_id = 1
),

_final as (
	SELECT
	    case when b.external_id is null then gen_random_uuid() else b.external_id end as external_id,
        case when b.person_id is null then gen_random_uuid() else b.person_id end as person_id,
		a.*
	FROM _assign_market as a
	LEFT JOIN unique_email as b
	ON a.email = b.email
)

SELECT * FROM _final
;

