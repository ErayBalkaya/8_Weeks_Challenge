-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id,sum(m.price)total_amount from sales s
join menu m on s.product_id=m.product_id 
group by 1
order by total_amount desc
-- 2. How many days has each customer visited the restaurant?
select customer_id,count(distinct order_date) from sales
group by 1
-- 3. What was the first item from the menu purchased by each customer?
with order_list as
(
select s.customer_id, m.product_name, s.order_date,
DENSE_RANK() OVER (PARTITION BY s.customer_iD Order by s.order_date) ranking
from Menu m
join Sales s
on m.product_id = s.product_id
group by s.customer_id, m.product_name,s.order_date
)
select customer_id, product_name
from order_list
where ranking = 1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all 
--customers?

SELECT product_name,
		count(s.product_id)
from sales s
join menu m on m.product_id = s.product_id
group by 1;


-- 5. Which item was the most popular for each customer?
with most_pops as (select s.customer_id,m.product_name,count(s.product_id)total_sales,
rank () over (partition by s.customer_id order by count(s.product_id) desc) as ranking 
from sales s
join menu m on s.product_id=m.product_id
group by 1,2
order by 1,3 desc)
select customer_id,product_name from most_pops 
where ranking=1

-- 6. Which item was purchased first by the customer after they became a member?
with first_orders as (
select s.customer_id,m.product_name,s.order_date ,mem.join_date,
dense_rank() over (partition by s.customer_id order by s.order_date) ranking
from sales s 
join members mem on s.customer_id=mem.customer_id
join menu m on s.product_id=m.product_id
where mem.join_date<=s.order_date
group by 1,2,3,4
order by order_date)
select *
from first_orders
where ranking=1

-- 7. Which item was purchased just before the customer became a member?
with first_orders as (
select s.customer_id,m.product_name,s.order_date ,mem.join_date,
rank() over (partition by s.customer_id order by s.order_date desc) ranking
from sales s 
join members mem on s.customer_id=mem.customer_id
join menu m on s.product_id=m.product_id
where s.order_date<mem.join_date
group by 1,2,3,4
order by order_date)
select customer_id,product_name
from first_orders
where ranking=1

-- 8. What are the items and amount spent for each member before they became a member?
with first_orders as (
select s.customer_id,m.product_name,s.order_date ,mem.join_date
from sales s 
join members mem on s.customer_id=mem.customer_id
join menu m on s.product_id=m.product_id
where mem.join_date>s.order_date
group by 1,2,3,4
order by order_date)
select fo.customer_id,fo.product_name,me.price,
count(fo.product_name)total_num_order,
(me.price*count(fo.product_name)) check_
from first_orders fo
join menu me on fo.product_name=me.product_name
group by fo.customer_id,fo.product_name,me.price
--Another Answer
--Select S.customer_id,count(S.product_id ) as quantity ,Sum(M.price) as total_sales
--From Sales S
--Join Menu M
--ON m.product_id = s.product_id
--JOIN Members Mem
--ON Mem.Customer_id = S.customer_id
--Where S.order_date < Mem.join_date
--Group by S.customer_id

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier,how many points would each customer have?

with point_rank as (select s.customer_id,me.product_name,count(s.product_id)total_order,
(count(s.product_id))*
case 
when me.product_name='sushi' then me.price*20
when me.product_name='curry' then me.price* 10
when me.product_name='ramen' then me.price*10
end as points
from sales s 
join menu me on s.product_id=me.product_id
group by 1,me.product_name,me.price)
select customer_id,sum(points) from point_rank
group by customer_id

--10. In the first week after a customer joins the program (including their join date) they 
--earn 2x points on all items, not just sushi - how many points do customer A and B have at the 
--end of January?

 
with tablo as(
Select s.customer_id,
		join_date start_date,
		join_date + 6 end_date,
		order_date,		
		product_name,
		price,
		case 
			when order_date BETWEEN join_date and join_date + 6 then price * 2*10
			when product_name = 'sushi' then price * 2* 10
			else price*10
			end as points
from sales s
join members mem on mem.customer_id = s.customer_id
join menu m on m.product_id = s.product_id
WHERE order_date <= '2021-01-31'
)
SELECT customer_id,
		sum(points)
from tablo
group by 1


--11. Join All The Things, Danny also requires further information about the ranking of customer products, but he 
--purposely does not need the ranking for non-member purchases so he expects null ranking values for the records 
--when customers are not yet part of the loyalty program.

with all_data as (
select
s.customer_id,m.product_name,m.price,s.order_date,mem.join_date,
case when s.order_date >= mem.join_date then 'Member'
else 'Not Member'
end  member_status
from menu m
join sales s on m.product_id = s.product_id
left join members mem on s.customer_id = mem.customer_id)
select * from all_data;



--12. Danny also requires further information about the ranking of customer products, but he purposely does not need 
--the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet 
--part of the loyalty program.
with all_data as (
select
s.customer_id,m.product_name,m.price,s.order_date,mem.join_date,
case when s.order_date >= mem.join_date then 'Member'
else 'Not Member'
end  member_status
from menu m
join sales s on m.product_id = s.product_id
left join members mem on s.customer_id = mem.customer_id)

select *,
case when member_status = 'Not Member' then NULL
else
DENSE_RANK() OVER(PARTITION BY customer_id, member_status ORDER BY order_date)
end ranking
from all_data;
