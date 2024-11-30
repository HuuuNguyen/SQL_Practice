---ex1
select round(count(*) filter (where order_date = customer_pref_delivery_date)*100.00/count(*),2) as immediate_percentage
from (
select customer_id,order_date,customer_pref_delivery_date,
rank() over (partition by customer_id order by order_date asc) as rank_order_date
from Delivery) a
where rank_order_date = 1
 /* the subquery can change to*/
SELECT DISTINCT ON (customer_id) order_date, customer_pref_delivery_date
FROM Delivery
ORDER BY customer_id, order_date ASC
/*This will return the first row in distinct groups defined by on clause. Add on, the order will be
determined by order by :>>*/

---ex2
select round(count(next_date - event_date) filter (where (next_date - interval '1 day' = event_date)) :: numeric/count(*),2) as fraction
from(
select player_id, event_date, 
lead(event_date) over (partition by player_id) as next_date,
rank () over (partition by player_id order by event_date)
from Activity)
where rank = 1
/* You can use min(event_date) to find the first login date, then can calculate the player_id 
where the event-date - first-event-date = try to write like this 1*/
with first_login as (
    select
        player_id,
        event_date,
        min(event_date) over (partition by player_id) as first_event_date
    from
        Activity
)
select round(cast(count(distinct(player_id)) as numeric) / (select count(distinct(player_id)) from first_login), 2) as fraction
from first_login
where event_date - interval '1 day' = first_event_date

---ex3


---ex4
select visited_on,
sum(amount) over(order by visited_on rows between 6 preceding and current row) as amount,
round(avg(amount) over (order by visited_on rows between 6 preceding and current row),2) as average_amount
from(
    select visited_on, sum(amount) as amount
    from customer
    group by visited_on)
offset 6

---ex5


---ex6
select Department, Employee, Salary from (
select b.name as Department, a.name as Employee, a.salary as Salary,
dense_rank () over (partition by b.name order by a.salary desc)
from Employee a
left join Department b on a.departmentId = b.id) a
where dense_rank in (1,2,3)

---ex7


---ex8

