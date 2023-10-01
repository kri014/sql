SELECT * FROM movies
/* Use Subquery*/
/* without Subquery*/
SELECT * FROM movies ORDER BY imdb_rating DESC limit 1

/* with sub query  single value query*/
SELECT * FROM movies 
where imdb_rating=(SELECT max(imdb_rating) FROM movies)

SELECT * FROM movies 
where imdb_rating=(SELECT min(imdb_rating) FROM movies)

# with more than 1 sub query
SELECT * FROM movies 
WHERE imdb_rating IN ( 1.9,9.3)

SELECT * FROM movies 
WHERE imdb_rating IN ((SELECT min(imdb_rating) FROM movies), (SELECT max(imdb_rating) FROM movies))

# SELECT all the actor whose age is in between 70 to 85

SELECT * FROM actors

SELECT name, year(CURDATE())-birth_year as age from actors

SELECT * FROM
 (SELECT name, year(CURDATE())-birth_year as age from actors) as actor_age
 WHERE age >70 and age<85
 
 # ANY function
 # Select any actor working an any of the movie (101,110,121)
 SELECT * FROM movie_actor
 SELECT * FROM actors 
 
 SELECT name FROM actors WHERE actor_id IN (
 SELECT actor_id FROM movie_actor WHERE movie_id IN (101,110,121))
 
 SELECT name FROM actors WHERE actor_id = ANY(
 SELECT actor_id FROM movie_actor WHERE movie_id IN (101,110,121))
 
 # Select all movies whose rating is greater than any movies rating marvel movie
 
 
 SELECT imdb_rating FROM movies WHERE studio ='Marvel studios'
 
 SELECT * FROM movies WHERE imdb_rating = ANY( SELECT imdb_rating FROM movies WHERE studio ='Marvel studios')
 
 SELECT * FROM movies WHERE imdb_rating >
 ( SELECT min(imdb_rating) FROM movies WHERE studio ='Marvel studios')
 
 SELECT * FROM movies WHERE imdb_rating > 
 ANY( SELECT imdb_rating FROM movies WHERE studio ='Marvel studios')
 
 SELECT * FROM movies WHERE imdb_rating >
 SOME ( SELECT imdb_rating FROM movies WHERE studio ='Marvel studios')
 
 SELECT * FROM movies WHERE imdb_rating >
 ALL ( SELECT imdb_rating FROM movies WHERE studio ='Marvel studios')
 
  
 SELECT * FROM movies WHERE imdb_rating >
 ( SELECT max(imdb_rating) FROM movies WHERE studio ='Marvel studios')
 
 
 # Subquery
 # Select actor id, actor name, no of movies they acted
 SELECT actor_id,count(*) AS movie_count from movie_actor 
 GROUP BY actor_id ORDER BY movie_count DESC

EXPLAIN ANALYZE
SELECT a.actor_id, name, count(*) AS movie_count
FROM actors a
JOIN movie_actor ma 
ON a.actor_id= ma.actor_id
GROUP BY a.actor_id
ORDER BY movie_count DESC

EXPLAIN ANALYZE
SELECT 
     actor_id,
     name,
     (SELECT count(*) FROM movie_actor
     WHERE actor_id=actors.actor_id) as movie_count
FROM actors
ORDER BY movie_count DESC

#1. Select all the movies with minimum and maximum release_year.
#   Note that there can be more than one movie in min 
#    and a max year hence output rows can be more than 2

SELECT * FROM movies 
WHERE release_year in ((SELECT max(release_year) from movies),(SELECT min(release_year) from movies))

select * from movies where release_year in (
        (select min(release_year) from movies),
		(select max(release_year) from movies)
	)
    
#2) select all the rows from movies table whose 
#    imdb_rating is higher than the average rating

SELECT * FROM movies 
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM movies) 


##     COMMON TABLE EXPRESSION 

# Get all the actor name whose age in between 70 to 85

SELECT * FROM
 (SELECT name, year(CURDATE())-birth_year as age from actors) as actor_age
 WHERE age >70 and age<85
 
WITH actor_age AS (
SELECT name as actor_name, year(CURDATE())-birth_year as age from actors
)
SELECT actor_name,age
FROM actor_age
WHERE age > 70 AND age < 85

-- Movies that produced 500% profit and their rating was less than average rating for all movies
-- Movies that produced 500% profit
SELECT * FROM financials
SELECT (revenue-budget)/budget *100 as percent from financials
where (revenue-budget)/budget *100 >500

-- their rating was less than average rating for all movies
SELECT * FROM movies
SELECT avg(imdb_rating) FROM movies

SELECT * FROM movies
WHERE imdb_rating < (SELECT avg(imdb_rating) FROM movies)

SELECT x.movie_id,y.title,
      y.imdb_rating,x.perct
FROM (
     SELECT * , 
     (revenue-budget)*100/budget as perct from financials
    ) x
JOIN ( 
      SELECT * FROM movies
      WHERE imdb_rating < (SELECT avg(imdb_rating) FROM movies)
     ) y
ON  x.movie_id=y.movie_id
WHERE perct >500


# CET 
WITH x as(SELECT * , 
     (revenue-budget)*100/budget as perct from financials),
     
     y as( SELECT * FROM movies
      WHERE imdb_rating < (SELECT avg(imdb_rating) FROM movies))
SELECT 
    x.movie_id,x.perct,
    y.title, y.imdb_rating
FROM x
JOIN y
ON x.movie_id=y.movie_id
where perct>=500

# Q1. Select all Hollywood movies released after the year 2000 that 
#   made more than 500 million $ profit or more profit. 

SELECT * FROM movies
SELECT * FROM movies WHERE release_year > 2000 and industry= 'Hollywood'
SELECT * from financials
