---ex1
select extract(year from transaction_date) as year,product_id, spend as curr_year_spend,
lag(spend) over (PARTITION BY product_id order by extract(year from transaction_date)) as prev_year_spend,
round((spend/lag(spend) over (PARTITION BY product_id order by extract(year from transaction_date))-1)*100.00,2) as yoy_rate
from user_transactions

---ex2
select distinct card_name, issued_amount
from (select card_name,
first_value (issued_amount) over (partition by card_name order by issue_year,issue_month) as issued_amount
from monthly_cards_issued) as a
order by issued_amount desc

---ex3
select user_id, spend, transaction_date
from(
SELECT 
user_id, spend, transaction_date,
row_number() over(partition by user_id order by transaction_date)
FROM transactions) as a
where row_number = 3

---ex4
select transaction_date, user_id, purchase_count
from(
Select transaction_date, user_id, 
count(*) over (partition by user_id,transaction_date order by transaction_date desc) as purchase_count,
row_number () over (partition by user_id) 
FROM user_transactions) as a
where row_number = 1
order by transaction_date

---ex5
SELECT user_id, tweet_date,
round(avg(tweet_count) over (partition by user_id order by tweet_date 
rows between 2 preceding and current row),2) as rolling_avg_3d
FROM tweets

---ex6
select count(*) payment_count from (
SELECT merchant_id, credit_card_id, amount, transaction_timestamp,
lag(transaction_timestamp) over (partition by merchant_id,credit_card_id,amount order by transaction_timestamp) as previous_timestamp,
(extract(epoch from transaction_timestamp) - extract(epoch from lag(transaction_timestamp) over (partition by merchant_id,credit_card_id,amount order by transaction_timestamp)))/60 as diff
FROM transactions) a
where diff <= 10

---ex7
select category,product, total_spend from (
select category, product, sum(spend) as total_spend,
rank () over (partition by category order by sum(spend) desc) as rank
from product_spend
where extract (year from transaction_date) = '2022'
group by category, product) a
where rank in (1,2)

---ex8
with draft as(
select artist_name,
dense_rank () over (order by count(day) desc) as artist_rank
FROM artists a
left join songs b on a.artist_id = b.artist_id
left join global_song_rank c on b.song_id = c.song_id
where rank <= 10
group by artist_name)

select * from draft
where artist_rank <=5


