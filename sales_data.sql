CREATE DATABASE sales
USE   sales
CREATE TABLE sales2 (
	order_id VARCHAR(15) NOT NULL, 
	order_date VARCHAR(15) NOT NULL, 
	ship_date VARCHAR(15) NOT NULL, 
	ship_mode VARCHAR(14) NOT NULL, 
	customer_name VARCHAR(22) NOT NULL, 
	segment VARCHAR(11) NOT NULL, 
	state VARCHAR(36) NOT NULL, 
	country VARCHAR(32) NOT NULL, 
	market VARCHAR(6) NOT NULL, 
	region VARCHAR(14) NOT NULL, 
	product_id VARCHAR(16) NOT NULL, 
	category VARCHAR(15) NOT NULL, 
	sub_category VARCHAR(11) NOT NULL, 
	product_name VARCHAR(127) NOT NULL, 
	sales DECIMAL(38, 0) NOT NULL, 
	quantity DECIMAL(38, 0) NOT NULL, 
	discount DECIMAL(38, 3) NOT NULL, 
	profit DECIMAL(38, 5) NOT NULL, 
	shipping_cost DECIMAL(38, 2) NOT NULL, 
	order_priority VARCHAR(8) NOT NULL, 
	`year` DECIMAL(38, 0) NOT NULL
);
set session sql_mode='' 
LOAD DATA INFILE 
'F:/sales_data_final.csv'
INTO TABLE sales2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

select * from sales2


SELECT order_date FROM sales2
select str_to_date(order_date,'%m/%d/%y') from sales2

ALTER TABLE sales2
ADD COLUMN order_date_new DATE AFTER order_date

-- updating the data in the order_date_new column 
UPDATE sales2
SET order_date_new = str_to_date (order_date,'%m/%d/%Y')

SET SQL_SAFE_UPDATES=0;
ALTER TABLE sales2
ADD COLUMN ship_date_new DATE AFTER ship_date



UPDATE sales2
SET ship_date_new = str_to_date (ship_date,'%m/%d/%Y')
select * from sales2

SELECT * FROM sales2 WHERE ship_date_new = '2011-01-05'
SELECT * FROM sales2 WHERE ship_date_new > '2011-01-05'
SELECT * FROM sales2 WHERE ship_date_new < '2011-01-05'

select now()
SELECT count(*) FROM sales2 WHERE ship_date_new BETWEEN '2011-01-05' and '2011-01-08'
select curdate()

ALTER TABLE sales2	
ADD COLUMN flag  date AFTER order_id 
update sales2 
set flag = now()

select * from sales2
update sales2 
set year1 = 

ALTER TABLE sales2	
drop COLUMN `year1`

ALTER TABLE sales2
modify column `year` datetime
select * from sales2
select dayname(order_date_new) from  sales2

alter table sales2
add column Year_New int;

alter table sales2
add column Month_New int;

alter table sales2
add column Day_New int;
select * from sales2 limit 5
select year_new, avg(sales) as sale_year from sales2 group by year_new

select year_new, sum(sales)  from sales2 group by year_new
select year_new, (sales) as sale_year from sales2 group by year_new

update sales2 set Month_new= month(order_date_new)
update sales2 set day_new= day(order_date_new);
update sales2 set year_new= year(order_date_new);

select year_new, max(sales) as sale_year from sales2 group by year_new
select * from sales2 limit 5
select year_new , sum(quantity) from sales2 group by year_new

select (sales*discount+shipping_cost) as ctc from sales2 

select order_id, discount, if( discount>0 ,'yes','no') as discount_flag from sales2 

select order_id, discount, if( discount>0 ,'yes','no') as discount_flag from sales2 

alter table sales2
add column discount_flag varchar(20) after discount;
update sales2 
set discount_flag = if( discount>0 ,'yes','no') 
select * from sales2 limit 5
select discount_flag, count(*) from sales2 group by discount_flag