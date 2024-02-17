--A. Customer Journey
--  Based off the 8 sample customers provided in the sample from the subscriptions table, write a
-- brief description about each customer’s onboarding journey.
--  Try to keep it as short as possible - you may also want to run some sort of join to make your
-- explanations a bit easier!
SELECT S.CUSTOMER_ID,
	P.PLAN_ID,
	P.PLAN_NAME,
	S.START_DATE
FROM PLANS P
JOIN SUBSCRIPTIONS S ON P.PLAN_ID = S.PLAN_ID
WHERE S.CUSTOMER_ID IN (1,2,11,13,15,16,18,19)
--I want to change this question a little bit.Instead of the customer numbers given in the 
--sample , I prefered to chose to select random customers.For that i used RANDOM()
SELECT S.CUSTOMER_ID,
	S.PLAN_ID,
	P.PLAN_NAME,
	S.START_DATE
FROM SUBSCRIPTIONS S
LEFT JOIN PLANS P ON S.PLAN_ID = P.PLAN_ID
WHERE S.CUSTOMER_ID IN
		(SELECT CUSTOMER_ID
			FROM SUBSCRIPTIONS
			ORDER BY RANDOM()
			LIMIT 5)
ORDER BY S.CUSTOMER_ID,S.PLAN_ID
--how many days does it take for customers to upgrade their membership ?
SELECT CUSTOMER_ID,
	PLAN_NAME,
	PRICE,
	TRIAL_DATE,
	START_DATE - TRIAL_DATE DAYS_TO_UPGRADE
FROM
	(SELECT S.CUSTOMER_ID,
			P.PLAN_NAME,
			S.START_DATE,
			P.PRICE,
			LAG(S.START_DATE) OVER (PARTITION BY S.CUSTOMER_ID ORDER BY S.START_DATE) TRIAL_DATE
		FROM SUBSCRIPTIONS S
		JOIN PLANS P ON S.PLAN_ID = P.PLAN_ID
where p.plan_name not like 'churn'	) NEW_TABLE
WHERE TRIAL_DATE IS NOT NULL 
ORDER BY CUSTOMER_ID,
	START_DATE;

--B. Data Analysis Questions
--1.How many customers has Foodie-Fi ever had?
SELECT COUNT (DISTINCT CUSTOMER_ID)
FROM SUBSCRIPTIONS
--2.What is the monthly distribution of trial plan start_date values for our dataset - use the 
--start of the month as the group by value
SELECT DATE_TRUNC('MONTH',START_DATE) MONTHS,
	COUNT(*) TOTAL_PLANS
FROM SUBSCRIPTIONS S
INNER JOIN PLANS AS P ON S.PLAN_ID = P.PLAN_ID
WHERE PLAN_NAME = 'trial'
GROUP BY MONTHS
ORDER BY MONTHS;
--This question specially tells us to use the start of the month.That's why i used date_trunc.
--But to be honest i think extract shall be better like ;
SELECT EXTRACT(MONTH FROM START_DATE) MONTHS,
	COUNT(*) TOTAL_PLANS
FROM SUBSCRIPTIONS S
INNER JOIN PLANS AS P ON S.PLAN_ID = P.PLAN_ID
WHERE PLAN_NAME = 'trial'
GROUP BY MONTHS
ORDER BY MONTHS;

--3.What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by 
--count of events for each plan_name
SELECT S.PLAN_ID,
	P.PLAN_NAME,
	COUNT(*)
FROM SUBSCRIPTIONS S
JOIN PLANS P ON S.PLAN_ID = P.PLAN_ID
WHERE EXTRACT (YEAR FROM S.START_DATE) > '2020'
GROUP BY S.PLAN_ID,
	P.PLAN_NAME
ORDER BY S.PLAN_ID;


--4.What is the customer count and percentage of customers who have churned rounded to 1 decimal
--place?
SELECT ROUND(
	(SELECT COUNT(CUSTOMER_ID) FROM SUBSCRIPTIONS
	WHERE PLAN_ID =(
		SELECT PLAN_ID FROM PLANS
			WHERE PLAN_NAME LIKE 'churn')) * 100.1 / COUNT(DISTINCT CUSTOMER_ID),1)CHURNED_CUST_PER
FROM SUBSCRIPTIONS
--Or if you can find plan_id of churn easily in your database ;
SELECT ROUND(
	(SELECT COUNT(CUSTOMER_ID) FROM SUBSCRIPTIONS
	WHERE PLAN_ID =4) * 100.1 / COUNT(DISTINCT CUSTOMER_ID),1)CHURNED_CUST_PER
FROM SUBSCRIPTIONS	

--5.How many customers have churned straight after their initial free trial - what percentage is
--this rounded to the nearest whole number?
WITH RANKING AS (
SELECT CUSTOMER_ID,PLAN_NAME,
	RANK() OVER(PARTITION BY customer_id ORDER BY start_date)RANK
				FROM SUBSCRIPTIONS S
				JOIN PLANS P ON S.PLAN_ID=P.PLAN_ID
)
SELECT COUNT(DISTINCT CUSTOMER_ID) CHURNED_AFTER_TRIAL,
ROUND (
(COUNT(DISTINCT CUSTOMER_ID)*100.0 )/
((SELECT COUNT(DISTINCT customer_id) 
    FROM subscriptions))
	,2)PER_OF_CHURNED_AFTER_TRIAL
FROM RANKING 
WHERE RANK=2 AND PLAN_NAME LIKE 'churn'

--6.What is the number and percentage of customer plans after their initial free trial?
WITH RANKING AS (
SELECT CUSTOMER_ID,PLAN_NAME,
	RANK() OVER(PARTITION BY customer_id ORDER BY start_date)RANK
				FROM SUBSCRIPTIONS S
				JOIN PLANS P ON S.PLAN_ID=P.PLAN_ID
)
SELECT PLAN_NAME,
COUNT(DISTINCT CUSTOMER_ID) CUSTOMER_COUNT,
ROUND (
COUNT(DISTINCT CUSTOMER_ID)*100.0/(SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS),1)
CUSTOMER_PER_PLAN
FROM RANKING 
WHERE RANK=2 
GROUP BY PLAN_NAME


--7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH RANKING AS
	(SELECT *,
			RANK () OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC)RANK
		FROM SUBSCRIPTIONS
		WHERE START_DATE <= '2020-12-31')
SELECT P.PLAN_NAME,
	COUNT(R.CUSTOMER_ID) CUSTOMER_COUNT,
	ROUND(COUNT(R.CUSTOMER_ID) * 100.0 /
								(SELECT COUNT(DISTINCT CUSTOMER_ID)
									FROM SUBSCRIPTIONS),1)CUSTOMER_RATE
FROM RANKING R
JOIN PLANS P ON R.PLAN_ID = P.PLAN_ID
WHERE RANK = 1
GROUP BY 1



--8.How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT CUSTOMER_ID)CUSTOMER
FROM SUBSCRIPTIONS
WHERE PLAN_ID =
		(SELECT PLAN_ID
			FROM PLANS
			WHERE PLAN_NAME like '%annual%')
	AND EXTRACT (YEAR FROM START_DATE) = 2020

--9.How many days on average does it take for a customer to an annual plan from the day they 
--join Foodie-Fi?
WITH ANNUAL_DATES AS
	(SELECT CUSTOMER_ID,
			START_DATE
		FROM SUBSCRIPTIONS
		WHERE PLAN_ID =
				(SELECT PLAN_ID
					FROM PLANS
					WHERE PLAN_NAME like '%annual%') ),
	TRIAL_DATES AS
	(SELECT CUSTOMER_ID,
			START_DATE
		FROM SUBSCRIPTIONS
		WHERE PLAN_ID =
				(SELECT PLAN_ID
					FROM PLANS
					WHERE PLAN_NAME like '%trial%') )
SELECT ROUND(AVG(AD.START_DATE - TD.START_DATE))AVG_DAYS
FROM ANNUAL_DATES AD
JOIN TRIAL_DATES TD ON AD.CUSTOMER_ID = TD.CUSTOMER_ID


--10.Can you further breakdown this average value into 30 day periods 
--(i.e. 0-30 days, 31-60 days etc)
WITH JOIN_DATE AS
	(SELECT CUSTOMER_ID,
			START_DATE
		FROM SUBSCRIPTIONS
		WHERE PLAN_ID = 0 ),
	PRO_ANNUAL_DATE AS
	(SELECT CUSTOMER_ID,
			START_DATE AS UPGRADE_DATE
		FROM SUBSCRIPTIONS
		WHERE PLAN_ID = 3 ),
	BINS AS
	(SELECT WIDTH_BUCKET(UPGRADE_DATE - START_DATE,0,360,12) AS AVG_DAYS_TO_UPGRADE
		FROM JOIN_DATE
		JOIN PRO_ANNUAL_DATE ON JOIN_DATE.CUSTOMER_ID = PRO_ANNUAL_DATE.CUSTOMER_ID)
SELECT ((AVG_DAYS_TO_UPGRADE - 1) * 30 || '-' || (AVG_DAYS_TO_UPGRADE) * 30) AS "30-day-range",
	COUNT(*)
FROM BINS
GROUP BY AVG_DAYS_TO_UPGRADE
ORDER BY AVG_DAYS_TO_UPGRADE;

--11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
 WITH BASIC_MONTHLY AS
	(SELECT CUSTOMER_ID,
			START_DATE BASIC_STARTS
		FROM SUBSCRIPTIONS
		WHERE PLAN_ID = 1 ),
	PRO_MONTHLY AS
	(SELECT CUSTOMER_ID,
			START_DATE PRO_STARTS
		FROM SUBSCRIPTIONS
		WHERE PLAN_ID = 2 )
SELECT BM.CUSTOMER_ID,
	BASIC_STARTS,
	PRO_STARTS
FROM PRO_MONTHLY PM
JOIN BASIC_MONTHLY BM ON BM.CUSTOMER_ID = PM.CUSTOMER_ID
WHERE BASIC_STARTS > PRO_STARTS
	AND EXTRACT(YEAR FROM BASIC_STARTS) = 2020
