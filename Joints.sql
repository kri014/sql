USE  moviesdb
SHOW TABLES
financials SELECT * FROM movies
select * FROM actors

/* JOINTS */
SELECT movies.movie_id,title,budget,revenue,currency,unit
FROM movies 
JOIN financials
ON movies.movie_id= financials.movie_id

/* alising the movies and financials */
SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
JOIN financials f
ON m.movie_id= f.movie_id

/* By default the joints are  inner joints */
SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
INNER JOIN financials f
ON m.movie_id= f.movie_id

/* left joints- It will select all the data from the movies table discarding not matched column from finanacial */
SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
LEFT JOIN financials f
ON m.movie_id= f.movie_id

/* Right joints- It will select all the data from the Financial table discarding not matched column from Movies */
SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
RIGHT JOIN financials f
ON m.movie_id= f.movie_id

SELECT f.movie_id,title,budget,revenue,currency,unit
FROM movies  m
RIGHT JOIN financials f
ON m.movie_id= f.movie_id

/* FULL JOINTS - Here we will use UNION of RIGHT JOINTS and LEFT JOINTS to get the full joints */
SELECT f.movie_id,title,budget,revenue,currency,unit
FROM movies  m
RIGHT JOIN financials f
ON m.movie_id= f.movie_id

UNION 

SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
LEFT JOIN financials f
ON m.movie_id= f.movie_id

/* USING clause is using for better codeing */
SELECT movie_id,title,budget,revenue,currency,unit
FROM movies  m
LEFT JOIN financials f
USING (movie_id) /* Here moives_id for both table are same we can use only one time*/

SELECT movie_id,title,budget,revenue,currency,unit
FROM movies  m
LEFT JOIN financials f
USING (movie_id, mide) /* Here the movie_id and mid is the differnt differnt table connection column*/

SELECT m.movie_id,title,budget,revenue,currency,unit
FROM movies  m
LEFT JOIN financials f
ON m.movie_id= f.movie_id AND m.col1=f.col2 /* Joins based on the another two columns too */

/*------------------------QUESTION FOR PRACTICE------------------------------------------------------*/
/* 1. Show all the movies with their language names */
SELECT * FROM movies
SELECT * FROM languages

SELECT title, `name` 
FROM movies m
JOIN languages l
ON m.language_id=l.language_id 

/* 2. Show all Telugu movie names (assuming you don't know the language id for Telugu) */
SELECT title, `name` 
FROM movies m
JOIN languages l
ON m.language_id=l.language_id 
WHERE `name`='Telugu'

/* 3. Show the language and number of movies released in that language*/ 
SELECT * FROM movies
SELECT * FROM languages

SELECT `name`, count(*) as no_of_movies 
FROM movies m
JOIN languages l 
ON m.language_id=l.language_id 
GROUP BY `name`
ORDER BY no_of_movies DESC

SELECT `name`, count(*) as no_of_movies 
FROM movies m
JOIN languages l 
USING (language_id)
GROUP BY `name`
ORDER BY no_of_movies DESC
/*--------------------------------------------------- solved question_--------------------------------*/
1) Show all the movies with their language names

   SELECT m.title, l.name FROM movies m 
   JOIN languages l USING (language_id)
/*2) Show all Telugu movie names (assuming you don't know language
id for Telugu)*/
  
   SELECT title	FROM movies m 
   LEFT JOIN languages l 
   ON m.language_id=l.language_id
   WHERE l.name="Telugu"

/*3) Show language and number of movies released in that language*/
   	SELECT 
            l.name, 
            COUNT(m.movie_id) as no_movies
	FROM languages l
	LEFT JOIN movies m USING (language_id)        
	GROUP BY language_id
	ORDER BY no_movies DESC;
