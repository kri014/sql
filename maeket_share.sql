With cte1 as(
   SELECT 
		  d.customer,
          d.region,
		  round(sum(net_sales)/1000000,2) as sales_in_million
	FROM net_sales n
	JOIN dim_customer d
	ON d.customer_code=n.customer_code
	where fiscal_year=2021 
	group by d.customer,d.region )
    
    SELECT *, sales_in_million*100/SUM(sales_in_million) OVER(partition by region) as sales_pct
    FROM cte1
    ORDER BY region,sales_in_million dESC