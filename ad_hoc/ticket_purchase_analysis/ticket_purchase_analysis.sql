-- overall ticket sales
drop table tmp_ticket_purchase_analysis;
with ticket_sales as (
	select distinct email, address_state, 'Ticketmaster' as source_platform from prod_raw.stg_ticketmaster_sales
	union
	select distinct email, address_state, 'Paciolian' as source_platform from prod_raw.stg_paciolan_tickets
	union
	select distinct email, null as address_state,  'Season Tickets' as source_platform from prod_raw.stg_season_tickets
),

unique_emails as (
	select 
		email, 
		max(case when source_platform != 'Season Tickets' then 1 else 0 end) as purchased_single_match,
		max(case when source_platform = 'Season Tickets' then 1 else 0 end) as purchased_season_ticket,
		max(address_state) as address_state
	from ticket_sales
	group by email
),

matched_to_club as (
	select distinct
		a.email, 
		coalesce(a.address_state, b.address_state) as address_state,
		case when b.email is not null then 1 else 0 end as is_lovb_family,
		b.lovfid,
		b.lovpid
	from unique_emails as a 
	inner join prod_id_graph.dim_family_all_people_details as b
	on a.email = b.email
), 

matched_to_club_status as (
	select 
		a.email, 
		max(a.address_state) as address_state, 
		max(club_name) as club_name,
		1 as club_family,
		max(case when is_active then 1 else 0 end) as active_club_family,
		max(case when is_rostered_this_season then 1 else 0 end) as rostered_club_family
	from matched_to_club as a 
	left join prod_id_graph.dim_family_status as b 
	on a.lovfid = b.lovfid
	left join prod_marketing.dim_braze_families_season_roster_20241104 as c
	on a.lovfid = c.external_id
	group by a.email

), 

matched_to_insider as (
	select 
		a.email,
		max(case when b.email is not null then 1 else 0 end) as is_insider
	from unique_emails as a
	left join prod_id_graph.grp_insiders as b
	on a.email = b.email
	group by a.email
	
),


final as (
	select
		a.email, 
		COALESCE(a.address_state, b.address_state) as address_state, 
		COALESCE(a.purchased_season_ticket, 0) as purchased_season_ticket,
		COALESCE(a.purchased_single_match, 0) as purchased_single_match,
		
		COALESCE(b.club_family, 0) as club_family,
		COALESCE(b.active_club_family, 0) as active_club_family, 
		COALESCE(b.rostered_club_family, 0) as rostered_club_family,
		
		COALESCE(c.is_insider, 0) as insider
		
	from unique_emails as a
	left join matched_to_club_status as b
	on a.email = b.email
	left join matched_to_insider as c
	on a.email = c.email

),

cleaned as (
	select 
		email, 
		case when address_state ~* 'MICHIGAN' then 'MI' when address_state ~* 'UNKNOWN' then NULL else address_state end as address_state,
		purchased_season_ticket, 
		purchased_single_match, 
		club_family, 
		active_club_family,
		rostered_club_family,
		insider
	from final
)


select *
into temporary table tmp_ticket_purchase_analysis
from cleaned
;

select * from tmp_ticket_purchase_analysis;

select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_analysis;



select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_analysis
where purchased_single_match = 1;


select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_analysis
where purchased_season_ticket = 1;



select * from tmp_ticket_purchase_analysis where purchased_single_match + purchased_season_ticket = 2;


select address_state, count(*), sum(purchased_single_match), sum(purchased_season_ticket) 
from tmp_ticket_purchase_analysis 
group by address_state
order by count(*) desc ;


/*************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************/
-- by pro market

drop table tmp_ticket_purchase_market_analysis;
with ticket_sales as (
	select distinct email, address_state, pro_team, 'Ticketmaster' as source_platform from prod_raw.stg_ticketmaster_market_sales
	union
	select distinct email, address_state, pro_team, 'Paciolian' as source_platform from prod_raw.stg_paciolan_tickets
	union
	select distinct email, null as address_state, pro_team, 'Season Tickets' as source_platform from prod_raw.stg_season_tickets
),

unique_emails as (
	select 
		email, 
		max(case when source_platform != 'Season Tickets' then 1 else 0 end) as purchased_single_match,
		max(case when source_platform = 'Season Tickets' then 1 else 0 end) as purchased_season_ticket,
		max(address_state) as address_state,
		max(case when pro_team ~* 'atlanta' then 1 else 0 end) as atlanta,
		max(case when pro_team ~* 'austin' then 1 else 0 end) as austin,
		max(case when pro_team ~* 'houston' then 1 else 0 end) as houston,
		max(case when pro_team ~* 'madison' then 1 else 0 end) as madison,
		max(case when pro_team ~* 'omaha' then 1 else 0 end) as omaha,
		max(case when pro_team ~* 'salt lake' then 1 else 0 end) as salt_lake
	from ticket_sales
	group by email
),

matched_to_club as (
	select distinct
		a.email, 
		coalesce(a.address_state, b.address_state) as address_state,
		case when b.email is not null then 1 else 0 end as is_lovb_family,
		b.lovfid,
		b.lovpid
	from unique_emails as a 
	inner join prod_id_graph.dim_family_all_people_details as b
	on a.email = b.email
), 

matched_to_club_status as (
	select 
		a.email, 
		max(a.address_state) as address_state, 
		max(club_name) as club_name,
		1 as club_family,
		max(case when is_active then 1 else 0 end) as active_club_family,
		max(case when is_rostered_this_season then 1 else 0 end) as rostered_club_family
	from matched_to_club as a 
	left join prod_id_graph.dim_family_status as b 
	on a.lovfid = b.lovfid
	left join prod_marketing.dim_braze_families_season_roster_20241104 as c
	on a.lovfid = c.external_id
	group by a.email

), 

matched_to_insider as (
	select 
		a.email,
		max(case when b.email is not null then 1 else 0 end) as is_insider
	from unique_emails as a
	left join prod_id_graph.grp_insiders as b
	on a.email = b.email
	group by a.email
	
),


final as (
	select
		a.email, 
		COALESCE(a.address_state, b.address_state) as address_state, 
		COALESCE(a.purchased_season_ticket, 0) as purchased_season_ticket,
		COALESCE(a.purchased_single_match, 0) as purchased_single_match,
		COALESCE(a.atlanta, 0) as purchased_atlanta,
		COALESCE(a.austin, 0) as purchased_austin,
		COALESCE(a.houston, 0) as purchased_houston,
		COALESCE(a.madison, 0) as purchased_madison,
		COALESCE(a.omaha, 0) as purchased_omaha,
		COALESCE(a.salt_lake, 0) as purchased_salt_lake,
		
		COALESCE(b.club_family, 0) as club_family,
		COALESCE(b.active_club_family, 0) as active_club_family, 
		COALESCE(b.rostered_club_family, 0) as rostered_club_family,
		
		COALESCE(c.is_insider, 0) as insider
		
	from unique_emails as a
	left join matched_to_club_status as b
	on a.email = b.email
	left join matched_to_insider as c
	on a.email = c.email

),

cleaned as (
	select 
		email, 
		case when address_state ~* 'MICHIGAN' then 'MI' when address_state ~* 'UNKNOWN' then NULL else address_state end as address_state,
		purchased_season_ticket, 
		purchased_single_match, 
		purchased_atlanta,
		purchased_austin,
		purchased_houston,
		purchased_madison,
		purchased_omaha,
		purchased_salt_lake,
		club_family, 
		active_club_family,
		rostered_club_family,
		insider
	from final
)


select *
into temporary table tmp_ticket_purchase_market_analysis
from cleaned
;

select * from tmp_ticket_purchase_market_analysis;

select * 
from tmp_ticket_purchase_market_analysis 
where purchased_atlanta + purchased_austin + purchased_houston + purchased_madison + purchased_omaha + purchased_salt_lake > 1
order by purchased_atlanta desc, purchased_austin desc, purchased_houston desc, purchased_madison desc, purchased_omaha desc, purchased_salt_lake desc, email;

-- atlanta
select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_market_analysis
where purchased_atlanta = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_single_match = 1 and purchased_atlanta = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_season_ticket = 1 and purchased_atlanta = 1;


-- austin
select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_market_analysis
where purchased_austin = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_single_match = 1 and purchased_austin = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_season_ticket = 1 and purchased_austin = 1;


-- Houston
select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_market_analysis
where purchased_houston = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_single_match = 1 and purchased_houston = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_season_ticket = 1 and purchased_houston = 1;


-- Madison
select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_market_analysis
where purchased_madison = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_single_match = 1 and purchased_madison = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_season_ticket = 1 and purchased_madison = 1;


-- Omaha
select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_market_analysis
where purchased_omaha = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_single_match = 1 and purchased_omaha = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_season_ticket = 1 and purchased_omaha = 1;


-- Salt Lake City
select 
	count(*),
	sum(purchased_single_match) as purchased_single_match, 
	sum(purchased_season_ticket) as purchased_season_ticket,
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
from tmp_ticket_purchase_market_analysis
where purchased_salt_lake = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_single_match = 1 and purchased_salt_lake = 1;

select
	count(*),
	sum(club_family) as club_family,
	sum(active_club_family) as active_club_family, 
	sum(rostered_club_family) as rostered_club_family,
	sum(insider) as insider
	
from tmp_ticket_purchase_market_analysis
where purchased_season_ticket = 1 and purchased_salt_lake = 1;