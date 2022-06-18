-- #----------------customer_order table----------------
-- CREATE TABLE customer_orders_temp AS
-- SELECT 
-- order_id, 
-- customer_id,
-- pizza_id,
-- CASE 
-- 	WHEN exclusions IS NULL or exclusions LIKE 'null' THEN ''
--     ELSE exclusions
--     END AS exclusions,
-- CASE 
-- 	WHEN extras IS NULL or extras LIKE 'null' THEN ''
--     ELSE extras
--     END AS extras,
-- order_time
-- FROM pizza_runner.customer_orders;

-- #----------------runner_order table----------------
-- CREATE TABLE runner_orders_temp AS
-- SELECT
-- order_id,
-- runner_id,
-- CASE
-- 	WHEN pickup_time LIKE 'null' THEN NULL
--     ELSE pickup_time
--     END AS pickup_time,
-- CASE
-- 	WHEN distance LIKE 'null' THEN NULL
-- 	WHEN distance LIKE '%km' THEN TRIM('km' from distance)
--     ELSE distance
--     END AS distance,
-- CASE 
-- 	WHEN duration LIKE 'null' THEN NULL
--     WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
--     WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
--     WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
--     ELSE duration
--     END AS duration,
-- CASE
-- 	WHEN cancellation LIKE 'null' THEN NULL
--     ELSE cancellation
--     END AS cancellation
-- FROM pizza_runner.runner_orders;

#----------------Create temp pizza_recipe table----------------
#--view pizza_recipes table--
-- select * from pizza_recipes #view data

-- CREATE TEMPORARY TABLE pizza_recipes_temp AS
-- SELECT
-- r.pizza_id,
-- TRIM(j.toppings) AS toppings
-- FROM pizza_recipes r
-- JOIN json_table(replace(json_array(toppings), ',', '","'),
-- 				'$[*]' columns(toppings varchar(50) path '$')) j;

-- select * from pizza_recipes_temp

#----------------Clean customer_orders table for Part 3 Question 4 ---------------
-- CREATE TABLE customer_orders_temp_2
-- SELECT *
-- FROM customer_orders_temp
-- WHERE CHAR_LENGTH(exclusions) < 1 OR CHAR_LENGTH(extras) < 1

-- INSERT INTO customer_orders_temp_2
-- WITH comma_rows as (
-- SELECT * FROM customer_orders_temp
-- WHERE char_length(exclusions) > 1 OR char_length(extras) > 1)

-- SELECT 
-- order_id,
-- customer_id,
-- pizza_id,
-- j.exclusions,
-- j2.extras,
-- order_time
-- FROM comma_rows
-- JOIN json_table(replace(json_array(exclusions), ',', '","'), 
-- 		'$[*]' columns (exclusions INTEGER PATH '$')) j
-- JOIN json_table(replace(json_array(extras), ',', '","'),
-- 		'$[*]' columns (extras INTEGER PATH '$')) j2

-- CREATE TABLE customer_orders_clean
-- SELECT order_id , customer_id, pizza_id, order_time,
-- CASE WHEN exclusions != '' THEN exclusions ELSE NULL END AS exclusions,
-- CASE WHEN extras != '' THEN extras ELSE NULL END AS extras
-- FROM customer_orders_temp_2

-- SELECT * FROM customer_orders_clean

#-----------------Create Pizza Ingredients table ---------------------
-- CREATE TABLE pizza_ingredients 
-- SELECT 
-- n.pizza_name,
-- group_concat(pt.topping_name) AS ingredients
-- FROM pizza_recipes_temp rt
-- INNER JOIN pizza_names n on n.pizza_id = rt.pizza_id
-- INNER JOIN pizza_toppings pt on pt.topping_id = rt.toppings
-- group by n.pizza_name

