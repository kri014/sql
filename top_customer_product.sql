/* 1. Report for top market--> (rank,market,net sales (in millions))
   2. Report for  top products--> (rank,product, net sales)
   3. Report for top customers--> (rank,customer, net sales)
--------------------------------------------------------------   
   Gross Price             : 30$
   Pre-Invoice Deduction   : 2
   --------------------------------------
   = Net Invoice Sales     : 28
   - Post-Invoice Deduction:  3
   --------------------------------------
          = Net Sales      : 25
          
          
          */
-- Step 1. add pre invoice column discounts percentage in the table from fact_pre_invoice_deductions
SELECT 
     f.date,
     product,
     variant,
     sold_quantity,
     p.gross_price,
     ROUND((f.sold_quantity*p.gross_price),2) AS gross_price_total,
     pre.pre_invoice_discount_pct
FROM fact_sales_monthly f
JOIN dim_product d 
ON f.product_code=d.product_code
JOIN fact_gross_price p
ON p.product_code=f.product_code AND 
    p.fiscal_year=get_fiscal_year(f.date)
JOIN fact_pre_invoice_deductions pre
ON pre.customer_code=f.customer_code and pre.fiscal_year=get_fiscal_year(f.date)
WHERE 
      get_fiscal_year(date) =2021
LIMIT 1000000 


# Here the duration time we are getting is much more we have to mininize the code so 
# that the  fetch time 

/* Fetch time - measures how long transferring fetched results take, which has nothing to do with query execution. I would not consider it as sql query debugging/optimization option since fetch time depends on network connection, which itself does not have anything to do with query optimization. 
If fetch time is bottleneck then more likely there's some networking problem.

Note: fetch time may vary on each query execution.

Duration time - is the time that query needs to be executed. 
You should try to minimize it when optimizing performance of sql query.
*/


# To handle this we will create a table for fiscal year importing the data from a 
# date csv with date (yyyy-mm-dd) and the dim_date table created 
 
 
# use join operation with dim_product and the dim_date 

SELECT 
     f.date,
     product,
     variant,
     sold_quantity,
     p.gross_price,
     ROUND((f.sold_quantity*p.gross_price),2) AS gross_price_total,
     pre.pre_invoice_discount_pct
FROM fact_sales_monthly f
JOIN dim_date dt
ON dt.calender_date=f.date 
JOIN dim_product d 
ON f.product_code=d.product_code
JOIN fact_gross_price p
ON p.product_code=f.product_code AND 
    p.fiscal_year=dt.fiscal_year
JOIN fact_pre_invoice_deductions pre
ON pre.customer_code=f.customer_code and pre.fiscal_year=dt.fiscal_year

WHERE 
      dt.fiscal_year =2021
LIMIT 1000000 

# now the time it take is 2.86 sec

# we can also optimize with adding extra column name as in the fact_sales_monthly 
-- use the year and the formula for fiscal_year calculation in the generated to be 
-- ticked

SELECT 
     f.date,
     product,
     variant,
     sold_quantity,
     p.gross_price,
     ROUND((f.sold_quantity*p.gross_price),2) AS gross_price_total,
     pre.pre_invoice_discount_pct
FROM fact_sales_monthly f
JOIN dim_product d 
ON f.product_code=d.product_code
JOIN fact_gross_price p
ON p.product_code=f.product_code AND 
    p.fiscal_year=f.fiscal_year
JOIN fact_pre_invoice_deductions pre
ON pre.customer_code=f.customer_code and pre.fiscal_year=f.fiscal_year

WHERE 
      f.fiscal_year =2021
LIMIT 1000000 


----------------------------------------
-- calculating the net invoice sales 

with cte1 as(
		SELECT 
			 f.date,
			 product,
			 variant,
			 sold_quantity,
			 p.gross_price,
			 ROUND((f.sold_quantity*p.gross_price),2) AS gross_price_total,
			 pre.pre_invoice_discount_pct
		FROM fact_sales_monthly f
		JOIN dim_product d 
		ON f.product_code=d.product_code
		JOIN fact_gross_price p
		ON p.product_code=f.product_code AND 
			p.fiscal_year=f.fiscal_year
		JOIN fact_pre_invoice_deductions pre
		ON pre.customer_code=f.customer_code and pre.fiscal_year=f.fiscal_year

		WHERE 
			  f.fiscal_year =2021
		LIMIT 1000000 )
        
SELECT
		 *,
		 (gross_price_total-(gross_price_total*pre_invoice_discount_pct)) as net_invoice_sale 
FROM cte1
        
        
-- we can create a database view for this pre_invoice_discount_pct 

SELECT 
    	    s.date, 
            s.fiscal_year,
            s.customer_code,
            c.market,
            s.product_code, 
            p.product, 
            p.variant, 
            s.sold_quantity, 
            g.gross_price as gross_price_per_item,
            ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total,
            pre.pre_invoice_discount_pct
	FROM fact_sales_monthly s
	JOIN dim_customer c 
		ON s.customer_code = c.customer_code
	JOIN dim_product p
        	ON s.product_code=p.product_code
	JOIN fact_gross_price g
    		ON g.fiscal_year=s.fiscal_year
    		AND g.product_code=s.product_code
	JOIN fact_pre_invoice_deductions as pre
        	ON pre.customer_code = s.customer_code AND
    		pre.fiscal_year=s.fiscal_year
---------------

SELECT
		 *,
		 (gross_price_total-(gross_price_total*pre_invoice_discount_pct)) as net_invoice_sale 
FROM sales_preinv_discount
---------------------------------------
# getting the post_discount_percent
SELECT
		 *,
         (1-s.pre_invoice_discount_pct)*s.gross_price_total as net_invoice_sale,
         po.discounts_pct + po.other_deductions_pct as post_invoice_discount_pct
FROM sales_preinv_discount s
JOIN fact_post_invoice_deductions po
ON s.date=po.date and 
   s.product_code=po.product_code and 
   s.customer_code = po.customer_code
          
          
------------------------------------------------------------------

# creating a view for post_incvoice_discount pct 
CREATE VIEW `sales_postinv_discount` AS
	SELECT 
    	    s.date, s.fiscal_year,
            s.customer_code, s.market,
            s.product_code, s.product, s.variant,
            s.sold_quantity, s.gross_price_total,
            s.pre_invoice_discount_pct,
            (s.gross_price_total-s.pre_invoice_discount_pct*s.gross_price_total) as net_invoice_sales,
            (po.discounts_pct+po.other_deductions_pct) as post_invoice_discount_pct
	FROM sales_preinv_discount s
	JOIN fact_post_invoice_deductions po
		ON po.customer_code = s.customer_code AND
   		po.product_code = s.product_code AND
   		po.date = s.date;
------------------------------------------
SELECT *,
       (1-post_invoice_discount_pct)*net_invoice_sales as net_sales
FROM gdb0041.sales_postinv_discount;

SELECT * FROM gdb0041.net_sales;
