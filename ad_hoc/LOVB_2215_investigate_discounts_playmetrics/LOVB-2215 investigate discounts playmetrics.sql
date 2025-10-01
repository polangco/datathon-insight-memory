select * from public.playmetrics_subscriptions_latest limit 10;


--- 
select 
	subscription_id,
	player_id, 
	budget, 
	discounts,
	adjustments,
	cancellations, 
	projected_total,
	min(last_modified) as last_modified
from public.playmetrics_subscriptions
where subscription_id in (3936107, 3850780)
group by 
	subscription_id,
	player_id, 
	budget, 
	discounts,
	adjustments,
	cancellations, 
	projected_total
order by 
	subscription_id,
	min(last_modified)
;

---- 
with _latest_subs as (
	select 
		subscription_id,
		subscription_date :: date as created_date,
		player_id, 
		budget, 
		discounts,
		adjustments,
		cancellations, 
		late_fees,
		projected_total
	from public.playmetrics_subscriptions_latest
	where subscription_date :: date between to_date('20240601', 'YYYYMMDD') and to_date('20240831', 'YYYYMMDD')
),

_history as (
	select 
		subscription_id,
		subscription_date :: date as created_date,
		player_id, 
		budget, 
		discounts,
		adjustments,
		cancellations, 
		late_fees,
		projected_total,
		min(last_modified) :: date as last_modified
	from public.playmetrics_subscriptions as a
	where exists (select 1 from _latest_subs as b where a.subscription_id = b.subscription_id)
	group by 
		subscription_id,
		subscription_date :: date,
		player_id, 
		budget, 
		discounts,
		adjustments,
		cancellations,
		late_fees, 
		projected_total
), 

_flag_oom as (
	select
		*, 
		case
			when extract(year from created_date) < extract(year from last_modified) then 1
			when extract(month from created_date) < extract(month from last_modified) then 1
			else 0 
		end as oom
	from _history
), 

_mask as ( 
	select subscription_id  
	from _flag_oom
	group by subscription_id
	having max(oom) > 0
), 

_final as (
	select * 
	from _history as a
	where exists (
		select 1 
		from _mask as b 
		where a.subscription_id = b.subscription_id
	)
)

select 
	subscription_id,
	created_date,
	player_id, 
	budget, 
	discounts,
	adjustments,
	cancellations, 
	late_fees,
	projected_total,
	last_modified
from _final
order by subscription_id, last_modified
;