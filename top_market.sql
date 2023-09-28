SELECT 
      market,
      round(sum(net_sales)/1000000,2) as sales_in_milloin       
FROM net_sales
where fiscal_year=2021
group by market
order by sales_in_milloin DESC

SELECT 
      d.customer,
      round(sum(net_sales)/1000000,2) as sales_in_milloin       
FROM net_sales n
JOIN dim_customer d
ON d.customer_code=n.customer_code
where fiscal_year=2021
group by d.customer
order by sales_in_milloin DESC
limit 5

SELECT 
      product,
      round(sum(net_sales)/1000000,2) as sales_in_milloin       
FROM net_sales 
where fiscal_year=2021
group by product
order by sales_in_milloin DESC
limit 5


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
