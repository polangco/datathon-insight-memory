-- weekly registrations
select 
extract(year from date_trunc('week', registration_date)::date ) as yr,
extract(week from date_trunc('week', registration_date)::date ) as wk,
date_trunc('week', registration_date)::date as week_start_date,
count(distinct email) as count_insiders
from prod_raw.stg_insider_demographics as a
where not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email)
group by 
	date_trunc('week', registration_date)
;

-- profile completion by 
select 
	date_trunc('month', registration_date) :: date || ' - ' || (date_trunc('month', registration_date) + interval '1 month') :: date as registration_period,
	count(*) as num_insiders,
	sum(case when phone_number is not null and first_name is not null and last_name is not null and birth_date is not null and COALESCE(address_zip, address_country, '') != '' then 1 else 0 end) as num_complete,
	sum(case when phone_number is not null and first_name is not null and last_name is not null and birth_date is not null and COALESCE(address_zip, address_country, '') != '' then 1 else 0 end) :: numeric / count(*) as pct_complete,
	sum(case when phone_number is null then 1 else 0 end) as num_phone_null,
	sum(case when first_name is null then 1 else 0 end) as num_first_name_null,
	sum(case when last_name is null then 1 else 0 end) as num_last_name_null,
	sum(case when birth_date is null then 1 else 0 end) as num_birthdate_null,
	sum(case when address_zip is null then 1 else 0 end) as num_zip_null,
	sum(case when address_country is null then 1 else 0 end) as num_country_null
from prod_raw.stg_insider_demographics as a
where not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email)
GROUP BY ROLLUP (date_trunc('month', registration_date))
ORDER BY date_trunc('month', registration_date) nulls last;


--- Market
with _assign_market as (
	SELECT 
		registration_date,
		insider_id,
		email, 
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
		end as market
	FROM prod_raw.stg_insider_demographics
)

SELECT 
	date_trunc('month', registration_date) :: date || ' - ' || (date_trunc('month', registration_date) + interval '1 month') :: date as registration_period_month,
	date_trunc('week', registration_date) :: date || ' - ' || (date_trunc('week', registration_date) + interval '1 week') :: date as registration_period_week,
	market,
	count(distinct insider_id) as num_insiders
FROM _assign_market as a 
where not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email)
GROUP BY date_trunc('month', registration_date), date_trunc('week', registration_date), market
;


---- 
select * from prod_raw.stg_insider_demographics as a where not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email);


select distinct utm_source, utm_campaign from public.platform_user_utm_parameters;


select count(*), count(distinct person_id)
from prod_marketing.dim_braze_insiders as a 
where is_valid
	and not exists (select * from prod_raw.stg_braze_unsub as b where a.email = b.email);