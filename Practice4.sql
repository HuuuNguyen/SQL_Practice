---EX1
SELECT 
SUM(
CASE WHEN device_type in ('tablet','phone') then 1 else 0 end)
as mobile_views,
SUM(CASE WHEN device_type = 'laptop' then 1 else 0 end) as laptop_views
FROM viewership

---EX2
SELECT *,
case when x + y > z and x + z > y and y + z > x then 'Yes' else 'No' end
as triangle
FROM Triangle

---EX3
SELECT 
round((SUM(CASE
 WHEN call_category = 'n/a' or call_category is null then 1 else 0 
end)*100.0)/count(*),1) as uncategorised_call_pct
FROM callers

---EX4
select 
name
from Customer
where referee_id != 2 or referee_id is null
--or
select 
name
from Customer
where coalesce(referee_id,1) != 2

---EX5
select 
survived,
sum(
case
when pclass = 1 then 1 else 0
end) as first_class,

sum(
case
when pclass = 2 then 1 else 0
end) as second_class,

sum(
case
when pclass = 3 then 1 else 0
end) as third_class

from titanic
group by survived






