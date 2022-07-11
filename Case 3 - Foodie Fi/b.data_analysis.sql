WITH cte_merge AS (SELECT s.customer_id, s.plan_id, s.start_date, p.plan_name, p.price
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plan p
ON s.plan_id = p.plan_id
ORDER BY customer_id ASC)

/*  B. Data Analysis */
/* 
Q1: How many customers has Foodie-Fi ever had? 
A: Foodie fi has 1,000 unique customers.
*/
SELECT COUNT(DISTINCT customer_iSd)
FROM cte_merge

/* 
Q2: What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
aka: monthly number of users on trial plan.
*/

SELECT 
MONTH(start_date) AS month_num,
DATE_FORMAT(start_date, '%M') AS month,
COUNT(*) AS monthly_users
FROM subscriptions s
JOIN plan p
ON p.plan_id = s.plan_id
WHERE s.plan_id = 0
GROUP BY month_num, month

/* 
Q3: What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
strategy:
- groupby plan_name, count start_date after the year 2020 or first day of 2020

1. extract plainid and name, count plan acc to date filter criteria
2. where year >= 2021-01-01
3. group by plan_id
*/

SELECT 
plan_id,
plan_name,
COUNT(*)
FROM cte_merge
WHERE start_date >= 2020-01-01
GROUP BY plan_id

/* Q4: What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
A: customers churn = 30%
*/

select 
count(*) as churn_count,
ROUND(count(*)/(select count(distinct customer_id) from cte_merge),1)*100 as 'churn %'
from cte_merge
where plan_id = 4

/* 
Q5: How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
*/

WITH ranking AS (
SELECT 
  s.customer_id, 
  s.plan_id, 
  p.plan_name,
  -- Run a ROW_NUMBER() to rank the plans from 0 to 4
  row_number() OVER (
    PARTITION BY s.customer_id 
    ORDER BY s.plan_id) AS plan_rank 
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plan p
  ON s.plan_id = p.plan_id)

select count(*) AS 'post-trial churn',
floor((count(*)/(select count(distinct customer_id) from subscriptions))*100) AS '%'
from ranking
where plan_id=4
and plan_rank = 2

/* 6. What is the number and percentage of customer plans after their initial free trial?
count & percentage of customers who converted to paid after the trial
*/
WITH next_plan_cte AS
(SELECT 
customer_id,
plan_id, 
LEAD(plan_id, 1) OVER(PARTITION BY customer_id) AS next_plan 
FROM subscriptions
)

SELECT next_plan,
COUNT(*) AS '# users converted',
ROUND(COUNT(*)/(SELECT count(distinct customer_id) from subscriptions)*100,2) AS '% converted'
FROM next_plan_cte
WHERE plan_id = 0
GROUP BY next_plan
ORDER BY next_plan

/* 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?*/
WITH 
next_date_cte AS
(SELECT 
*,
LEAD(start_date,1) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_date
FROM subscriptions),

customers_on_date_cte AS 
(select
start_date,
next_date
from next_date_cte
where next_date IS NOT NULL AND ('2020-12-31' > start_date and next_date > '2020-12-31')
)

select * from customers_on_date_cte
customer_on_date AS (
SELECT plan_id, COUNT(distinct customer_id) AS customers
FROM next_date_cte
group by plan_id
)

SELECT * FROM customer_on_date

/* 8. How many customers have upgraded to an annual plan in 2020?*/
WITH next_plan_cte AS
(SELECT 
customer_id,
plan_id,
LEAD(plan_id, 1) OVER(PARTITION BY customer_id) as next_plan
FROM subscriptions
WHERE year(start_date) = 2020
)

SELECT COUNT(distinct customer_id) AS user_count
FROM next_plan_cte
where next_plan = 3

/* 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?*/
-- difference between date joined (trial start date) and plan 3 start date, then avg(difference)

WITH 
join_date_cte AS (SELECT customer_id, plan_id, start_date as join_start_date FROM subscriptions WHERE plan_id = 0),
pro_date_cte AS (SELECT customer_id, start_date as pro_start_date FROM subscriptions WHERE plan_id = 3)

select avg(timestampdiff(DAY, join_start_date ,pro_start_date)) as avg_convert_days
from join_date_cte j
JOIN pro_date_cte p
ON j.customer_id = p.customer_id

/* 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
approach: avg(timestampdiff(start_date of plan_id =3 - sd.pid=1)), use case when to bin data in mysql between 0 and 30
*/

WITH
annual_cte AS (SELECT customer_id, plan_id, start_date AS start_date_id3 FROM subscriptions WHERE plan_id = 3),
trial_cte AS (SELECT customer_id, plan_id, start_date AS start_date_id0 FROM subscriptions WHERE plan_id = 0),
new_df AS (SELECT a.customer_id, t.plan_id AS trial_planid, start_date_id0, a.plan_id, start_date_id3 FROM annual_cte a JOIN trial_cte t on a.customer_id = t.customer_id),
days_df AS (SELECT timestampdiff(DAY, start_date_id0, start_date_id3) AS days_to_conversion FROM new_df),
ans_df AS (SELECT *,
CASE 
WHEN days_to_conversion <= 30 THEN '0-30'
WHEN days_to_conversion BETWEEN 31 AND 60 THEN '31-60'
WHEN days_to_conversion BETWEEN 61 AND 90 THEN '61-90'
WHEN days_to_conversion BETWEEN 91 AND 120 THEN '91-120'
WHEN days_to_conversion BETWEEN 121 AND 150 THEN '121-150'
WHEN days_to_conversion BETWEEN 151 AND 180 THEN '151-180'
WHEN days_to_conversion BETWEEN 181 AND 210 THEN '181-210'
WHEN days_to_conversion BETWEEN 211 AND 240 THEN '211-240'
WHEN days_to_conversion BETWEEN 241 AND 270 THEN '241-270'
WHEN days_to_conversion BETWEEN 271 AND 300 THEN '271-300'
WHEN days_to_conversion BETWEEN 301 AND 330 THEN '301-330'
WHEN days_to_conversion BETWEEN 331 AND 360 THEN '331-360'
ELSE NULL
END AS thirty_day_periods
FROM days_df
ORDER BY days_to_conversion)

SELECT thirty_day_periods, 
count(days_to_conversion) AS 'avg. days from trial to pro'
FROM ans_df 
GROUP BY thirty_day_periods
ORDER BY length(thirty_day_periods)

/* 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
approach: where year(start_date) = 2020, current plan 2 > next plan 1, count distinct customer_id
*/

WITH next_plan_cte as (
SELECT 
s.customer_id,
p.plan_name,
p.plan_id,
LEAD(s.plan_id,1) OVER(PARTITION BY s.customer_id) AS next_plan
FROM plans p
JOIN subscriptions s
ON p.plan_id = s.plan_id
WHERE year(s.start_date) = 2020
)

SELECT * 
FROM next_plan_cte
WHERE plan_id = 2 AND next_plan = 1