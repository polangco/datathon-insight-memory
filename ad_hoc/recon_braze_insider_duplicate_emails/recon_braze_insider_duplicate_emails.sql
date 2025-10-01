with ranked as (
	select 
		*,
		row_number() over(
			partition by email 
			order by 
				first_name nulls last, 
				last_name nulls last, 
				phone nulls last, 
				newsletter_role_fan desc nulls last,
				newsletter_role_coach desc nulls last,
				newsletter_role_club desc nulls last,
				newsletter_role_parent desc nulls last,
				newsletter_role_player desc nulls last,
				newsletter_role_other desc nulls last,
				favorite_team_atlanta desc nulls last,
				favorite_team_austin desc nulls last,
				favorite_team_houston desc nulls last,
				favorite_team_madison desc nulls last,
				favorite_team_omaha desc nulls last,
				favorite_team_salt_lake desc nulls last,
				home_city nulls last
		) as row_id
	from prod_marketing.dim_braze_insiders
), 

duplicates as (
	select external_id, person_id from ranked where row_id = 2
) 

update prod_marketing.dim_braze_insiders set
	is_valid = FALSE, 
	last_updated = current_date
where exists (
	select 1
	from duplicates as b
	where 
		b.external_id = prod_marketing.dim_braze_insiders.external_id
		and b.person_id = prod_marketing.dim_braze_insiders.person_id
	
)
;

-- set merged family to is_valid = false
update prod_marketing.dim_braze_insiders
set is_valid = false, last_updated = current_date
where external_id = '08c22c08-6570-4efb-8c18-bddbbfb107a4';

-- remove truly duplicated records
select distinct * 
into temporary table tmp_unique_records
from prod_marketing.dim_braze_insiders;

truncate table prod_marketing.dim_braze_insiders;

insert into prod_marketing.dim_braze_insiders
select * from tmp_unique_records;

drop table tmp_unique_records;