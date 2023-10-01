USE moviesdb
SHOW TABLES

-- Select a movie with highest imdb_rating
SELECT * FROM movies

SELECT * FROM movies 
ORDER BY imdb_rating DESC 
LIMIT 1
-- -------------------Subquery with single value -----------------------------
SELECT * FROM movies
WHERE imdb_rating=9.3

SELECT MAX(imdb_rating) FROM movies 
-- we can get the 9.3 from this code 


SELECT * FROM movies 
WHERE imdb_rating= (SELECT MAX(imdb_rating) FROM movies) 
-- using the query for 9.3 as subquery
-- here the subquery return only one values 

-- Write a query for both maximum and minimum rating movie
SELECT MAX(imdb_rating) FROM movies
SELECT MIN(imdb_rating) FROM movies


SELECT * FROM movies 
WHERE imdb_rating IN (9.3,1.9)


-- using subquery to get the value for max and min rating 


-- -------------------------Subquery With list of values------------------
SELECT * FROM movies 
WHERE imdb_rating 
IN ((SELECT MAX(imdb_rating) FROM movies),(SELECT MIN(imdb_rating) FROM movies))

-- Select 
SELECT * FROM actors
-- ----------------------Subquery with a table ---------------------------------
SELECT name, (YEAR(CURDATE())-birth_year) as age
FROM actors
WHERE age > 60 # Here where will not work as age is derived 
ORDER BY age DESC

SELECT * FROM (
            SELECT name, 
            (YEAR(CURDATE())-birth_year) as age 
            FROM actors) as actor_age 
where age>70 and age<85


-- ----------------------------using ANY() -----------------------------------

# Select the actor who is acted in these movies(101,110,112)
SELECT * from movies
SELECT * from actors
SELECT * FROM movie_actor 

SELECT actor_id from movie_actor 
WHERE movie_id IN (101,110,121)

SELECT * FROM actors 
WHERE actor_id IN (SELECT actor_id from movie_actor 
WHERE movie_id IN (101,110,121))

-- Use ANY() with respect to IN

SELECT * FROM actors 
WHERE actor_id = ANY (SELECT actor_id from movie_actor 
WHERE movie_id IN (101,110,121))

# select all the movies which is having movie rating greater than 'marvel studio' rating

SELECT * FROM movies

SELECT imdb_rating FROM movies 
WHERE studio='marvel studios' 

SELECT * FROM movies where imdb_rating = ANY(SELECT imdb_rating FROM movies 
WHERE studio='Marvel Studios')

SELECT * FROM movies where imdb_rating > (SELECT MIN(imdb_rating) FROM movies 
WHERE studio='Marvel Studios' )

SELECT * FROM movies where imdb_rating > ANY(SELECT imdb_rating FROM movies 
WHERE studio='marvel studios' )

SELECT * FROM movies where imdb_rating > some(SELECT imdb_rating FROM movies 
WHERE studio='marvel studios' )
-- ---------------------------Co-Related Query---------------------------------
SELECT * from actors
SELECT * from movie_actor
# Select the actor_id,actor name and total number of movies they acted
SELECT actor_id,count(*) AS movie_count
FROM movie_actor
GROUP BY actor_id
ORDER BY movie_count DESC 

EXPLAIN ANALYZE
SELECT a.actor_id,name,count(*) AS movie_count
FROM movie_actor ma
JOIN actors a
ON a.actor_id=ma.actor_id
GROUP BY a.actor_id
ORDER BY movie_count DESC 

EXPLAIN ANALYZE
SELECT 
     actor_id,
     name,
     (SELECT count(*) FROM movie_actor where actor_id=actors.actor_id) AS movie_count
FROM actors
ORDER BY movie_count DESC
-- Here the subquery having query from the differnt table and which is 


SELECT count(*) FROM movie_actor where actor_id=51


/* 1. Select all the movies with minimum and maximum release_year. Note that there
can be more than one movie in min and a max year hence output rows can be more than 2 */

SELECT * FROM movies
WHERE release_year IN ((SELECT max(release_year) FROM movies), (SELECT MIN(release_year) FROM movies))
ORDER BY release_year DESC

# 2. Select all the rows from the movies table whose imdb_rating 
#  is higher than the average rating

SELECT AVG(imdb_rating) from movies

SELECT * FROM movies 
WHERE imdb_rating > (SELECT AVG(imdb_rating) from movies)
ORDER BY imdb_rating DESC


-- -----------------------Common Table Expression-------------------------------------
SELECT * FROM (
            SELECT name, 
            (YEAR(CURDATE())-birth_year) as age 
            FROM actors) as actor_age 
where age>70 and age<85

select * FRom actors
WITH actor_age AS (
	    SELECT 
               name as actor_name,
              (YEAR(CURDATE())-birth_year) as age
		FROM actors
)
SELECT actor_name, age
FROM actor_age
WHERE age >70 AND age<85
ORDER BY age DESC;


WITH actor_age (actor_name,age) AS (
	    SELECT 
               name,
              (YEAR(CURDATE())-birth_year)
		FROM actors
)
SELECT actor_name, age
FROM actor_age
WHERE age >70 AND age<85
ORDER BY age DESC;

WITH actor_age (actor_name,age) AS (
	    SELECT 
               name as x,
              (YEAR(CURDATE())-birth_year) as y
		FROM actors
)
SELECT actor_name, age
FROM actor_age
WHERE age >70 AND age<85
ORDER BY age DESC;

-- Select the movies which are having greater than 500% profit and there rating is less 
-- than the average rating of movies

# Select the movies which are having greater than 500% profit 
SELECT * FROM financials 

SELECT *, (revenue-budget)*100/budget as profit_pct
FROM financials 
WHERE (revenue-budget)*100/budget > 500

-- rating is less than the average rating of movies
SELECT * FROM movies
WHERE imdb_rating < (SELECT AVG(imdb_rating) FROM movies) 

SELECT * FROM () x
JOIN () y

SELECT x.movie_id,x.profit_pct,
       y.title,y.studio 
	FROM (
          SELECT *, (revenue-budget)*100/budget as profit_pct
		  FROM financials 
          ) x
JOIN (
     SELECT * FROM movies
	 WHERE imdb_rating < (SELECT AVG(imdb_rating) FROM movies)) y
     
ON x.movie_id= y.movie_id
where profit_pct>500


WITH 
    x AS (SELECT *, (revenue-budget)*100/budget as profit_pct
		  FROM financials ),
    y AS (SELECT * FROM movies
	 WHERE imdb_rating < (SELECT AVG(imdb_rating) FROM movies))
SELECT 
     x.movie_id,x.profit_pct,y.title,y.imdb_rating 
FROM x
JOIN Y 
ON x.movie_id=y.movie_id 
WHERE profit_pct>=500
ORDER BY profit_pct DESC ;  



/*1. Select all Hollywood movies released after the year 2000 
that made more than 500 million $ profit or more profit. 
Note that all Hollywood movies have millions as a unit hence 
you don't need to do the unit conversion. 
Also, you can write this query without CTE as well but you 
should try to write this using CTE only. */

# Select all Hollywood movies released after the year 2000--> from movies table
SELECT * from movies 
WHERE release_year > 2000 and industry= 'hollywood'

# movies with 500 million $ profit or more profit ---> From financials table
SELECT * ,
     CASE 
         WHEN unit='billions' then (revenue-budget)*1000
         WHEN unit='Thousands' then (revenue-budget)/1000
		 WHEN unit= 'millions' then revenue-budget
	END AS profit_in_millions
FROM financials 

WITH 
   X as (SELECT 
          * 
		from movies 
		WHERE release_year > 2000 and industry= 'hollywood'),
        
   y as (SELECT * ,
     CASE 
         WHEN unit='billions' then (revenue-budget)*1000
         WHEN unit='Thousands' then (revenue-budget)/1000
		 WHEN unit= 'millions' then revenue-budget
	END AS profit_in_millions
    FROM financials 
       )
SELECT 
      x.movie_id, x.title,x.industry,
      y.profit_in_millions
FROM x
JOIN y 
ON x.movie_id=y.movie_id
WHERE profit_in_millions > 500
ORDER BY profit_in_millions DESC




WITH cte as 
       (
       SELECT m.movie_id,m.title,(revenue-budget) as profit
       FROM movies m
       JOIN financials f
       ON m.movie_id=f.movie_id
       WHERE m.release_year > 2000 and m.industry= 'hollywood'
	   )
       
SELECT * FROM cte 
WHERE profit > 500


