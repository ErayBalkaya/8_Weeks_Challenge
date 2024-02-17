# Case Study 2 Pizza Runner
### By Eray Balkaya
![image](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/e922db6b-6448-43e8-b415-87ee40926c0a)



Pizza Runner is the second case study of internet's famous 8 WEEK SQL CHALLENGE

The case study information provided has been sourced from [HERE](https://8weeksqlchallenge.com/case-study-2/)

8 weeks challenge is a good way to practice sql especially for beginners.It helps you to improve your skills on EDA (Exploratory Data Analysis).

## Entity Relationship Diagram:

![image](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/87b09fd4-3913-42de-855c-9949f6041ac9)


There is not much data about Pizza Runner challenge , but the secret here is to be able to find the correct ways to answer the questions.You can examine all 6 tables below.

### 1️⃣ customer_orders

The customer_orders table captures customer pizza orders,order times and indegerents they want to add or remove from their order.

![customer_orders](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/72fb42b5-63ce-4c56-8047-972f38960ef9)


### 2️⃣ runner_orders

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!

![runner_orders](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/eb126016-b7df-4756-be92-6ff363186617)


### 3️⃣ runners                                                                                                            

The runners table shows an unique ID for each runner and the dates that each runner registered

![runners](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/7101a551-ce7a-4e39-97a4-cb6facfceafb)
         
### 4️⃣ pizza_names  

Pizza Runner only has 2 pizzas available: the Meat Lovers or Vegetarian

![pizza_names](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/0e637bef-80ad-43ac-a579-8bcfb44e0290)

### 5️⃣ pizza_recipes 

Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

![pizza_recipes](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/eed55970-a22c-403f-aa3d-5a212e832665)

### 6️⃣ pizza_toppings

This table contains all of the topping_name values with their corresponding topping_id value

![pizza_toppings](https://github.com/ErayBalkaya/8_Weeks_Challenge/assets/159141102/06f557a9-669e-4ac9-887e-5ef16321a642)

⭐Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!Click [HERE](https://github.com/ErayBalkaya/8_Weeks_Challenge/blob/main/Case_Study%232/Pizza_Runner.sql)
to see how.
## Case Study Questions

#### A. Pizza Metrics 🍕 🍕

1)How many pizzas were ordered?

2)How many unique customer orders were made?

3)How many successful orders were delivered by each runner?

4)How many of each type of pizza was delivered?

5)How many Vegetarian and Meatlovers were ordered by each customer?

6)What was the maximum number of pizzas delivered in a single order?

7)For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

8)How many pizzas were delivered that had both exclusions and extras?

9)What was the total volume of pizzas ordered for each hour of the day?

10)What was the volume of orders for each day of the week?

#### B. Runner and Customer Experience :

1)How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

2)What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

3)Is there any relationship between the number of pizzas and how long the order takes to prepare?

4)What was the average distance travelled for each customer?

5)What was the difference between the longest and shortest delivery times for all orders?

6)What was the average speed for each runner for each delivery and do you notice any trend for these values?

7)What is the successful delivery percentage for each runner?

#### C. Ingredient Optimisation
1)What are the standard ingredients for each pizza?

2)What was the most commonly added extra?

3)What was the most common exclusion?

4)Generate an order item for each record in the customers_orders table in the format of one of the following:

  Meat Lovers :🥩

  Meat Lovers - Exclude Beef ❌ 🥩 ❌

  Meat Lovers - Extra Bacon 🥓 :yum:

  Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

5)Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

6)What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

#### D. Pricing and Ratings :dollar: :dollar:

1)If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

2)What if there was an additional $1 charge for any pizza extras?

3)The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

    customer_id

    order_id

    runner_id

    rating

    order_time

    pickup_time

    Time between order and pickup

    Delivery duration

    Average speed

    Total number of pizzas

4)If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

#### Are you ready to see how it's done !!!! ???

## :boom::boom: LET'S ROLL :boom::boom:

#### A. Pizza Metrics
#### 1)How many pizzas were ordered?

```sql

SELECT COUNT(PIZZA_ID)TOTAL_ORDERS
FROM CUSTOMER_ORDERS;

```

![a1](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/ef2d8617-de47-4140-9eb7-0b05c43116d7)

#### 2)How many unique customer orders were made?

```sql

SELECT COUNT(DISTINCT ORDER_ID) UNIQUE_CUS_ORDERS_COUNT
FROM CUSTOMER_ORDERS;

```

![a2](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/0616d2d5-aa60-4077-9bed-75eadf9f88c2)

#### 3)How many successful orders were delivered by each runner?

```sql

SELECT RUNNER_ID,
	COUNT(ORDER_ID)
FROM RUNNER_ORDERS
WHERE DURATION IS NOT NULL
GROUP BY RUNNER_ID;

```

![a3](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/7e686916-5fdc-48e5-bdab-a435fb635ff9)

#### 4)How many of each type of pizza was delivered?

```sql

SELECT CO.PIZZA_ID,
	PN.PIZZA_NAME,
	COUNT(CO.PIZZA_ID)
FROM CUSTOMER_ORDERS CO
JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
WHERE DURATION IS NOT NULL
GROUP BY CO.PIZZA_ID,
	PN.PIZZA_NAME;

```

![a4](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/975f00c4-2730-40c7-b43b-47cc6daa2303)

#### 5)How many Vegetarian and Meatlovers were ordered by each customer?

```sql

SELECT CUSTOMER_ID,
	PN.PIZZA_NAME,
	COUNT(PN.PIZZA_NAME)
FROM CUSTOMER_ORDERS CO
LEFT JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
GROUP BY CO.CUSTOMER_ID,
	PN.PIZZA_NAME
ORDER BY CO.CUSTOMER_ID;

```

![a5](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/e567e692-3a78-4dad-9041-883bf64bf979)

#### 6)What was the maximum number of pizzas delivered in a single order?

```sql

SELECT ORDER_ID,
	COUNT(PIZZA_ID)ORDER_AMOUNT
FROM CUSTOMER_ORDERS
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

```

![a6](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/421c977b-44c3-4340-bdd4-600ed36d52d7)

#### 7)For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql

WITH PIZZA_CHANGES AS
	(SELECT CO.CUSTOMER_ID,
			CASE
				WHEN CO.EXCLUSIONS LIKE '%' OR CO.EXTRAS LIKE '%' THEN 1
				ELSE 0
			END AS CHANGED_PIZZA,
			CASE
				WHEN CO.EXCLUSIONS IS NULL AND CO.EXTRAS IS NULL THEN 1
				WHEN CO.EXCLUSIONS IS NULL AND CO.EXTRAS = 'NaN' THEN 1
				ELSE 0
			END AS NOT_CHANGED_PIZZA
		FROM CUSTOMER_ORDERS CO
		LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
		WHERE RO.DURATION IS NOT NULL )
SELECT CUSTOMER_ID,
	SUM(CHANGED_PIZZA) AS WITH_CHANGES_TOTAL,
	SUM(NOT_CHANGED_PIZZA) AS WITHOUT_CHANGES_TOTAL
FROM PIZZA_CHANGES
GROUP BY CUSTOMER_ID;

```

![a7](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/d0054d09-9643-418e-aadb-62f5a54197f8)


#### 8)How many pizzas were delivered that had both exclusions and extras?And what is the customer_id?

```sql

SELECT 
	CUSTOMER_ID,
	COUNT (CASE WHEN EXCLUSIONS like '%' AND EXTRAS like '%' THEN 1 ELSE NULL END)
FROM 
	CUSTOMER_ORDERS CO
LEFT JOIN 
	RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
WHERE DURATION IS NOT NULL
GROUP BY
	1;

```

![a8](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/863c34d7-2661-4da8-bfac-d29b73dfa161)

#### 9)What was the total volume of pizzas ordered for each hour of the day?
:triangular_flag_on_post: I did not exclude the canceled orders because they asks order counts not succesfull orders

```sql

SELECT EXTRACT(HOUR FROM ORDER_TIME)HOUR_OF_DAY,
	COUNT(PIZZA_ID) PIZZA_ORDERED
FROM CUSTOMER_ORDERS
GROUP BY HOUR_OF_DAY
ORDER BY HOUR_OF_DAY;

```

![a9](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/0243a33d-5098-46da-9862-108fd915cb7e)


#### 10)What was the volume of orders for each day of the week?

```sql

SELECT 
  INITCAP(TO_CHAR(ORDER_TIME,'day'))DAY_OF_WEEK,
  COUNT(PIZZA_ID) PIZZA_ORDERED
FROM CUSTOMER_ORDERS
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;

```

![a10](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/7d1175b0-b397-426b-8b0a-65567ebd722e)

#### B. Runner and Customer Experience
#### 1)How many runners signed up for each 1 week period?

```sql

SELECT COUNT(RUNNER_ID),
	EXTRACT (WEEK FROM REGISTRATION_DATE) WEEK_PERIOD
FROM RUNNERS
GROUP BY WEEK_PERIOD;

```

![b1](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/4955a368-09b0-46ef-8689-2ae202c6b2cd)

#### 2)What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql

SELECT RO.RUNNER_ID,
	ROUND(AVG(EXTRACT(MINUTES FROM RO.PICKUP_TIME::timestamp - CO.ORDER_TIME::timestamp))::decimal,
		2)TIME_MINS
FROM CUSTOMER_ORDERS CO
LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
GROUP BY RO.RUNNER_ID;

```

![b2](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/6304626e-8b79-4ac4-8cd5-32e32d1fa016)

#### 3)Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql

WITH DELIVERY_TIME AS
	(SELECT CO.ORDER_ID,
			COUNT(CO.ORDER_ID)ORDER_COUNT,
			EXTRACT(MINUTES FROM (RO.PICKUP_TIME::timestamp - CO.ORDER_TIME))DELIVERY_TIMES
		FROM CUSTOMER_ORDERS CO
		LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
		WHERE RO.PICKUP_TIME IS NOT NULL
		GROUP BY 1,
			RO.PICKUP_TIME,
			CO.ORDER_TIME)
SELECT ORDER_COUNT,
	AVG(DELIVERY_TIMES)
FROM DELIVERY_TIME
GROUP BY 1;

```

![b3](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/f82463de-b0ca-4038-820d-8193c9906289)

#### 4)What was the average distance travelled for each customer?

```sql

SELECT CO.CUSTOMER_ID,
	ROUND(AVG(DISTANCE),2)AVG_DISTANCE
FROM CUSTOMER_ORDERS CO
LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
GROUP BY 1
ORDER BY 1;

```

![b4](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/43ac031d-feec-42c8-8f8f-7c10a577d7d7)

#### 5)What was the difference between the longest and shortest delivery times for all orders?

```sql

SELECT 
    MAX(duration) - MIN(duration) AS delivery_time
FROM runner_orders 
WHERE duration IS NOT null;

```

 ![b5](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/07012a03-e0b0-452a-ae2c-696c8519ecdf)

#### 6)What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql

SELECT RUNNER_ID,ORDER_ID,
ROUND(AVG(DISTANCE/DURATION),2)km_perminute
FROM RUNNER_ORDERS
WHERE DISTANCE IS NOT NULL OR DURATION IS NOT NULL
GROUP BY 1,2
ORDER BY 1

```

![b6](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/bd646de1-4e10-4982-a509-2fc5c8f83cb2)

#### 7)What is the successful delivery percentage for each runner?

```sql

SELECT runner_id, 
 ROUND(SUM
  (CASE WHEN distance is null THEN 0
  ELSE 1
  END)*100 / COUNT(order_id), 2) AS delivery_succes_rate
FROM runner_orders
GROUP BY runner_id;

```

![b7](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/1805682f-27c8-4435-8382-c9fee459ff9f)

#### C. Ingredient Optimisation
#### 1)What are the standard ingredients for each pizza?
:triangular_flag_on_post: I first converted the comma-separated ID numbers in the 'pizza recipes' table into rows and assigned them as IDs.Then I merged the contents of the pizza with the pizza topping table in this way, and finally counted how many of each topping were used.

```sql

WITH toppings_fixed AS (
SELECT
  pizza_id,
  REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
FROM pizza_recipes)

SELECT 
  tf.topping_id, pt.topping_name,
  COUNT(tf.topping_id) AS topping_count
FROM toppings_fixed tf
INNER JOIN pizza_toppings pt
  ON tf.topping_id = pt.topping_id
GROUP BY tf.topping_id, pt.topping_name
ORDER BY topping_count DESC;

```
![c1](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/e6d151af-f93e-4cc8-8779-932e9ce6603e)

#### 2)What was the most commonly added extra?

```sql

WITH EXTRAS_FIXED AS (
SELECT  ORDER_ID,
		CUSTOMER_ID PIZZA_ID,
		REGEXP_SPLIT_TO_TABLE(EXTRAS,'[,\s]+')::INTEGER AS EXTRAS_SEPERATE,
		ORDER_TIME
		FROM CUSTOMER_ORDERS)
SELECT PT.TOPPING_NAME,
    	COUNT(EXTRAS_SEPERATE)
FROM EXTRAS_FIXED EF
LEFT JOIN PIZZA_TOPPINGS PT ON EF.EXTRAS_SEPERATE = PT.TOPPING_ID
GROUP BY PT.TOPPING_NAME
ORDER BY COUNT(EXTRAS_SEPERATE) DESC

```

![c2](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/fae97171-cf1d-4547-86bd-524f39783e4e)

#### 3)What was the most common exclusion?

```sql

WITH EXCLUSIONS_FIXED AS (
SELECT  ORDER_ID,
		CUSTOMER_ID PIZZA_ID,
		REGEXP_SPLIT_TO_TABLE(EXCLUSIONS,'[,\s]+')::INTEGER AS EXCLUSIONS_SEPERATE,
		ORDER_TIME
		FROM CUSTOMER_ORDERS)
SELECT PT.TOPPING_NAME,
    	COUNT(EXCLUSIONS_SEPERATE)
FROM EXCLUSIONS_FIXED EF
LEFT JOIN PIZZA_TOPPINGS PT ON EF.EXCLUSIONS_SEPERATE = PT.TOPPING_ID
GROUP BY PT.TOPPING_NAME
ORDER BY COUNT(EXCLUSIONS_SEPERATE) DESC;

```

![c3](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/c912f335-0106-41bb-b7c7-7ecea0224948)

#### 4)Generate an order item for each record in the customers_orders table in the format of one of the following:

:round_pushpin: Meat Lovers (I assumed this was a big data and we can't remember all id's)

```sql

SELECT ORDER_ID
FROM CUSTOMER_ORDERS
WHERE PIZZA_ID =
		(SELECT PIZZA_ID
			FROM PIZZA_NAMES
			WHERE PIZZA_NAME = 'Meatlovers')
GROUP BY ORDER_ID;

```

![c4 1](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/44be8c6f-598a-4a80-9ebb-10cc176f11e6)

:round_pushpin: Meat Lovers - Exclude Beef (Everybody loves 🥩 that' why the answer is 0️⃣ )

```sql

SELECT ORDER_ID
FROM CUSTOMER_ORDERS
WHERE PIZZA_ID =
		(SELECT PIZZA_ID
			FROM PIZZA_NAMES
			WHERE PIZZA_NAME = 'Meatlovers')
			AND exclusions = '3' OR exclusions LIKE '%3%'
GROUP BY ORDER_ID;

```

:round_pushpin: Meat Lovers - Extra Bacon 🥓 😋

```sql

WITH EXTRAS_FIXED AS (
SELECT  ORDER_ID,
		CUSTOMER_ID ,PIZZA_ID,
		REGEXP_SPLIT_TO_TABLE(EXTRAS,'[,\s]+')::INTEGER AS EXTRAS_SEPERATE
		FROM CUSTOMER_ORDERS )
SELECT EF.EXTRAS_SEPERATE,PT.TOPPING_NAME,co.order_id FROM EXTRAS_FIXED EF		
JOIN PIZZA_TOPPINGS PT ON PT.TOPPING_ID=EF.EXTRAS_SEPERATE
JOIN customer_orders co ON co.order_id=ef.order_id
WHERE PT.TOPPING_NAME='Bacon'

```

![c4 3](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/20de50a6-b54d-4aeb-8a7f-bcac60364616)

#### 5)Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
ℹ️ For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

ℹ️ This question wants to add 2x symbol before each topping added as an extra ingredient and remove exclusions by the way

```sql

SELECT PN.PIZZA_NAME,
	STRING_AGG(CASE WHEN PT.TOPPING_NAME = ANY(STRING_TO_ARRAY(CO.EXCLUSIONS,',')) THEN ''
	ELSE '2x' || PT.TOPPING_NAME
	END,', '
ORDER BY PT.TOPPING_NAME ASC) AS INGREDIENTS_LIST
FROM CUSTOMER_ORDERS CO
JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
JOIN PIZZA_RECIPES PR ON CO.PIZZA_ID = PR.PIZZA_ID
JOIN PIZZA_TOPPINGS PT ON PT.TOPPING_ID = ANY(STRING_TO_ARRAY(PR.TOPPINGS,',')::int[])
GROUP BY CO.ORDER_ID,
	PN.PIZZA_NAME;

```

![c5](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/5278f58b-00b3-443e-97c9-f808c4b202fe)

#### 6)What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql

WITH I_LIST AS
	(SELECT PN.PIZZA_NAME,
			STRING_AGG(CASE WHEN PT.TOPPING_NAME = ANY(STRING_TO_ARRAY(CO.EXCLUSIONS,',')) THEN ''
			ELSE PT.TOPPING_NAME END,', '
		ORDER BY PT.TOPPING_NAME ASC) AS INGREDIENTS_LIST
		FROM CUSTOMER_ORDERS CO
		JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
		JOIN PIZZA_RECIPES PR ON CO.PIZZA_ID = PR.PIZZA_ID
		JOIN PIZZA_TOPPINGS PT ON PT.TOPPING_ID = ANY(STRING_TO_ARRAY(PR.TOPPINGS,',')::int[])
		GROUP BY CO.ORDER_ID,
			PN.PIZZA_NAME) ,
	FIXATION AS
	(SELECT PIZZA_NAME,
			REGEXP_SPLIT_TO_TABLE(INGREDIENTS_LIST,'[,\s]+')::text AS INGREDIENTS_LIST_SEPERATE
		FROM I_LIST)
SELECT INGREDIENTS_LIST_SEPERATE,
	COUNT (INGREDIENTS_LIST_SEPERATE)
FROM FIXATION
GROUP BY 1
ORDER BY 2 DESC;

```

![c6](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/5cfc94b5-53f7-49b3-a2fd-0e6984d37429)

#### D. Pricing and Ratings 💵
#### 1)If a Meat Lovers pizza costs 💲12 and Vegetarian costs 💲10 and there were no charges for changes.How much money has Pizza Runner made so far from each type of pizza if there are no delivery fees?

```sql

SELECT CO.PIZZA_ID,
CASE WHEN CO.PIZZA_ID=1 THEN 12*COUNT(CO.PIZZA_ID)
WHEN CO.PIZZA_ID=2 THEN 10*COUNT(CO.PIZZA_ID)
ELSE 0 END AS PIZZA_FEE
FROM CUSTOMER_ORDERS CO
LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID=RO.ORDER_ID
WHERE RO.DURATION IS NOT null
GROUP BY PIZZA_ID;

```

![d1](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/098ad9b1-b51b-4e38-888f-4cb2883b6aec)

#### 2)What if there was an additional 💲1 charge for any pizza extras?

```sql

WITH TOTAL_INCOME AS
	(SELECT CO.PIZZA_ID,
			CO.ORDER_ID,
			CASE
				WHEN CO.PIZZA_ID = 1 THEN 12 * COUNT(CO.PIZZA_ID)
				WHEN CO.PIZZA_ID = 2 THEN 10 * COUNT(CO.PIZZA_ID)
				ELSE 0
			END AS PIZZA_FEE
		FROM CUSTOMER_ORDERS CO
		LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
		WHERE RO.DURATION IS NOT NULL
		GROUP BY PIZZA_ID,
			CO.ORDER_ID),
	EXTRAS_FIXED AS
	(SELECT CO.ORDER_ID,
			CUSTOMER_ID,
			PIZZA_ID,
			REGEXP_SPLIT_TO_TABLE(EXTRAS,'[,\s]+')::INTEGER AS EXTRAS_SEPERATE
		FROM CUSTOMER_ORDERS CO 
	 JOIN RUNNER_ORDERS RO ON CO.ORDER_ID=RO.ORDER_ID
	WHERE DURATION IS NOT NULL),
	EXTRAS_FEES AS
	(SELECT PIZZA_ID,
			SUM(CASE
					WHEN EXTRAS_SEPERATE IS NOT NULL THEN 1 ELSE 0 END) EXTRAS_FEE
		FROM EXTRAS_FIXED
		GROUP BY 1),
	EXTRA_TOTAL AS
	(SELECT PIZZA_ID,
			EXTRAS_FEE * COUNT(PIZZA_ID)EXTRAS_SUM
		FROM EXTRAS_FEES
		GROUP BY 1,
			EXTRAS_FEE)
SELECT TI.PIZZA_ID,
	SUM(TI.PIZZA_FEE),
	ET.EXTRAS_SUM
FROM TOTAL_INCOME TI
JOIN EXTRA_TOTAL ET ON TI.PIZZA_ID = ET.PIZZA_ID
GROUP BY 1,3;

```

![d2](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/1526811e-8844-4610-9691-a53f532fd418)

#### 3)The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner,how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql

DROP TABLE IF EXISTS runner_ratings;
CREATE TABLE runner_ratings AS
SELECT ORDER_ID,
	RUNNER_ID,
	CASE
		WHEN DURATION IS NULL THEN DURATION
		WHEN DURATION <= 15 THEN 5
		WHEN DURATION > 15 AND DURATION <= 25 THEN 4
		WHEN DURATION > 25 AND DURATION <= 35 THEN 3
		WHEN DURATION > 35 AND DURATION <= 45 THEN 2
		WHEN DURATION > 45 THEN 1
	END AS RATINGS
FROM RUNNER_ORDERS;
SELECT * FROM RUNNER_RATINGS;

```

![d3](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/bcfcf3be-c2d5-44a3-88cf-91bca63ace8b)

#### 4)If a Meat Lovers pizza was 💲12 and Vegetarian 💲10 fixed prices with no cost for extras and each runner is paid 💲0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql

WITH PIZZA_MONEY AS
	(SELECT SUM(CASE WHEN CO.PIZZA_ID = 1 THEN 12
						WHEN CO.PIZZA_ID = 2 THEN 10
							ELSE 0 END) AS PIZZA_FEE
		FROM CUSTOMER_ORDERS CO
		LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
		WHERE RO.DURATION IS NOT NULL ),
	RUNNER_MONEY AS
	(SELECT SUM(DISTANCE * 0.30)::bigint RUNNER_COST
		FROM RUNNER_ORDERS)
SELECT
	(SELECT PIZZA_FEE FROM PIZZA_MONEY) 
					-
	(SELECT RUNNER_COST FROM RUNNER_MONEY) AS TOTAL_COST;

```

![d4](https://github.com/ErayBalkaya/Case_Study-2/assets/159141102/12d079f3-9e3a-4c6c-8a3f-f1b8938c0ece)

