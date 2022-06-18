# Case Study 2 - Pizza Runner

<img src = "https://8weeksqlchallenge.com/images/case-study-designs/2.png" width="500" height="500">

Read the full case study [here](https://8weeksqlchallenge.com/case-study-2/)

## 📖 Table of Contents
1. Brief
2. Entity Relationship Diagram
3. Case Study Questions

## 1. Brief
Danny launched a fresh pizza delivery service and wants to use data to answer the following five themes of the business:
1. Pizza Metrics
2. Runner and Customer Experience
3. Ingredient Optimisation
4. Pricing and Ratings
5. Bonus DML Challenges (DML = Data Manipulation Language)

## 2. Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/38837759/174419343-04428c2d-a739-463a-b0e1-8b0a3d1ef08a.png)

## 3. Case Study Questions
### 1. Pizza Metrics (view solution [here](https://github.com/pinusa/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/Part%20A%20and%20B%20(in%20sqlite).Rmd))
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### 2. Runner and Customer Experience (view solution [here](https://github.com/pinusa/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/Part%20A%20and%20B%20(in%20sqlite).Rmd))
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

### 3. Ingredient Optimisation (view solution [here](https://github.com/pinusa/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/Part%20C.%20Ingredient%20Optimization.sql))
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

Note: Part 1 & 2 are coded in sqlite, the rest of this section is completed with mysql

