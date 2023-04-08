use sales
select * from sales2
-- Defining the funcion to add 10 
DELIMITER $$ 
CREATE FUNCTION add_to_col(a int)
RETURNS INT
deterministic
BEGIN
    DECLARE b INT;
    SET b = a+10;
    RETURN b;
END $$

-- Calling the function
select add_to_col(15)

SELECT * FROM sales2

SELECT quantity, add_to_col(quantity) from sales2

SELECT * FROM sales2

DELIMITER $$ 
CREATE FUNCTION final_profits(profit int, discount int)
RETURNS INT
deterministic
BEGIN
    DECLARE final_profit INT;
    SET final_profit = profit- discount ;
    RETURN final_profit;
END $$

SELECT profit, discount, final_profits(profit,discount) from sales2

DELIMITER $$ 
CREATE FUNCTION final_profit_real(profit decimal (20,6), discount decimal (20,6), sales decimal (20,6))
RETURNS INT
deterministic
BEGIN
    DECLARE final_profit INT;
    SET final_profit = profit- sales*discount ;
    RETURN final_profit;
END $$
SELECT profit, discount, sales,final_profit_real(profit,discount,sales) from sales2
-- integer to string function

DELIMITER $$ 
CREATE FUNCTION int_to_str(a int)
RETURNS varchar(30)
deterministic
BEGIN
    DECLARE b varchar(30);
    SET b=a ;
    RETURN b;
END $$

select int_to_str(20)


-- if inside the function



DELIMITER &&
create function mark_sales2(sales int ) 
returns varchar(30)
DETERMINISTIC
begin 
declare flag_sales varchar(30); 
if sales  <= 100  then 
	set flag_sales = "super affordable product" ;
elseif sales > 100 and sales < 300 then 
	set flag_sales = "affordable" ;
elseif sales >300 and sales < 600 then 
	set flag_sales = "moderate price" ;
else 
	set flag_sales = "expensive" ;
end if ;
return flag_sales;
end &&

select sales, mark_sales2(sales) from sales2

create table loop_table(val int)
Delimiter $$
create procedure insert_data()
Begin
set @var  = 10 ;
generate_data : loop
insert into loop_table values (@var);
set @var = @var + 1  ;
if @var  = 100 then 
	leave generate_data;
end if ;
end loop generate_data;
End $$

select * from loop_table
call insert_data()