---ex1
with j_listing as(
select count(job_id) as ctj 
from job_listings
group by company_id)

select count(ctj) filter (where ctj>1) as duplicate_companies
from j_listing

---ex2
with elec as (
select category, product, sum(spend) as total_spend from product_spend
where extract(year from transaction_date) = '2022'
and category = 'electronics'
group by product,category
order by total_spend DESC
limit 2),
app as (
select category, product, sum(spend) as total_spend from product_spend
where extract(year from transaction_date) = '2022'
and category = 'appliance'
group by product,category
order by total_spend DESC
limit 2)

select category,product,total_spend
from app
union all select category,product,total_spend 
from elec 

---ex3
with step1 as(
select policy_holder_id, count(case_id) as cnt
from callers 
group by policy_holder_id)

select count(cnt) filter (where cnt >= 3) as policy_holder_count
from step1 

---ex4
select page_id from pages
where page_id not in (
select page_id from page_likes)

---ex5 - coi lại
with june as(
select distinct user_id,month FROM user_actions where extract (month from event_date) = '06'),
july as (
select distinct user_id,month FROM user_actions where extract (month from event_date) = '07')

select a.month, count(a.user_id) as monthly_active_users from june as a
join july as b on a.user_id = b.user_id
group by a.month

---ex6
with result as(
select to_char(trans_date,'yyyy-mm') as month,
country,
count(amount) as trans_count, 
count(amount) filter (where state = 'approved') as approved_count,
sum(amount) as trans_total_amount,
sum(amount) filter (where state ='approved') as approved_total_amount
from Transactions
group by month,country
order by month,country)

select month, country, trans_count, approved_count, trans_total_amount,
coalesce(approved_total_amount, 0) as approved_total_amount from result

---ex6(2)
select to_char(trans_date,'yyyy-mm') as month,
country,
count(amount) as trans_count, 
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from Transactions
group by month,country
order by month

---ex7
select a.product_id, b.first_year, a.quantity, a.price from sales a
join (
select product_id,min(year) as first_year
from sales 
group by product_id
order by product_id) b on a.product_id = b.product_id 
and b.first_year = a.year

---ex8
with result as(
select customer_id, count(distinct product_key) as cnt
from Customer 
group by customer_id)

select customer_id from result
where cnt = (select count (distinct product_key) from Product)

---ex9
select employee_id 
from Employees 
where manager_id not in (select employee_id from Employees)
and salary < 30000
order by employee_id

---ex10
with result1 as(
select employee_id, department_id from Employee 
where primary_flag = 'Y'),
result2 as(
select employee_id, department_id from Employee
where primary_flag = 'N' 
and employee_id not in (
    select employee_id from Employee 
where primary_flag = 'Y'))

select employee_id, department_id from result1
union all
select employee_id, department_id from result2
order by employee_id

---ex10 (2)

---ex11
(select b.name as results
from movierating a 
left join users b on a.user_id = b.user_id
group by b.name
order by count(rating) desc,b.name
limit 1)
union all
(select b.title as results
from movierating a
left join movies b on a.movie_id = b.movie_id
where extract (month from a.created_at) = '2' and extract (year from a.created_at) = '2020'
group by b.title
order by avg(a.rating) desc
limit 1)

---ex12
with result1 as(
select requester_id, accepter_id from RequestAccepted
union all
select accepter_id,requester_id from RequestAccepted)

select requester_id as id, count(accepter_id) as num
from result1
group by id
order by num desc
limit 1
