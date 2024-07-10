---EX 1
SELECT DISTINCT CITY from STATION 
WHERE (ID % 2) = 0

---EX 2
SELECT 
COUNT(CITY) - COUNT(DISTINCT CITY)
FROM STATION

---EX 3
SELECT ROUND(AVG(SALARY)) - ROUND(AVG(REPLACE(SALARY,'0',""))) FROM EMPLOYEES

---EX4
SELECT round(cast(sum(item_count*order_occurrences)/sum(order_occurrences)as decimal),1) as total
FROM items_per_order

---EX5
SELECT candidate_id
FROM candidates
WHERE skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING count(skill) = 3
ORDER BY candidate_id

---EX6
SELECT user_id,
(max(date(post_date)) - min(date(post_date))) as days_between
FROM posts
WHERE date(post_date) > '01/01/2021' and date(post_date) < '01/01/2022'
GROUP BY user_id
HAVING count(post_id) >= 2

---EX7
SELECT 
card_name,
max(issued_amount) - min(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference desc

---EX8
SELECT manufacturer,
abs(sum(total_sales - cogs)) as total_loss,
count(drug) as drug_count
FROM pharmacy_sales
WHERE (total_sales - cogs) < 0
GROUP BY manufacturer
ORDER BY total_loss DESC

---EX9
select *
from Cinema
where (id % 2 != 0) and
(not(description like '%boring%'))    
order by rating desc

---EX10
select teacher_id, count(distinct subject_id) as cnt
from Teacher
group by teacher_id

---EX11
select user_id, count(follower_id) as followers_count 
from Followers
group by user_id

---EX12
select user_id, count(follower_id) as followers_count 
from Followers
group by user_id










