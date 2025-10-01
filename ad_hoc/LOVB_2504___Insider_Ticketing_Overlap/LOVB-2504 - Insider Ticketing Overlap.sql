with _insider_add_market as (
	select 
		email, 
		max(case 
			when address_zip ~ '^(300|301|302|303|305|306|310|311|312)' and address_country = 'United States' then 'Atlanta'
			when address_zip ~ '^(787|786|789)' and address_country = 'United States' then 'Austin'
			when address_zip ~ '^(770|773|774|775|776|777)' and address_country = 'United States' then 'Houston'
			when address_zip ~ '^(53|61|52|54)' and address_country = 'United States' then 'Madison'
			when address_zip ~ '^(68|51|54|66)' and address_country = 'United States' then 'Omaha'
			when address_zip ~ '^(840|841|842|843|844)' and address_country = 'United States' then 'Salt Lake'
			when address_country = 'United States' then 'Non-Market US'
			when coalesce(address_country, '') = '' then 'Unknown'
			else 'International'
		end) as market,
		TRUE as is_insider
			
	from prod_intermediate.int_insider_profile
	group by email
),

_season_tickets as (
	select  
		email, 
		pro_team, 
		is_season_ticket_holder
	from prod_marketing.dim_braze_season_tickets
), 

_match_tickets as (
	select 
		email, 
		purchased_single_match_atlanta,
		purchased_single_match_austin,
		purchased_single_match_houston,
		purchased_single_match_madison,
		purchased_single_match_omaha,
		purchased_single_match_salt_lake 
	from prod_marketing.dim_braze_single_match_tickets
),

_join_season as (
	select
		COALESCE(a.email, b.email) as email,
		a.market, 
		b.pro_team,
		COALESCE(a.is_insider, FALSE) as is_insider,
		COALESCE(b.is_season_ticket_holder, FALSE) as is_season_ticket_holder
	from _insider_add_market as a
	full join _season_tickets as b
	on a.email = b.email
),

_join_match as (
	select
		COALESCE(a.email, b.email) as email,
		case 
			when COALESCE(a.market, a.pro_team) is null and purchased_single_match_atlanta then 'Atlanta'
			when COALESCE(a.market, a.pro_team) is null and purchased_single_match_austin then 'Austin'
			when COALESCE(a.market, a.pro_team) is null and purchased_single_match_houston then 'Houston'
			when COALESCE(a.market, a.pro_team) is null and purchased_single_match_madison then 'Madison'
			when COALESCE(a.market, a.pro_team) is null and purchased_single_match_omaha then 'Omaha'
			when COALESCE(a.market, a.pro_team) is null and purchased_single_match_salt_lake then 'Salt Lake'
			when 
				a.market not in ('Atlanta', 'Austin', 'Houston', 'Madison', 'Omaha', 'Salt Lake') 
				and a.pro_team in ('Atlanta', 'Austin', 'Houston', 'Madison', 'Omaha', 'Salt Lake') then a.pro_team
			else COALESCE(a.market, a.pro_team, 'Unknown')
		end as market,
		COALESCE(a.is_insider, FALSE) as is_insider,
		COALESCE(a.is_season_ticket_holder, FALSE) as is_season_ticket_holder,
		COALESCE(b.purchased_single_match_atlanta, FALSE) as purchased_single_match_atlanta,
		COALESCE(b.purchased_single_match_austin, FALSE) as purchased_single_match_austin,
		COALESCE(b.purchased_single_match_houston, FALSE) as purchased_single_match_houston,
		COALESCE(b.purchased_single_match_madison, FALSE) as purchased_single_match_madison,
		COALESCE(b.purchased_single_match_omaha, FALSE) as purchased_single_match_omaha,
		COALESCE(b.purchased_single_match_salt_lake, FALSE) as purchased_single_match_salt_lake
	from _join_season as a
	full join _match_tickets as b
	on a.email = b.email
	where COALESCE(a.email, b.email, '') != ''
)

select * from _join_match
;