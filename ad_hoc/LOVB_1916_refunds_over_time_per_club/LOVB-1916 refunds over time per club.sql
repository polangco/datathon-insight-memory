
select 
	extract(year from payout_date) as payout_year,
	extract(month from payout_date) as payout_month,
	concat(extract(year from payout_date)::varchar, '-', right(concat('0', extract(month from payout_date)::varchar), 2)) as year_month,
	
	count(distinct club_id) as num_clubs,
	count(distinct invoice_id) as num_refund, 
	sum(abs(amount)) as dols_refund,
	
	round(count(distinct invoice_id)::numeric / count(distinct club_id)::numeric, 2) as num_refunds_per_club, 
	round(sum(abs(amount))::numeric / count(distinct club_id)::numeric, 2) as dols_refunds_per_club,
	round(sum(abs(amount))::numeric / count(distinct invoice_id)::numeric, 2) as dols_per_refund
	
from prod_composable.fct_transactions 
where transaction_type = 'refund' and payout_date is not null
group by extract(year from payout_date), extract(month from payout_date)
order by extract(year from payout_date), extract(month from payout_date);