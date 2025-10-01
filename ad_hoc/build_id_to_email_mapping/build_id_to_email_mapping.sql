if exists drop table tmp_id_email_unique;

with id_email as (
	select 
		coalesce(a.lovfid, b.external_id, c.external_id) as lovfid, 
		coalesce(a.lovpid, b.person_id, c.person_id) as lovpid, 
		coalesce(a.email, b.email, c.email) as email ,
		coalesce(a.people_rank, 1) as people_rank
	from prod_id_graph.dim_family_all_people_details as a
	full join (
		select external_id, person_id, email 
		from prod_marketing.dim_braze_insiders
		where is_valid
	) as b
	on a.lovfid = b.external_id and a.lovpid = b.person_id and coalesce(a.email, '') = coalesce(b.email, '')
	full join (
		select * 
		from prod_marketing.dim_braze_families 
		where is_valid
	) as c 
	on a.lovfid = c.external_id and a.lovpid = b.person_id and coalesce(a.email, '') = coalesce(c.email, '')
	where coalesce(a.email, b.email, c.email) is not null
),

rank_email as (
	select 
		*,
		row_number() over(partition by email order by people_rank, lovpid, lovfid) as row_id
	from id_email
)

select lovfid, lovpid, email
into temporary table tmp_id_email_unique 
from rank_email where row_id = 1
;


select count(*), count(distinct lovfid), count(distinct lovpid), count(distinct email) from tmp_id_email_unique;


with not_unique as (
	select lovpid
	from tmp_id_email_unique 
	group by lovpid
	having count(*) > 1
)

select * from tmp_id_email_unique a where exists (select 1 from not_unique as b where a.lovpid = b.lovpid)
;


create table prod_id_graph.id_to_email_mapping as
	select * from tmp_id_email_unique;
