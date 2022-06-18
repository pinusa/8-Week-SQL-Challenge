-- -- 1. What are the standard ingredients for each pizza?
-- SELECT 
-- n.pizza_name,
-- group_concat(pt.topping_name)
-- FROM pizza_recipes_temp rt
-- INNER JOIN pizza_names n on n.pizza_id = rt.pizza_id
-- INNER JOIN pizza_toppings pt on pt.topping_id = rt.toppings
-- group by n.pizza_name

-- -- 2. What was the most commonly added extra?
-- WITH extra_count_cte AS
--   (SELECT trim(extras) AS extra_topping,
--           count(*) AS purchase_counts
--    FROM row_split_customer_orders_temp
--    WHERE extras IS NOT NULL
--    GROUP BY extras)

-- SELECT topping_name,
--        purchase_counts
-- FROM extra_count_cte
-- INNER JOIN pizza_toppings ON extra_count_cte.extra_topping = pizza_toppings.topping_id;
-- LIMIT 1;

-- -- 3. What was the most common exclusion?
-- SELECT
-- topping_name AS topping,
-- COUNT(*) AS exclusion_count
-- FROM customer_orders_temp ot
-- JOIN pizza_toppings t ON t.topping_id = ot.exclusions
-- WHERE exclusions != ''
-- GROUP BY exclusions
-- LIMIT 1;

-- -- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- -- Meat Lovers
-- -- Meat Lovers - Exclude Beef
-- -- Meat Lovers - Extra Bacon
-- -- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

-- SELECT order_id, order_time, customer_id,
-- CASE
-- WHEN pizza_id = 1 AND exclusions IS NULL AND extras IS NULL THEN 'Meatlovers'
-- WHEN pizza_id = 1 AND exclusions = 3 THEN 'Meatlovers - Exclude Beef'
-- WHEN pizza_id = 1 AND exclusions IS NULL AND extras = 1 THEN 'Meatlovers - Extra Bacon'
-- WHEN pizza_id = 1 AND exclusions = 2 AND extras = 1 THEN 'Meatlovers - Exclude BBQ Sauce - Extra Bacon'
-- WHEN pizza_id = 1 AND exclusions = 2 AND extras = 4 THEN 'Meatlovers - Exclude BBQ Sauce - Extra Cheese'
-- WHEN pizza_id = 1 AND exclusions = 4 AND extras IS NULL THEN 'Meatlovers - Exclude Cheese'
-- WHEN pizza_id = 1 AND exclusions = 4 AND extras = 1 THEN 'Meatlovers - Exclude Cheese - Extra Bacon'
-- WHEN pizza_id = 1 AND exclusions = 4 AND extras = 5 THEN 'Meatlovers - Exclude Cheese - Extra Chicken'
-- WHEN pizza_id = 1 AND exclusions = 6 AND extras = 1 THEN 'Meatlovers - Exclude Mushrooms - Extra Bacon'
-- WHEN pizza_id = 1 AND exclusions = 6 AND extras = 4 THEN 'Meatlovers - Exclude Mushrooms - Extra Cheese'
-- WHEN pizza_id = 2 AND exclusions IS NULL AND extras IS NULL THEN 'Vegetarian'
-- WHEN pizza_id = 2 AND exclusions = 4 AND extras IS NULL THEN 'Vegetarian - Exclude Cheese'
-- WHEN pizza_id = 2 AND exclusions IS NULL AND extras = 1 THEN 'Vegetarian - Extra Bacon'
-- ELSE NULL END AS order_item
-- FROM customer_orders_clean
-- ORDER BY pizza_id

-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?