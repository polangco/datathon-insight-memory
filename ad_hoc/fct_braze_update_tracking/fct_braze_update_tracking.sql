/*
create table prod_marketing.fct_braze_update_tracking (
    upload_date data not null,
    record_number int not null,
    table_name varchar(100) not null
);
*/


insert into prod_marketing.fct_braze_update_tracking (upload_date, record_number, table_name) values
	(CURRENT_DATE, 251, 'dim_braze_insiders'),
	(CURRENT_DATE, 12606, 'dim_braze_families'),
	(CURRENT_DATE, 45, 'dim_braze_lovb_notes')
;
