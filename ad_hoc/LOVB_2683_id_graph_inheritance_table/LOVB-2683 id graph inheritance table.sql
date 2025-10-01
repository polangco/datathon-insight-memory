DROP TABLE IF EXISTS public.id_graph_inheritence_20250822;
CREATE TABLE public.id_graph_inheritence_20250822 AS 
	WITH _core_graph as (
		SELECT 
			lovpid as profile_id, 
			case
				when person_type ~* 'parent' then 'HISTORICAL.DIM_PARENTS'
			 	else 'HISTORICAL.DIM_PLAYERS'
			 end as source_dataset,
			case 
				when person_type ~* 'parent' then md5(source_system || '_a_' || person_id)
				else md5(source_system || '_p_' || person_id)
			end :: varchar(100) as source_id, 
			trim(lower(first_name)) as first_name, 
			trim(lower(last_name)) as last_name, 
			email, 
			case 
				when length(phone_number) = 10 then '+1' || phone_number
	            when length(phone_number) < 10 or length(phone_number) > 11 then null
	            when phone_number::numeric > 19100000000 then null
				when phone_number::numeric < 12010000000 then null
				else '+' || phone_number 
			end as phone,
			lower(address_street) as street_address, 
			lower(address_city) as city, 
			lower(address_zip) as zip_code, 
			lower(address_state) as state, 
			lower('United States') as country,
			birth_date as birthdate,
			lower(gender) as gender,
			extract(YEAR from AGE(current_date, birth_date :: date)) as age,
			lower(first_name || ' ' || last_name) as full_name,
			lower(address_street || ', ' || address_city || ', ' || address_state || ' ' || address_zip) as full_address 
		FROM prod_id_graph.grp_people
	), 
	
	_insider_graph as (
		SELECT 
			person_id as profile_id, 
			'HISTORICAL.DIM_INSIDERS' as source_dataset,
			coalesce(insider_id :: varchar(100), email) as source_id, 
			trim(lower(first_name)) as first_name, 
			trim(lower(last_name)) as last_name, 
			email, 
			case 
				when length(phone) = 10 then '+1' || phone
		            when length(phone) < 10 or length(phone) > 11 then null
		            when phone::numeric > 19100000000 then null
				when phone::numeric < 12010000000 then null
				else '+' || phone 
			end as phone,
			null as street_address,
			null as city,
			null as state,
			lower(home_zip) as zip_code, 
			lower(country) as country,
			dob as birthdate, 
			null as gender,
			extract(YEAR from AGE(current_date, dob :: date)) as age,
			lower(first_name || ' ' || last_name) as full_name,
			null as full_address
		FROM prod_marketing.dim_braze_insiders
		WHERE is_valid
	), 
	
	_season_ticket_graph as (
		SELECT 
			person_id as profile_id, 
			'HISTORICAL.DIM_SEASON_TICKET_HOLDER' as source_dataset,
			season_ticket_id :: varchar(100) as source_id, 
			trim(lower(first_name)) as first_name, 
			trim(lower(last_name)) as last_name, 
			email, 
			null phone,
			null as street_address,
			lower(pro_team) as city,
			case
				when pro_team in ('Austin', 'Houston') then 'tx'
				when pro_team in ('Omaha') then 'ne'
				when pro_team in ('Atlanta') then 'ga'
				when pro_team in ('Salt Lake') then 'ut'
				when pro_team in ('Madison') then 'wi'
				else null 
			end as state,
			null as zip_code, 
			null as country,
			null :: date as birthdate, 
			null as gender,
			NULL :: numeric as age,
			lower(first_name || ' ' || last_name) as full_name,
			null as full_address
		FROM prod_marketing.dim_braze_season_tickets
	), 
	
	_single_ticket_graph as (
		SELECT distinct
			b.person_id as profile_id, 
			'HISTORICAL.DIM_SINGLE_MATCH_TICKET_PURCHASERS' as source_dataset,
			a.email :: varchar(300) as source_id, 
			trim(lower(a.first_name)) as first_name, 
			trim(lower(a.last_name)) as last_name, 
			a.email, 
			case 
				when length(a.phone_number) = 10 then '+1' || a.phone_number
	            when length(a.phone_number) < 10 or length(a.phone_number) > 11 then null
	            when a.phone_number::numeric > 19100000000 then null
				when a.phone_number::numeric < 12010000000 then null
				else '+' || a.phone_number 
			end as phone,
			lower(a.address_street) as street_address, 
			lower(a.pro_market) as city, 
			lower(a.address_zip) as zip_code, 
			lower(a.address_state) as state, 
			case when a.country ~* 'United States' then 'united states' else NULL end as country,
			NULL :: date as birthdate,
			NULL as gender,
			NULL :: numeric as age,
			trim(lower(a.first_name || ' ' || a.last_name)) as full_name,
			lower(a.address_street || ', ' || a.pro_market || ', ' || a.address_state || ' ' || a.address_zip) as full_address 
		FROM prod_intermediate.int_single_ticket_purchase as a
		INNER JOIN prod_marketing.dim_braze_single_ticket_purchase as b
		ON a.email = b.email
	),
	
	_combine as (
		SELECT  
			profile_id,
			source_dataset,
			source_id, 
			first_name,
			last_name, 
			email, 
			phone, 
			birthdate, 
			gender, 
			street_address, 
			city, 
			zip_code, 
			state, 
			country,
			full_name, 
			age, 
			full_address
		FROM _core_graph
		
		UNION 
		
		SELECT
			profile_id,
			source_dataset,
			source_id, 
			first_name,
			last_name, 
			email, 
			phone, 
			birthdate, 
			gender, 
			street_address, 
			city, 
			zip_code, 
			state, 
			country,
			full_name, 
			age, 
			full_address
		FROM _insider_graph
		
		UNION 
		
		SELECT
			profile_id,
			source_dataset,
			source_id, 
			first_name,
			last_name, 
			email, 
			phone, 
			birthdate, 
			gender, 
			street_address, 
			city, 
			zip_code, 
			state, 
			country,
			full_name, 
			age, 
			full_address 
		FROM _season_ticket_graph
		
		UNION 
		
		SELECT
			profile_id,
			source_dataset,
			source_id, 
			first_name,
			last_name, 
			email, 
			phone, 
			birthdate, 
			gender, 
			street_address, 
			city, 
			zip_code, 
			state, 
			country,
			full_name, 
			age, 
			full_address 
		FROM _single_ticket_graph
		
	), 
	
	_rank as (
		SELECT *, 
			row_number() over(partition by (source_dataset || source_id) order by profile_id) as r
		FROM _combine
	),
	
	_select as (
		SELECT *	
		FROM _rank
		WHERE r = 1
	)
	
	SELECT 
		profile_id,
		source_dataset,
		source_id, 
		first_name,
		last_name, 
		email, 
		phone, 
		birthdate, 
		gender, 
		trim(regexp_replace(street_address, '[[:punct:]]+', '', 'g')) as street_address, 
		city, 
		zip_code, 
		state, 
		country,
		full_name, 
		age, 
		full_address
	FROM _select
;


SELECT * FROM public.id_graph_inheritence_20250822; 

