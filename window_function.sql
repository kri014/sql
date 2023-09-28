SELECT *,
      amount*100/sum(amount) as pct
FROM expenses
ORDER BY category

-- ----------------sum of expenses----------
SELECT sum(amount) FROM expenses # 65800

-- --------------- percantage of the expenses 
SELECT *,
      amount*100/sum(amount) as pct
FROM expenses
ORDER BY category

-- Here we will get only one output we can't get for all the values 
-- To get the values we have to use Window Function
-- -----------------Window Function -----------------------------------------
-- 1. Use OVER() clause 

SELECT *,
      amount*100/sum(amount) OVER() as pct
FROM expenses
ORDER BY category
-- it will give the percentage for all the rows 
-- 2. using partition inside the over()--> it will give the percentage for each category of food
SELECT *,
      amount*100/sum(amount) OVER(partition by category) as pct
FROM expenses
ORDER BY category
--  
SELECT sum(amount) FROM expenses 
WHERE category = 'food'  # 11800


-- cumulative expenses 
SELECT *,
       SUM(amount) OVER (partition by category order by date) as total_expenses
FROM expenses
ORDER BY category,date 

-- ------------------
SELECT 
		  d.customer,
		  round(sum(net_sales)/1000000,2) as sales_in_million,
	FROM net_sales n
	JOIN dim_customer d
	ON d.customer_code=n.customer_code
	where fiscal_year=2020 
	group by d.customer
    ORDER BY sales_in_million DESC
    LIMIT 10
    
 -- get total sum of the  
 WITH cte1 as (
    SELECT 
		  d.customer,
		  round(sum(net_sales)/1000000,2) as sales_in_million
	FROM net_sales n
	JOIN dim_customer d
	ON d.customer_code=n.customer_code
	where fiscal_year=2021 
	group by d.customer
    ORDER BY sales_in_million DESC
 )
 
 
  WITH cte1 as (
    SELECT 
		  d.customer,
          d.region,
		  round(sum(net_sales)/1000000,2) as sales_in_million
	FROM net_sales n
	JOIN dim_customer d
	ON d.customer_code=n.customer_code
	where fiscal_year=2021 
	group by d.customer 
    ORDER BY sales_in_million DESC
 )
 
 SELECT *,
		sales_in_million*100/SUM(sales_in_million) over(partition by region) as total_sales_pct
 FROM cte1
 GROUP BY region
 ORDER BY total_sales_pct DESC


 WITH cte1 as (
    SELECT 
		  d.customer,
          d.region,
		  round(sum(net_sales)/1000000,2) as sales_in_million
	FROM net_sales n
	JOIN dim_customer d
	ON d.customer_code=n.customer_code
	where fiscal_year=2021 
	group by d.customer
    ORDER BY sales_in_million DESC
 )
 SELECT *, sales_in_million*100/sum(sales_in_million) over(partition) as sales_pct
 FROM cte1
 GROUP BY region
 
 
 -- rank(),dense_rank(),row_number()
 # Show top two expenses given category
 SELECT * FROM expenses
 ORDER BY category
 
 -- 
SELECT *, 
      row_number () over(partition by category order by amount DESC) as row_rank 
FROM expenses
ORDER BY category

-- now get the top two rank 
with cte1 as(
SELECT *, 
      row_number () over(partition by category order by amount DESC) as rn 
FROM expenses
ORDER BY category
)
SELECT * FROM cte1
where rn <=2 
-- in output even if food with same amount it gives the wrong output

-- using rank()
SELECT *, 
      row_number () over(partition by category order by amount DESC) as rn,
      rank () over(partition by category order by amount DESC) as rnk 
FROM expenses
ORDER BY category

-- here rank don't have the 3 rank for two same value amount

-- using dense_rank()

SELECT *, 
      row_number () over(partition by category order by amount DESC) as rn,
      rank () over(partition by category order by amount DESC) as rnk,
      dense_rank () over(partition by category order by amount DESC) as drnk
FROM expenses
ORDER BY category

-- this is perfect ranking

-- using for getting top 2 rank

WITH cte1 as (SELECT *, 
      row_number () over(partition by category order by amount DESC) as rn,
      rank () over(partition by category order by amount DESC) as rnk,
      dense_rank () over(partition by category order by amount DESC) as drnk
FROM expenses
ORDER BY category)

SELECT * FROM cte1
WHERE drnk <=2

-- using student_marks table in random_table database
SELECT * FROM student_marks
-- Aaply all the window function ranking method 
 SELECT *,
  row_number () over( order by marks DESC) as rn,
      rank () over(  order by marks DESC) as rnk,
      dense_rank () over( order by marks DESC) as drnk
 FROM student_marks
 -- getting top five students name 
 with cte1 as (SELECT *,
  row_number () over( order by marks DESC) as rn,
      rank () over(  order by marks DESC) as rnk,
      dense_rank () over( order by marks DESC) as drnk
 FROM student_marks
 )
 
SELECT * FROM cte1
WHERE drnk<=5
