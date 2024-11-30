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
select id, concat(student1, student2) as student from (
select id, case when id % 2 = 1 then lead else lag end as student1,
case when id = (select id from Seat order by id desc limit 1) and id % 2 = 1 then student else null end as student2
from (
select *, lead(student) over (order by id),
lag(student) over (order by id)
from Seat))
/* nếu để order by student thì nó sẽ xếp theo abcd*/

---ex3(2) - explain, check it again
 select id, 
    coalesce(
        case
            when id % 2 != 0 then lead(student) over ()
            else lag(student) over ()
        end,
        student
    ) as student
from seat

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
with draft1 as (
select *,concat(lat,lon) as latlon
from insurance),
draft2 as (
select a.tiv_2016 from draft1 as a
left join draft1 as b on a.pid = b.pid
where a.latlon in (
     select latlon
     from draft1
     group by latlon
     having count(latlon) = 1) and 
    a.tiv_2015 in (
     select tiv_2015
     from draft1
     group by tiv_2015
     having count(tiv_2015) > 1))

select round(sum(tiv_2016)::numeric,2) as tiv_2016 from draft2

---ex6
select Department, Employee, Salary from (
select b.name as Department, a.name as Employee, a.salary as Salary,
dense_rank () over (partition by b.name order by a.salary desc)
from Employee a
left join Department b on a.departmentId = b.id) a
where dense_rank in (1,2,3)

---ex7
select person_name from (
select person_name, turn,
sum(weight) over (order by turn) as sum
from Queue) a
where sum <= 1000
order by sum desc 
limit 1

---ex8
with draft1 as (
select product_id, new_price as price from (
select *,
max(change_date) over (partition by product_id)
from Products 
where change_date <= '2019-08-16')
where change_date = max),
 
draft2 as (
select distinct product_id, price from (
select *,
case 
when change_date > '2019-08-16' then 10 else new_price end as price
from Products
where product_id not in (select product_id from Products where change_date <= '2019-08-16')))


select product_id, price from draft1
union all
select product_id, price from draft2

---ex8(2)
select product_id, new_price as price from products
where (product_id,change_date) in (select product_id,max(change_date) from products where change_date <= '2019-08-16' group by product_id)

union

select product_id, 10 as price from products
where product_id not in (select product_id from products where change_date <= '2019-08-16')


