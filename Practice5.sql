---ex1
select country.continent, 
floor(avg(city.population))
from city 
join country on city.countrycode = country.code
group by country.continent;

---ex2
SELECT 
round(cast(count(texts.email_id)as decimal)/count(emails.email_id),2)
FROM emails Left join texts on emails.email_id = texts.email_id
and texts.signup_action = 'Confirmed'

---ex3
SELECT age_bucket,
round((sum(time_spent) filter (where activity_type = 'send')/sum(time_spent))*100.00,2) 
  as send_pct,
round((sum(time_spent) filter (where activity_type = 'open')/sum(time_spent))*100.00,2) 
  as open_pct
FROM activities
join age_breakdown 
on activities.user_id = age_breakdown.user_id 
and activities.activity_type != 'chat'
group by age_breakdown.age_bucket

---ex4
SELECT a.customer_id
FROM customer_contracts as a
left join products as b 
on a.product_id = b.product_id
group by a.customer_id
having
count (b.product_id) filter (where b.product_category = 'Analytics') >=1 and
count (b.product_id) filter (where b.product_category = 'Containers') >= 1 and
count (b.product_id) filter (where b.product_category = 'Compute') >= 1

---ex5
select 
a.employee_id, 
a.name, 
count(b.reports_to) as reports_count,
round(avg(b.age)) as average_age
from Employees as a
join Employees as b 
on a.employee_id = b.reports_to
group by a.employee_id, a.name
order by employee_id

---ex6
SELECT 
Products.product_name,
SUM(Orders.unit) AS unit
FROM Products
JOIN Orders ON Products.product_id = Orders.product_id
WHERE EXTRACT(YEAR FROM Orders.order_date) = '2020' 
  AND EXTRACT(MONTH FROM Orders.order_date) = '02'
GROUP BY Products.product_name
HAVING SUM(Orders.unit) >= 100

---ex7
select a.page_id
from pages as a
left join page_likes as b 
on a.page_id = b.page_id
group by a.page_id
having count(liked_date) = 0
order by a.page_id asc
