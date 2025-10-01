with _combined as (
	select *, '2025-06-01' :: date as collected_date 
	from public.sprocket_pro_marketing_opt_in_june
	union
	select * , '2025-07-01' :: date as collected_date
	from public.sprocket_pro_marketing_opt_in_july
),

_distinct as (
	select distinct 
		"Email" as email,  
		"Player Summary Info Acknowledged" as marketing_opt_in
	from _combined
)

select count(*), count(distinct email) from _distinct 
;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
with _combined as (
	select *, '2025-06-01' :: date as collected_date 
	from public.sprocket_pro_marketing_opt_in_june
	union
	select * , '2025-07-01' :: date as collected_date
	from public.sprocket_pro_marketing_opt_in_july
),

_distinct as (
	select distinct
		"Email" as email,  
		"Player Summary Info Acknowledged" as marketing_opt_in,
		collected_date
	from _combined
)

SELECT email, collected_date, count(*) as n
FROM _distinct
GROUP BY email, collected_date
HAVING count(*) > 1
;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT "Club", "Registration", "User Name", "Email", "Player Summary Info Acknowledged"  
FROM public.sprocket_pro_marketing_opt_in_july 
WHERE "Email" = 'a.rodriguez79@hotmail.com'
;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
with _combined as (
	select *, '2025-06-01' :: date as collected_date 
	from public.sprocket_pro_marketing_opt_in_june
	union
	select * , '2025-07-01' :: date as collected_date
	from public.sprocket_pro_marketing_opt_in_july
),

_distinct as (
	select distinct 
		"Email" as email,  
		"Player Summary Info Acknowledged" as marketing_opt_in,
		collected_date
	from _combined
),

_rank_recent as (
	select *, row_number() over(partition by email order by collected_date desc, marketing_opt_in asc) as rn
	from _distinct
),

_select_consent as (
	select 
		email,
		collected_date, 
		marketing_opt_in
	from _rank_recent
	where rn = 1
),

_sprocket_emails as (
	select email, 'player' as person_type from public.sprocket_player_contacts where email is not null
	union
	select parent_1_email as email, 'parent 1' as person_type from public.sprocket_player_contacts where parent_1_email is not null
	union
	select parent_2_email as email, 'parent 2' as person_type from public.sprocket_player_contacts where parent_2_email is not null
	union
	select parent_3_email as email, 'parent 3' as person_type from public.sprocket_player_contacts where parent_3_email is not null
	union 
	select "parent/guardian_email" as email, 'guardian' as person_type from public.sprocket_parents where "parent/guardian_email" is not null
),

_rank as (
	select *, row_number() over(partition by email order by person_type) as rn
	from _sprocket_emails
),

_select as (
	select email, person_type
	from _rank
	where rn = 1
),

_merge as (
	select 
		COALESCE(a.email, b.email) as email, 
		a.person_type,
		b.marketing_opt_in,
		case 
			when a.email is null then 'in consent, not in player or parent data'
			when b.email is null then 'not in consent, in player or parent data'
			else 'in consent, in player or parent data'
		end as overlap
	from _select as a
	full join _select_consent as b
	on a.email = b.email
)

select marketing_opt_in, overlap, count(*) 
from _merge
group by rollup(overlap, marketing_opt_in)
order by overlap, marketing_opt_in


;

with _sprocket_emails as (
	select email, 'player' as person_type from public.sprocket_player_contacts where email is not null
	union
	select parent_1_email as email, 'parent 1' as person_type from public.sprocket_player_contacts where parent_1_email is not null
	union
	select parent_2_email as email, 'parent 2' as person_type from public.sprocket_player_contacts where parent_2_email is not null
	union
	select parent_3_email as email, 'parent 3' as person_type from public.sprocket_player_contacts where parent_3_email is not null
),

_rank as (
	select *, row_number() over(partition by email order by person_type) as rn
	from _sprocket_emails
),

_select as (
	select email, person_type
	from _rank
	where rn = 1
)

select * from _select
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
with _combined as (
	select *, '2025-06-01' :: date as collected_date 
	from public.sprocket_pro_marketing_opt_in_june
	union
	select * , '2025-07-01' :: date as collected_date
	from public.sprocket_pro_marketing_opt_in_july
),

_distinct as (
	select distinct 
		"Email" as email,  
		"Player Summary Info Acknowledged" as marketing_opt_in,
		collected_date
	from _combined
),

_rank_recent as (
	select *, row_number() over(partition by email order by collected_date desc, marketing_opt_in asc) as rn
	from _distinct
),

_select_consent as (
	select 
		email,
		collected_date, 
		marketing_opt_in
	from _rank_recent
	where rn = 1
)

select 
	marketing_opt_in, 
	count(*) as n,
	100*round(count(*)::numeric / (select count(*) from _select_consent)::numeric, 4) as pct
from _select_consent
group by marketing_opt_in
;
