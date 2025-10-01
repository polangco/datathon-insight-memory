with _voters as (
	select distinct 
		voter_email as email, 
		insider_id
	from public.platform_user_insider_icon_voting
),

_join_voters as (
	select 
		a.insider_id,
		(a.registration_date at time zone 'US/Central') :: date as registration_date,
		case when b.insider_id is null then FALSE else TRUE end as voted
	from prod_intermediate.int_insider_profile as a
	left join _voters as b
	on a.insider_id = b.insider_id
)

select 
	*,
	case
		when registration_date < to_date('20250106', 'YYYYMMDD') then '0. pre season' 
		when registration_date between to_date('20250106', 'YYYYMMDD') and to_date('20250202', 'YYYYMMDD') then '1. first 4 weeks of season' 
		when registration_date between to_date('20250203', 'YYYYMMDD') and to_date('20250302', 'YYYYMMDD') then '2. 1 month to prior icon' 
		when registration_date between to_date('20250303', 'YYYYMMDD') and to_date('20250401', 'YYYYMMDD') then '3. icon voting period' 
		when registration_date between to_date('20250402', 'YYYYMMDD') and to_date('20250416', 'YYYYMMDD') then '4. last 2 weeks of season'
	end as period 
from _join_voters
;