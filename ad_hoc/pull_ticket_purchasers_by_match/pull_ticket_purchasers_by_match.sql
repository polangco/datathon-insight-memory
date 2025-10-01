-- get the last time data was uploaded into braze
drop table if exists tmp_date;
select max(upload_date) as last_upload
into temporary table tmp_date
from prod_marketing.fct_braze_update_tracking
where table_name = 'dim_braze_single_ticket_purchase';

-- generate the list of new and updated ticket purchasers
-- export to CSV and upload into Braze via the UI
select 
	external_id, 
	email,
	ATL01, ATL01, ATL02, ATL03, ATL04, ATL05, ATL06,
	AUSH01, AUSH02, AUSH03, AUSH04,
	CLASSIC01, CLASSIC02, CLASSIC03, CLASSIC04,
	HOU01, HOU02, HOU03, HOU04, HOU04_HOU05, HOU05, HOU06,
	MADA01, MADA02, MADA02_MADA03, MADA03, MADA04, MADFH01_MADFH02,
	OMAB01, OMAB01_OMAB02, OMAB02,
	SALB01, SALB02, SALB03, SALB03_SALB04, SALB04, SALM01, SALM01_SALM02, SALM02, 
	FINALS01, FINALS02, FINALS03, FINALS04 
from prod_marketing.dim_braze_single_ticket_purchase as a
where last_modified > (select last_upload from tmp_date)
;

-- update track table if records generated returned above
insert into prod_marketing.fct_braze_update_tracking (upload_date, record_number, table_name) 
    select max(last_modified), count(*), 'dim_braze_single_ticket_purchase'
    from prod_marketing.dim_braze_single_ticket_purchase
    where last_modified > (select last_upload from tmp_date)
;


-- matches by week
select 
	event_name,
	team,
	event_date :: date as event_date,
	extract(week from event_date :: date) - 1 as week_num
from public.archtics_event_data
where not (event_name ~* 'test' or event_name ~* '25S')
order by event_date :: date;
