/*
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes 
amounts paid by each customer in the subscriptions table with the following requirements:

- monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
- upgrades from basic (1) to monthly (2) or pro plans are reduced by the current paid amount in that month and start immediately
- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- once a customer churns they will no longer make payments
*/

WITH payments AS 
(SELECT s.customer_id, s.start_date, p.price, p.plan_name ,p.plan_id,
LEAD(p.plan_id, 1) OVER(PARTITION BY s.customer_id) AS next_plan,
LEAD(p.plan_name, 1) OVER(PARTITION BY s.customer_id) AS next_plan_name,
LEAD(p.price, 1) OVER(PARTITION BY s.customer_id) AS next_plan_price,
LEAD(s.start_date, 1) OVER(PARTITION BY s.customer_id) AS next_plan_start_date,
RANK() OVER(PARTITION BY s.customer_id ORDER BY start_date) AS payment_order
FROM subscriptions s 
JOIN plans p 
ON p.plan_id = s.plan_id
WHERE year(start_date) = 2020),

df2 AS (SELECT *,
CASE WHEN plan_id = 1 AND (next_plan = 2 OR next_plan = 3) THEN next_plan_price - price ELSE next_plan_price END AS upgrade_price,
CASE WHEN plan_id = 2 AND next_plan = 3 THEN adddate(start_date, interval 1 MONTH) ELSE next_plan_start_date END AS payment_date
FROM payments
WHERE next_plan !=4
)

SELECT customer_id, next_plan AS plan_id, next_plan_name AS plan_name, payment_date, upgrade_price AS amount ,payment_order
FROM df2
