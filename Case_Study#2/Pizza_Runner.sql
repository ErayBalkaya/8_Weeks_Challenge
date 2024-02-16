--A. Pizza Metrics
--1)How many pizzas were ordered?
SELECT COUNT(PIZZA_ID)TOTAL_ORDERS
FROM CUSTOMER_ORDERS;
--2)How many unique customer orders were made?
SELECT COUNT(DISTINCT ORDER_ID) UNIQUE_CUS_ORDERS_COUNT
FROM CUSTOMER_ORDERS;
--3)How many successful orders were delivered by each runner?
SELECT RUNNER_ID,
	COUNT(ORDER_ID)
FROM RUNNER_ORDERS
WHERE DURATION IS NOT NULL
GROUP BY RUNNER_ID;
--4)How many of each type of pizza was delivered?
SELECT CO.PIZZA_ID,
	PN.PIZZA_NAME,
	COUNT(CO.PIZZA_ID)
FROM CUSTOMER_ORDERS CO
JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
WHERE DURATION IS NOT NULL
GROUP BY CO.PIZZA_ID,
	PN.PIZZA_NAME;

--5)How many Vegetarian and Meatlovers were ordered by each customer?
SELECT CUSTOMER_ID,
	PN.PIZZA_NAME,
	COUNT(PN.PIZZA_NAME)
FROM CUSTOMER_ORDERS CO
LEFT JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
GROUP BY CO.CUSTOMER_ID,
	PN.PIZZA_NAME
ORDER BY CO.CUSTOMER_ID;
--6)What was the maximum number of pizzas delivered in a single order?
SELECT ORDER_ID,
	COUNT(PIZZA_ID)ORDER_AMOUNT
FROM CUSTOMER_ORDERS
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
--7)For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

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
			END AS NO_CHANGED_PIZZA
		FROM CUSTOMER_ORDERS CO
		LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
		WHERE RO.DURATION IS NOT NULL )
SELECT CUSTOMER_ID,
	SUM(CHANGED_PIZZA) AS WITH_CHANGES_TOTAL,
	SUM(NO_CHANGED_PIZZA) AS WITHOUT_CHANGES_TOTAL
FROM PIZZA_CHANGES
GROUP BY CUSTOMER_ID;

--8)How many pizzas were delivered that had both exclusions and extras?And what is the customer_id?
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
--9)What was the total volume of pizzas ordered for each hour of the day?
--I did not exclude the canceled orders because they asks order counts not succesfull orders
SELECT EXTRACT(HOUR FROM ORDER_TIME)HOUR_OF_DAY,
	COUNT(PIZZA_ID) PIZZA_ORDERED
FROM CUSTOMER_ORDERS
GROUP BY HOUR_OF_DAY
ORDER BY HOUR_OF_DAY;

--10)What was the volume of orders for each day of the week?
SELECT 
	INITCAP(TO_CHAR(ORDER_TIME,'day'))DAY_OF_WEEK,
	COUNT(PIZZA_ID) PIZZA_ORDERED
FROM CUSTOMER_ORDERS
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;
--B. Runner and Customer Experience
--1)How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT COUNT(RUNNER_ID),
	EXTRACT (WEEK FROM REGISTRATION_DATE) WEEK_PERIOD
FROM RUNNERS
GROUP BY WEEK_PERIOD;

--2)What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT RO.RUNNER_ID,
	ROUND(AVG(EXTRACT(MINUTES FROM RO.PICKUP_TIME::timestamp - CO.ORDER_TIME::timestamp))::decimal,
		2)TIME_MINS
FROM CUSTOMER_ORDERS CO
LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
GROUP BY RO.RUNNER_ID;


--3)Is there any relationship between the number of pizzas and how long the order takes to prepare?
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
--4)What was the average distance travelled for each customer?
SELECT CO.CUSTOMER_ID,
	ROUND(AVG(DISTANCE),2)AVG_DISTANCE
FROM CUSTOMER_ORDERS CO
LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID = RO.ORDER_ID
GROUP BY 1
ORDER BY 1;

--5)What was the difference between the longest and shortest delivery times for all orders?
	SELECT 
    MAX(duration) - MIN(duration) AS delivery_time
	FROM runner_orders 
	WHERE duration IS NOT null;
--6)What was the average speed for each runner for each delivery and do you notice any trend for
--these values?
SELECT RUNNER_ID,ORDER_ID,
ROUND(AVG(DISTANCE/DURATION),2)km_perminute
FROM RUNNER_ORDERS
WHERE DISTANCE IS NOT NULL OR DURATION IS NOT NULL
GROUP BY 1,2
ORDER BY 1

--7)What is the successful delivery percentage for each runner?
SELECT runner_id, 
 ROUND(SUM
  (CASE WHEN distance is null THEN 0
  ELSE 1
  END)*100 / COUNT(order_id), 2) AS delivery_succes_rate
FROM runner_orders
GROUP BY runner_id;
--C. Ingredient Optimisation
--1)What are the standard ingredients for each pizza?
--önce pizza recipes tablosunda virgülle yazılı olan id'leri kolon yapıp id olarak atadım.
WITH toppings_fixed AS (
SELECT
  pizza_id,
  REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
FROM pizza_recipes)
--2 pizzanın içeriklerini bu sayede pizza topping tablosuyla birleştirdim ve en son olarak
--hangi toppingten kaçar adet kullanıldığını saydım
SELECT 
  tf.topping_id, pt.topping_name,
  COUNT(tf.topping_id) AS topping_count
FROM toppings_fixed tf
INNER JOIN pizza_toppings pt
  ON tf.topping_id = pt.topping_id
GROUP BY tf.topping_id, pt.topping_name
ORDER BY topping_count DESC;

--2)What was the most commonly added extra?
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

--3)What was the most common exclusion?
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
--4)Generate an order item for each record in the customers_orders table in the format of one 
--of the following:

--Meat Lovers (Assume this was a big data and we can't remember all ids)
SELECT ORDER_ID
FROM CUSTOMER_ORDERS
WHERE PIZZA_ID =
		(SELECT PIZZA_ID
			FROM PIZZA_NAMES
			WHERE PIZZA_NAME = 'Meatlovers')
GROUP BY ORDER_ID;
--Meat Lovers - Exclude Beef 
SELECT ORDER_ID
FROM CUSTOMER_ORDERS
WHERE PIZZA_ID =
		(SELECT PIZZA_ID
			FROM PIZZA_NAMES
			WHERE PIZZA_NAME = 'Meatlovers')
			AND exclusions = '3' OR exclusions LIKE '%3%'
GROUP BY ORDER_ID;
--Meat Lovers - Extra Bacon
WITH EXTRAS_FIXED AS (
SELECT  ORDER_ID,
		CUSTOMER_ID ,PIZZA_ID,
		REGEXP_SPLIT_TO_TABLE(EXTRAS,'[,\s]+')::INTEGER AS EXTRAS_SEPERATE
		FROM CUSTOMER_ORDERS )
SELECT EF.EXTRAS_SEPERATE,PT.TOPPING_NAME,co.order_id FROM EXTRAS_FIXED EF		
JOIN PIZZA_TOPPINGS PT ON PT.TOPPING_ID=EF.EXTRAS_SEPERATE
JOIN customer_orders co ON co.order_id=ef.order_id
WHERE PT.TOPPING_NAME='Bacon'


--5)Generate an alphabetically ordered comma separated ingredient list for each pizza order from 
--the customer_orders table and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
--This question wants to add 2x symbol before each topping added as an extra ingredient and 
--remove exclusions by the way
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
--6)What is the total quantity of each ingredient used in all delivered pizzas sorted by most 
--frequent first?
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
--D. Pricing and Ratings
--1)If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for 
--changes.how much money has Pizza Runner made so far from each type of pizza if there are no 
--delivery fees?
SELECT CO.PIZZA_ID,
CASE WHEN CO.PIZZA_ID=1 THEN 12*COUNT(CO.PIZZA_ID)
WHEN CO.PIZZA_ID=2 THEN 10*COUNT(CO.PIZZA_ID)
ELSE 0 END AS PIZZA_FEE
FROM CUSTOMER_ORDERS CO
LEFT JOIN RUNNER_ORDERS RO ON CO.ORDER_ID=RO.ORDER_ID
WHERE RO.DURATION IS NOT null
GROUP BY PIZZA_ID;
--2)What if there was an additional $1 charge for any pizza extras?

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
--3)The Pizza Runner team now wants to add an additional ratings system that allows customers 
--to rate their runner, 
--how would you design an additional table for this new dataset - generate a schema for this 
--new table and insert your own data for ratings for each successful customer order between 1 to 5.
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

--4)If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
--each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left 
--over after these deliveries?
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

