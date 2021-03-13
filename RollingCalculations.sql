-- Rolling Calculations

#Get number of monthly active customers.
create or replace view user_activity as
select customer_id, convert(rental_date, date) as Activity_date,
date_format(convert(rental_date,date), '%m') as Activity_Month,
date_format(convert(rental_date,date), '%Y') as Activity_year
from sakila.rental;

select * from sakila.user_activity;

create or replace view sakila.monthly_active_users as
select Activity_year, Activity_Month, count(distinct customer_id) as Active_users
from sakila.user_activity
group by Activity_year, Activity_Month
order by Activity_year asc, Activity_Month asc;
select * from monthly_active_users;


#Active users in the previous month.

with cte_usage as 
(
	select Activity_year, Activity_month, Active_users,
	lag(Active_users) over (order by Activity_year, Activity_Month) as Last_month
    from monthly_active_users)
    select * from cte_usage;

#Percentage change in the number of active customers.

with cte_usage as 
(
	select Activity_year, Activity_month, Active_users,
	lag(Active_users) over (order by Activity_year, Activity_Month) as Last_month
    from monthly_active_users)
    select *, (Active_users-Last_month)/Active_users*100 as percentage from cte_usage;
    
    
with cte_view as
(
	select
	Activity_year,
	Activity_month,
	Active_users,
	lag(Active_users) over (order by Activity_year, Activity_Month) as Last_month
	from monthly_active_users
)
select
   Activity_year,
   Activity_month,
   Active_users,
   Last_month,
   (Active_users - Last_month) as Difference
from cte_view;

#Retained customers every month.




