-- Check for new clubs to be added to mapping
select distinct club_name
from public.sprocket_registration_details as a
where not exists (
	select 1
	from prod_raw.club_mapping as b
	where b.source_system ~* 'sprocket' and a.club_name = b.source_name
);

select distinct club_name
from public.playmetrics_subscriptions_latest as a
where not exists (
	select 1
	from prod_raw.club_mapping as b
	where b.source_system ~* 'playmetrics' and a.club_name = b.source_name
);

select distinct club_name
from public.leagueapps_registrations_latest as a
where not exists (
	select 1
	from prod_raw.club_mapping as b
	where b.source_system ~* 'leagueapps' and a.club_name = b.source_name
);


-- pull new or changed insiders
select 
	external_id, 
	person_id,
	first_name, 
	last_name,
	email, 
	phone, 
	is_insider, 
	home_zip, 
	country,
	newsletter_role_club,
	newsletter_role_coach,
	newsletter_role_fan,
	newsletter_role_parent, 
	newsletter_role_player,
	newsletter_role_other, 
	favorite_team_atlanta,
	favorite_team_austin, 
	favorite_team_houston,
	favorite_team_madison,
	favorite_team_omaha,
	favorite_team_salt_lake,
	last_updated
from prod_marketing.dim_braze_insiders
where 
	is_valid 
	and email_subscribe
	and last_updated > (select max(upload_date) from prod_marketing.fct_braze_update_tracking where table_name = 'dim_braze_insiders');


-- pull new or changed club families
select
	external_id,
	person_id, 
	first_name,
	last_name,
	is_club_member,
	home_city,
	home_zip,
	home_state,
	country, 
	dob,
	email, 
	phone_number as phone, 
	person_type, 
	club_id, 
	club_name, 
	active_status,
	family_size,
	people_details
from prod_marketing.dim_braze_families
where is_valid and last_updated > (select max(upload_date) from prod_marketing.fct_braze_update_tracking where table_name = 'dim_braze_families');


-- lovb notes 
select 
	lovpid as external_id,
	first_name,
	last_name, 
	email,
	phone_number as phone,
	libero_ds, middle_blocker, opposite_right_side, outside_hitter, setter, utility_player

from prod_marketing.dim_braze_lovb_notes
where created_at > (select max(upload_date) from prod_marketing.fct_braze_update_tracking where table_name = 'dim_braze_lovb_notes');


-- season ticket holders
select
	external_id, email, pro_team, is_season_ticket_holder
from prod_marketing.dim_braze_season_tickets;



-- single match tickets purchasers
select 
	external_id, 
	email, 
 	purchased_single_match_atlanta,
 	purchased_single_match_austin,
 	purchased_single_match_houston,
 	purchased_single_match_madison,
 	purchased_single_match_omaha,
	purchased_single_match_salt_lake

from prod_marketing.dim_braze_single_match_tickets;


-- first serve
select external_id, email, phone_number, match_date

from prod_marketing.dim_braze_first_serve;


-- if doing deduplication
select * 
from prod_marketing.fct_braze_duplicates 
where merge_date = (select max(merge_date) from prod_marketing.fct_braze_duplicates) and id_type = 'external_id';
