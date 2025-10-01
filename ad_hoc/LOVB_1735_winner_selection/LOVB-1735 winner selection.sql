with ncaa as (
	SELECT platform_user_id
	from public.platform_user_utm_parameters 
	where utm_campaign ~* 'ncaa'
),

user_email as (
	select id, email
	
	from public.platform_user as a
	where 
		exists (select 1 from ncaa as b where b.platform_user_id = a.id)
		and 
			not(email ~* '@teacode'
				or email ~* '@lovb')

),

assign_rand as (
	select *, random() as rand_val
	from user_email
)


select * from assign_rand order by rand_val limit 1

;


select * from public.platform_user;