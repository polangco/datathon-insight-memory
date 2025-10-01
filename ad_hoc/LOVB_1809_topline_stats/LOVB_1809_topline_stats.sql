
select count(*), count(distinct email) from prod_marketing.dim_braze_families where is_valid;

select active_status, count(*), count(distinct email) from prod_marketing.dim_braze_families where is_valid group by active_status;

select is_rostered_this_season, count(distinct external_id) from prod_marketing.dim_braze_families_season_roster_20241118 group by is_rostered_this_season;


select count(distinct lovpid), count(distinct email)
from prod_id_graph.dim_family_all_people_details as a  
where 
	a.email is not null 
	and a.lovfid in (select distinct(external_id) from prod_marketing.dim_braze_families_season_roster_20241118 where is_rostered_this_season);


select person_type, count(distinct lovpid), count(distinct email)
from prod_id_graph.dim_family_all_people_details as a  
where 
	a.email is not null 
	and a.lovfid in (select distinct(external_id) from prod_marketing.dim_braze_families_season_roster_20241118 where is_rostered_this_season)
group by person_type;


select count(*), count(distinct email) from prod_marketing.dim_braze_insiders where is_valid;


select count(*), count(distinct email) 
from prod_marketing.dim_braze_insiders 
where 
	is_valid
	and email in (select distinct email from prod_id_graph.dim_family_all_people_details);


select 
	sum(case when favorite_team_atlanta then 1 else 0 end) as atlanta,
	sum(case when favorite_team_austin then 1 else 0 end) as austin,
	sum(case when favorite_team_houston then 1 else 0 end) as houston,
	sum(case when favorite_team_madison then 1 else 0 end) as madison,
	sum(case when favorite_team_omaha then 1 else 0 end) as omaha,
	sum(case when favorite_team_salt_lake then 1 else 0 end) as salt_lake
	
from prod_marketing.dim_braze_insiders
where is_valid;

