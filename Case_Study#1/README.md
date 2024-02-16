# Case-Study-1-Danny-s-Dinner
### By Eray Balkaya
![image](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/de9ac74d-3d0f-4721-988f-956e35d92235)


Danny's Dinner is the first case study of internet's famous 8 WEEK SQL CHALLENGE

The case study information provided has been sourced from [HERE](https://8weeksqlchallenge.com/case-study-1/)

8 weeks challenge is a good way to practice sql especially for beginners.It helps you to improve your skills on EDA (Exploratory Data Analysis).

## Entity Relationship Diagram:

![image](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/d669a397-b40a-457a-b12b-aafa8c6767ff)

There is not much data about Danny's Diner challenge , but the secret here is to be able to find the correct ways to answer the questions.You can examine the tables below.

#### Members table															                              
![members_table](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/8b33cf87-d385-4ca7-9cb5-9cbe89dc31cf)         		  

#### Menu Table
![menu_table](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/e0705263-19b4-4560-ade1-fac113a2b46a)

										
#### Sales table
![sales_table](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/9baa00ca-3d4c-4368-8816-b9021d1b2973)


## Case Study Questions:
1)What is the total amount each customer spent at the restaurant?

2)How many days has each customer visited the restaurant?

3)What was the first item from the menu purchased by each customer?

4)What is the most purchased item on the menu and how many times was it purchased by all customers?

5)Which item was the most popular for each customer?

6)Which item was purchased first by the customer after they became a member?

7)Which item was purchased just before the customer became a member?

8)What is the total items and amount spent for each member before they became a member?

9)If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

10)In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

11)Join All The Things, Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

12)Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

#### Are you ready to see how it's done !!!! ???

## :boom::boom: LET'S ROLL :boom::boom:

#### 1)What is the total amount each customer spent at the restaurant?

```sql

SELECT S.CUSTOMER_ID,
  SUM(M.PRICE)TOTAL_AMOUNT
FROM SALES S
  JOIN MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1;

```

![1](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/fa6663f3-234a-411d-9913-5c048345ad03)


#### 2)How many days has each customer visited the restaurant?

```sql

SELECT CUSTOMER_ID,
  COUNT(DISTINCT ORDER_DATE)
FROM SALES
GROUP BY 1;

```

![2](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/afa77867-9be5-4b0e-8aab-f2e36acaf3f8)


#### 3)What was the first item from the menu purchased by each customer?

##### :⭐ NOTE : I prefer dense_rank() for this question because there are 2 orders in one day and there's no data about order hour or an order_id to show us the ranking.So if there are 2 orders same day i choose to show both of them as first.

```sql

WITH ORDER_LIST AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          S.ORDER_DATE,
          DENSE_RANK() OVER (PARTITION BY S.CUSTOMER_ID ORDER BY S.ORDER_DATE) RANKING
    FROM MENU M
    JOIN SALES S ON M.PRODUCT_ID = S.PRODUCT_ID
    GROUP BY S.CUSTOMER_ID,
            M.PRODUCT_NAME,
            S.ORDER_DATE)
SELECT CUSTOMER_ID,
    PRODUCT_NAME
FROM ORDER_LIST
WHERE RANKING = 1

```
![3](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/48392728-a1de-4308-a42b-bfd0e4eb2350)


#### 4)What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql

SELECT PRODUCT_NAME,
  COUNT(S.PRODUCT_ID)
FROM SALES S
  JOIN MENU M ON M.PRODUCT_ID = S.PRODUCT_ID
GROUP BY 1;

```

![4](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/d7ad04ca-147b-4726-95f9-d7fb4998fba8)


#### 5)Which item was the most popular for each customer?

```sql

WITH MOST_POPS AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          COUNT(S.PRODUCT_ID)TOTAL_SALES,
          RANK () OVER (PARTITION BY S.CUSTOMER_ID ORDER BY COUNT(S.PRODUCT_ID) DESC) AS RANKING
    FROM SALES S
      JOIN MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
    GROUP BY 1,2
    ORDER BY 1,3 DESC)
SELECT CUSTOMER_ID,
       PRODUCT_NAME
FROM MOST_POPS
WHERE RANKING = 1

```
![5](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/eab6a9d9-0388-41ac-9468-6b39c1f914e1)


#### 6)Which item was purchased first by the customer after they became a member?

##### :⭐NOTE : I've included the day customers became member and i found out that their first order in the date they became member because as in question 3 there is no hour data or an order_id to show us which happening is first.  

```sql

WITH FIRST_ORDERS AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          S.ORDER_DATE,
          MEM.JOIN_DATE,
          DENSE_RANK() OVER (PARTITION BY S.CUSTOMER_ID ORDER BY S.ORDER_DATE) RANKING
    FROM SALES S
      JOIN MEMBERS MEM ON S.CUSTOMER_ID = MEM.CUSTOMER_ID
      JOIN MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
    WHERE MEM.JOIN_DATE <= S.ORDER_DATE
    GROUP BY 1,2,3,4
    ORDER BY ORDER_DATE)
SELECT *
FROM FIRST_ORDERS
WHERE RANKING = 1
```
![6](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/50930e73-d017-4695-a088-647b3c3dab7a)


#### 7)Which item was purchased just before the customer became a member?

```sql

WITH FIRST_ORDERS AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          S.ORDER_DATE,
          MEM.JOIN_DATE,
          RANK() OVER (PARTITION BY S.CUSTOMER_ID ORDER BY S.ORDER_DATE DESC) RANKING
    FROM SALES S
      JOIN MEMBERS MEM ON S.CUSTOMER_ID = MEM.CUSTOMER_ID
      JOIN MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
      WHERE S.ORDER_DATE < MEM.JOIN_DATE
      GROUP BY 1,2,3,4
      ORDER BY ORDER_DATE)
SELECT CUSTOMER_ID,
       PRODUCT_NAME
FROM FIRST_ORDERS
WHERE RANKING = 1
```
![7](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/75d80799-10fe-4b6a-9986-b2897b6a8795)


#### 8)What is the total items and amount spent for each member before they became a member?

```sql

WITH FIRST_ORDERS AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          S.ORDER_DATE,
          MEM.JOIN_DATE
    FROM SALES S
      JOIN MEMBERS MEM ON S.CUSTOMER_ID = MEM.CUSTOMER_ID
      JOIN MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
      WHERE MEM.JOIN_DATE > S.ORDER_DATE
      GROUP BY 1,2,3,4
      ORDER BY ORDER_DATE)
SELECT FO.CUSTOMER_ID,
       FO.PRODUCT_NAME,
       ME.PRICE,
       COUNT(FO.PRODUCT_NAME)TOTAL_NUM_ORDER,
       (ME.PRICE * COUNT(FO.PRODUCT_NAME)) CHECK_
FROM FIRST_ORDERS FO
  JOIN MENU ME ON FO.PRODUCT_NAME = ME.PRODUCT_NAME
GROUP BY FO.CUSTOMER_ID,
         FO.PRODUCT_NAME,
	       ME.PRICE
```
![8](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/3f2b66c8-ac72-46eb-88b9-275219205117)


#### 9)If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql

WITH POINT_RANK AS
  (SELECT S.CUSTOMER_ID,
          ME.PRODUCT_NAME,
          COUNT(S.PRODUCT_ID)TOTAL_ORDER,
          (COUNT(S.PRODUCT_ID)) * CASE WHEN ME.PRODUCT_NAME = 'sushi' THEN ME.PRICE * 20
                                       WHEN ME.PRODUCT_NAME = 'curry' THEN ME.PRICE * 10
                                       WHEN ME.PRODUCT_NAME = 'ramen' THEN ME.PRICE * 10
                                       END AS POINTS
    FROM SALES S
      JOIN MENU ME ON S.PRODUCT_ID = ME.PRODUCT_ID
    GROUP BY 1,
			  ME.PRODUCT_NAME,
        ME.PRICE)
SELECT CUSTOMER_ID,
       SUM(POINTS)
FROM POINT_RANK
GROUP BY CUSTOMER_ID
```
![9](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/422fa712-dab9-4d4a-b32e-cc5bc678accc)


#### 10)In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql

WITH POINT_TABLE AS
  (SELECT S.CUSTOMER_ID,
          JOIN_DATE START_DATE,
          JOIN_DATE + 6 END_DATE,
          ORDER_DATE,
          PRODUCT_NAME,
          PRICE,
          CASE
             WHEN ORDER_DATE BETWEEN JOIN_DATE AND JOIN_DATE + 6 THEN PRICE * 2 * 10
             WHEN PRODUCT_NAME = 'sushi' THEN PRICE * 2 * 10
             ELSE PRICE * 10
           END AS POINTS
    FROM SALES S
      JOIN MEMBERS MEM ON MEM.CUSTOMER_ID = S.CUSTOMER_ID
      JOIN MENU M ON M.PRODUCT_ID = S.PRODUCT_ID
    WHERE ORDER_DATE <= '2021-01-31' )
SELECT CUSTOMER_ID,
       SUM(POINTS)
FROM POINT_TABLE
GROUP BY 1

```
![10](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/dafbd861-2bdd-41d7-8465-ec85550a6b36)


#### 11)Join All The Things, Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
```sql

WITH ALL_DATA AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          M.PRICE,
          S.ORDER_DATE,
          MEM.JOIN_DATE,
          CASE
           WHEN S.ORDER_DATE >= MEM.JOIN_DATE THEN 'Member'
           ELSE 'Not Member'
          END MEMBER_STATUS
    FROM MENU M
      JOIN SALES S ON M.PRODUCT_ID = S.PRODUCT_ID
      LEFT JOIN MEMBERS MEM ON S.CUSTOMER_ID = MEM.CUSTOMER_ID)
SELECT *
FROM ALL_DATA;
```
![11](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/7e854cc9-8b7f-4d3e-bab4-cd91d39db042)


#### 12)Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
```sql

WITH ALL_DATA AS
  (SELECT S.CUSTOMER_ID,
          M.PRODUCT_NAME,
          M.PRICE,
          S.ORDER_DATE,
          MEM.JOIN_DATE,
          CASE
            WHEN S.ORDER_DATE >= MEM.JOIN_DATE THEN 'Member'
            ELSE 'Not Member'
          END MEMBER_STATUS
    FROM MENU M
      JOIN SALES S ON M.PRODUCT_ID = S.PRODUCT_ID
      LEFT JOIN MEMBERS MEM ON S.CUSTOMER_ID = MEM.CUSTOMER_ID)
SELECT *,
	CASE
    WHEN MEMBER_STATUS = 'Not Member' THEN NULL
    ELSE DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID,MEMBER_STATUS ORDER BY ORDER_DATE)
  END RANKING
FROM ALL_DATA;
```
![12](https://github.com/ErayBalkaya/Case-Study-1-Danny-s-Diner/assets/159141102/bdf3cf5a-0bbd-4567-9aeb-3adf8596a4dd)


