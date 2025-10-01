
DROP TABLE IF EXISTS prod_metabase.dim_camps_clinics;
CREATE TABLE prod_metabase.dim_camps_clinics AS
	WITH _rcl_by_club as (
		SELECT distinct club_id, rcl_name, acquisition_cohort FROM prod_raw.club_mapping	
	),
	
	_detailed_program as (
		SELECT
			source_system,
			club_id,
			club_name, 
			program_id,
			package_id,
			case 
				when program_name || package_name ~* 'clinic' then 'Clinic'
				when program_name || package_name ~* 'Camp' then 'Camp'
				else program_type
			end as program_type,
			package_start_date,
			invoice_id,
			amount, 
			refund
		FROM prod_composable.fct_registrations
	),
	
	_base_data as (
		SELECT 
			a.source_system,
			b.acquisition_cohort,
			b.rcl_name, 
			a.club_id,
			a.club_name, 
			a.program_id,
			a.package_id,
			a.program_type,
			max(a.package_start_date) as program_start_date,
			count(distinct a.invoice_id) as num_registrations,
			sum(COALESCE(a.amount, 0) + COALESCE(a.refund, 0)) as revenue  
		FROM _detailed_program as a
		LEFT JOIN _rcl_by_club as b
		ON a.club_id = b.club_id
	-- 	WHERE program_type in ('Camps', 'Clinics')
		GROUP BY
			a.source_system,
			b.acquisition_cohort,
			b.rcl_name, 
			a.club_id,
			a.club_name, 
			a.program_id,
			a.package_id,
			a.program_type
	), 
	
	_rank as (
		SELECT *, 
			row_number() over(partition by club_id, program_id, package_id order by program_start_date, revenue) as r
		FROM _base_data
	)
	
	SELECT 
		source_system,
		acquisition_cohort,
		rcl_name, 
		club_id,
		club_name, 
		program_id, 
		package_id, 
		program_type, 
		program_start_date, 
		num_registrations,
		revenue
	FROM _rank
	WHERE r = 1
;