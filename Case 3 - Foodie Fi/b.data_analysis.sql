WITH cte_merge AS (SELECT s.customer_id, s.plan_id, s.start_date, p.plan_name, p.price
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plan p
ON s.plan_id = p.plan_id
ORDER BY customer_id ASC)

/*  B. Data Analysis */
/* 
Q: How many customers has Foodie-Fi ever had? 
A: Foodie fi has 1,000 unique customers.
*/
-- SELECT COUNT(DISTINCT customer_iSd)
-- FROM cte_merge

/* 
Q: What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
aka: monthly number of users on trial plan.
*/

-- SELECT 
-- MONTH(start_date) AS month_num,
-- DATE_FORMAT(start_date, '%M') AS month,
-- COUNT(*) AS monthly_users
-- FROM subscriptions s
-- JOIN plan p
-- ON p.plan_id = s.plan_id
-- WHERE s.plan_id = 0
-- GROUP BY month_num, month

/* 
Q: What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
strategy:
- groupby plan_name, count start_date after the year 2020 or first day of 2020

1. extract plainid and name, count plan acc to date filter criteria
2. where year >= 2021-01-01
3. group by plan_id
*/

-- SELECT 
-- plan_id,
-- plan_name,
-- COUNT(*)
-- FROM cte_merge
-- WHERE start_date >= 2020-01-01
-- GROUP BY plan_id

/* Q: What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
A: customers churn = 30%
*/

-- select 
-- count(*) as churn_count,
-- ROUND(count(*)/(select count(distinct customer_id) from cte_merge),1)*100 as 'churn %'
-- from cte_merge
-- where plan_id = 4

/* 
Q: How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
*/


/* What is the number and percentage of customer plans after their initial free trial?*/
/* What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?*/
/* How many customers have upgraded to an annual plan in 2020?*/
/* How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?*/
/* Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)*/
/* How many customers downgraded from a pro monthly to a basic monthly plan in 2020?*/

