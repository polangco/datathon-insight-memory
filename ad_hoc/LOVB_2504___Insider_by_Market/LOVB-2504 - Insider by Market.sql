
with _add_market as (
	select 
		insider_id, 
		email, 
		address_zip,
		address_country,
		registration_date,
		extract(year from registration_date) as registration_year,
		extract(month from registration_date) as registration_month,
		extract(week from registration_date) as registration_week,
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
			
	from prod_intermediate.int_insider_profile
),

_group as (
	select 
		registration_year, 
		registration_month, 
		registration_week,
		to_date(registration_year::text||registration_week::text, 'IYYYIW') AS week_start_date,
		market, 
		count(distinct email) as new_insiders
	from _add_market
	group by 		
		registration_year, 
		registration_month, 
		registration_week,
		market
)

select * 
from _group 
order by week_start_date, market
;
