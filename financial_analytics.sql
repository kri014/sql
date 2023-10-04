-- Month
-- Product Name
-- Variant
-- Sold Quantity
-- Gross Price per item 
-- Gross price total

show tables
-- 1. Get the costomer code from croma india
SELECT * FROM dim_customer
WHERE customer like '%croma%' and market= 'india'

-- b. Get all the sales transaction data from fact_sales_monthly 
--    table for that customer(croma: 90002002) in the fiscal_year 2021

-- The following code is based on year basis

SELECT * FROM fact_sales_monthly
WHERE 
    customer_code=90002002 AND
    YEAR(date)=2021
ORDER BY date DESC

-- The follwing code for fical year basic
-- DATE_ADD() function add a time/date interval to a date and then return a date  

 year(DATE_ADD(date, INTERVAL 4 month))
  
SELECT * FROM fact_sales_monthly
WHERE 
    customer_code=90002002 AND
     year(DATE_ADD(date, INTERVAL 4 month))=2021
ORDER BY date DESC


SELECT * FROM fact_sales_monthly
WHERE 
    customer_code=90002002 AND
     get_fiscal_year(date)=2021
ORDER BY date DESC
get_fiscal_quarter

SELECT month('2021-08-01')
# sale for 4th quarter in fiscal year 2021
SELECT * FROM fact_sales_monthly
WHERE 
    customer_code=90002002 AND
     get_fical_year(date)=2021 AND 
     get_fiscal_quarter(date)='Q4'
ORDER BY date DESC

SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity 
	FROM fact_sales_monthly s
	JOIN dim_product p
        ON s.product_code=p.product_code
	WHERE 
            customer_code=90002002 AND 
    	    get_fical_year(date)=2021     
	LIMIT 1000000;


SELECT 
    	    s.date, 
            s.product_code, 
            p.product, 
            p.variant, 
            s.sold_quantity, 
            g.gross_price,
            ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total
	FROM fact_sales_monthly s
	JOIN dim_product p
            ON s.product_code=p.product_code
	JOIN fact_gross_price g
            ON g.fiscal_year=get_fiscal_year(s.date)
    	AND g.product_code=s.product_code
	WHERE 
    	    customer_code=90002002 AND 
            get_fical_year(s.date)=2021     
	LIMIT 1000000;
    
SELECT 
     date,
     product,
     variant,
     sold_quantity,
     p.gross_price,
     ROUND((f.sold_quantity*p.gross_price),2) AS gross_price_total
FROM fact_sales_monthly f
JOIN dim_product d 
ON f.product_code=d.product_code
JOIN fact_gross_price p
ON p.product_code=f.product_code AND 
    p.fiscal_year=get_fiscal_year(f.date)
WHERE f.customer_code=90002002 AND
      get_fiscal_year(date) =2021
ORDER BY date DESC
LIMIT 100000    



/* An aggregate monthly gross sale report for croma India customer so that it can be tracked
How much sale this particular customer is generated for atliq and manage our relationship accordingly
this report should contain the following field
1. month
2. total gross sale amount to croma india in this month */

SELECT * FROM dim_customer
WHERE customer like '%croma%'-- > here we will get the customer code 

SELECT * FROM fact_gross_price

SELECT 
	s.date,
    sum(s.sold_quantity*g.gross_price) as total_gross_price
    FROM fact_sales_monthly s
    join fact_gross_price g
    ON s.product_code=g.product_code and get_fiscal_year(s.date)=g.fiscal_year
	where customer_code = 90002002
GROUP BY date 
ORDER BY date


/*Exercise: Yearly Sales Report
Generate a yearly report for Croma India where there are two columns

1. Fiscal Year
2. Total Gross Sales amount In that year from Croma */

SELECT * FROM dim_customer
WHERE customer like '%croma%'
SELECT * FROM fact_gross_price


SELECT 
    p.fiscal_year, sum(round(p.gross_price*s.sold_quantity,2)) as total_cost_yearly
FROM fact_sales_monthly s
JOIN fact_gross_price  p
ON s.product_code=p.product_code AND 
   p.fiscal_year=get_fiscal_year(s.date)
   
WHERE customer_code=90002002
GROUP BY p.fiscal_year
ORDER BY p.fiscal_year DESC



	select
            get_fiscal_year(date) as fiscal_year,
            sum(round(sold_quantity*g.gross_price,2)) as yearly_sales
	from fact_sales_monthly s
	join fact_gross_price g
	on 
	    g.fiscal_year=get_fiscal_year(s.date) and
	    g.product_code=s.product_code
	where
	    customer_code=90002002
	group by get_fiscal_year(date)
	order by fiscal_year;
		
        
SELECT find_in_set(90002008,'90002008,90002016')



/* Create a stored proc that can determine the market badge based on the following
on the logic
if total sold quantity> 5 millions that market consider as gold else silver
 My inputs will be 
 1. matket
 2. fiscal year
 Output
 1.market badge */

-- India, 2020-->Gold
-- Srilanka, 2020-->Silver

SELECT 
  SUM(s.sold_quantity) as sold_yearly
FROM dim_customer c
JOIN fact_sales_monthly s
ON c.customer_code=s.customer_code
WHERE get_fiscal_year(s.date)=2021 and c.market='India'
GROUP BY c.market