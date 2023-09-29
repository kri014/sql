SELECT * FROM items
SELECT * FROM variants

/* CROSS JOINTS */
SELECT * 
FROM food_db.items
CROSS JOIN food_db.variants

SELECT * , CONCAT(name," " ,variant_name) as full_name
, (price+variant_price) as food_price
FROM food_db.items
CROSS JOIN food_db.variants

USE moviesdb
SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
JOIN financials f
ON m.movie_id= f.movie_id
