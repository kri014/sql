SELECT * FROM dim_product
SELECT * FROM fact_sales_monthly

WITH cte1 AS(
			SELECT 
			   p.division,
			   p.product,
			   sum(s.sold_quantity) as total_qty
			FROM fact_sales_monthly s
			JOIN dim_product p
			   ON s.product_code=p.product_code
			WHERE s.fiscal_year=2021
			GROUP BY p.product),
    cte2 as (SELECT *, 
         dense_rank() OVER(PARTITION BY division ORDER BY total_qty DESC)  as drank
         from cte1)

SELECT * FROM cte2 
where drank<=3



   