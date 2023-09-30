use moviesdb
SHOW tables
-- -------------------Text Query----------------------------------------------
SELECT * FROM actors
SELECT * FROM movies
# Select title, industry in table 
SELECT title, industry FROM movies WHERE industry='bollywood'

# count() # case sensitive query 
SELECT count(*) FROM movies WHERE industry='bollywood'
SELECT count(*) FROM movies WHERE industry='hollywood'

# distinct()
SELECT DISTINCT industry FROM movies

# Like # wildcard search -(% string %)
SELECT * FROM movies where title like '%THOR%'

# selection of NULL values 
SELECT * FROM movies where studio=''

# 1. Print all movie titles and release year for all Marvel Studios movies.

SELECT * FROM movies

SELECT title, release_year FROM movies WHERE studio='marvel studios'

# 2. Print all movies that have Avenger in their name.
SELECT * FROM movies WHERE title like "%Avenger%"

# 3. Print the year when the movie "The Godfather" was released.
SELECT release_year FROM movies WHERE title= 'The Godfather'

#4. Print all distinct movie studios in the Bollywood industry.
SELECT * FROM movies
SELECT DISTINCT studio FROM movies WHERE industry='bollywood'

-- ------------------- NUMERICAL QUERY -- ----------------------------------
# single condtion operator uses
SELECT * FROM movies WHERE imdb_rating > 9
SELECt * FROM movies WHERE imdb_rating >= 6

# use AND and OR 
SELECT count(*) FROM movies WHERE imdb_rating >=6 AND imdb_rating<=8
# Use BETWEEN
SELECT count(*) FROM movies WHERE imdb_rating BETWEEN 6 AND 8

# IN claues 
SELECT * FROM movies WHERE release_year=2022 OR release_year=2019 OR release_year=2018

SELECT * FROM movies WHERE release_year IN (2022,2019,2018)

# finding Null values in the numerical columns

SELECT 
* 
FROM movies 
WHERE imdb_rating IS NULL

SELECT 
* 
FROM movies 
WHERE imdb_rating IS NOT NULL

# ORDER BY (ASC, DESC)/ using LIMIT/ using OFFSET

SELECT * FROM movies 
WHERE industry ='Bollywood'
ORDER BY imdb_rating DESC

SELECT * FROM movies 
WHERE industry ='Bollywood'
ORDER BY imdb_rating 

SELECT * FROM movies 
WHERE industry ='Bollywood'
ORDER BY imdb_rating DESC
LIMIT 5

SELECT * FROM movies 
WHERE industry ='Bollywood'
ORDER BY imdb_rating DESC
LIMIT 5 OFFSET 1

# 1. Print all movies in the order of their release year (latest first)

SELECT * FROM movies 
ORDER BY release_year DESC

# 2. All movies released in the year 2022
SELECT * FROM movies where release_year=2022

#3. Now all the movies released after 2020
SELECT * FROM movies where release_year> 2020

#4. all movies after year 2020 that has more than 8 rating
SELECT * FROM movies 
WHERE release_year > 2020 AND imdb_rating > 8

#5. select all movies that are by marvel studios and hombale films
SELECT * FROM movies 
WHERE studio IN ('marvel studios','hombale films')

# 6. select all thor movies by their release year
SELECT title,release_year FROM movies 
WHERE title like '%THOR%' ORDER BY release_year DESC

# 7) select all movies that are not from marvel studios

SELECT * FROM movies 
WHERE studio NOT IN ('marvel studios')

SELECT * FROM movies 
WHERE studio !='marvel studios'

-- --------------------- Summary Analytics-----------------------------
# MIN, MAX, AVG, GROUP BY

# count()
SELECT count(*) from movies where industry='bollywood'
# MAX()/MIN()/AVG() / ROUND(expression,no of decimal)
SELECT MAX(imdb_rating) FROM movies WHERE industry='bollywood'

SELECT MIN(imdb_rating) FROM movies WHERE industry='bollywood'

SELECT AVG(imdb_rating) as avg_movie FROM movies WHERE studio='marvel studios'

SELECT ROUND(AVG(imdb_rating),2) as avg_movie 
FROM movies 
WHERE studio='marvel studios'

SELECT MAX(imdb_rating) as max_rating,
       MIN(imdb_rating) as min_rating,
       ROUND(AVG(imdb_rating),2) as avg_rating
FROM movies 
WHERE studio='marvel studios'

#  GROUP BY/ ORDER BY
SELECT industry, count(*) as movie_count
FROM movies 
GROUP BY industry

SELECT studio, count(*) as movie_count
FROM movies 
GROUP BY studio

SELECT studio, count(*) as movie_count
FROM movies 
GROUP BY studio
ORDER BY movie_count DESC

SELECT 
     industry, 
     count(*) as movie_count,
     ROUND(avg(imdb_rating),2) as avg_rating
FROM movies 
GROUP BY industry
ORDER BY movie_count DESC

SELECT 
     studio, 
     count(*) as movie_count,
     ROUND(avg(imdb_rating),2) as avg_rating
FROM movies 
GROUP BY studio
ORDER BY movie_count DESC

# neglecting the empty studio use where (!='') 
SELECT 
     studio, 
     count(*) as movie_count,
     ROUND(avg(imdb_rating),2) as avg_rating
FROM movies
WHERE studio!='' 
GROUP BY studio
ORDER BY movie_count DESC

# 1. How many movies were released between 2015 and 2022
SELECT COUNT(*) as movie_count
FROM movies 
WHERE release_year BETWEEN 2015 and 2022
# 2. Print the max and min movie release year
SELECT MAX(release_year) as max, MIN(release_year) as min
FROM movies 
# 3) print a year and how many 
#     movies were released in that year starting with latest year

SELECT release_year, count(*) as movie_count
FROM movies 
GROUP BY release_year 
HAVING movie_count>2
ORDER BY movie_count DESC

-- ------------------------Calculated Columns ------------------------------------
SELECT * from actors

# calculate the age of the actors
--  1. get birth_year from column from actors table
--  2. use current_year from current_date  
--  3. subtract (current_year-birth_year)
--  4. use order by in descending order

SELECT *, year(CURDATE())-birth_year as age FROM actors
ORDER BY age DESC

# If codition
select * from financials

SELECT *, (revenue-budget) as profit 
FROM financials
# but the crrency and unit is not same in every columns

# IF(condition,True,false) 
SELECT *, 
IF (currency='USD',revenue*77, revenue) AS revenue_inr 
FROM financials


SELECT DISTINCT unit FROM financials

SELECT * from financials

SELECT *,
     CASE
          WHEN unit = 'billions' THEN revenue*1000
          WHEN unit = 'thousand' THEN revenue/1000
          ELSE revenue
     END AS revenue_in_mill
FROM financials 
     
SELECT *,
     CASE
          WHEN unit = 'billions' THEN revenue*1000
          WHEN unit = 'thousand' THEN revenue/1000
          WHEN unit= 'millions' THEN revenue
     END AS revenue_in_mill
FROM financials 
     
# 1. Print profit % for all the movies

SELECT *, ((revenue-budget)/budget)*100 as profit_percent
FROM financials
