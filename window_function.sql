CREATE DATABASE win_fun
USE win_fun
CREATE TABLE ineuron_student(
student_id INT,
student_batch VARCHAR(40),
student_name VARCHAR(40),
student_stream VARCHAR(30),
student_marks int,
student_mail_id VARCHAR(50))

insert into ineuron_student values(100 ,'fsda' , 'saurabh','cs',80,'saurabh@gmail.com'),
(102 ,'fsda' , 'sanket','cs',81,'sanket@gmail.com'),
(103 ,'fsda' , 'shyam','cs',80,'shyam@gmail.com'),
(104 ,'fsda' , 'sanket','cs',82,'sanket@gmail.com'),
(105 ,'fsda' , 'shyam','ME',67,'shyam@gmail.com'),
(106 ,'fsds' , 'ajay','ME',45,'ajay@gmail.com'),
(106 ,'fsds' , 'ajay','ME',78,'ajay@gmail.com'),
(108 ,'fsds' , 'snehal','CI',89,'snehal@gmail.com'),
(109 ,'fsds' , 'manisha','CI',34,'manisha@gmail.com'),
(110 ,'fsds' , 'rakesh','CI',45,'rakesh@gmail.com'),
(111 ,'fsde' , 'anuj','CI',43,'anuj@gmail.com'),
(112 ,'fsde' , 'mohit','EE',67,'mohit@gmail.com'),
(113 ,'fsde' , 'vivek','EE',23,'vivek@gmail.com'),
(114 ,'fsde' , 'gaurav','EE',45,'gaurav@gmail.com'),
(115 ,'fsde' , 'prateek','EE',89,'prateek@gmail.com'),
(116 ,'fsde' , 'mithun','ECE',23,'mithun@gmail.com'),
(117 ,'fsbc' , 'chaitra','ECE',23,'chaitra@gmail.com'),
(118 ,'fsbc' , 'pranay','ECE',45,'pranay@gmail.com'),
(119 ,'fsbc' , 'sandeep','ECE',65,'sandeep@gmail.com')
insert into ineuron_student values(101 ,'fsbc' , 'sandeep','ECE',65,'sandeep@gmail.com')

select * from ineuron_student order by student_id asc
-- saggrigation based analytical question 
select student_batch, min(student_marks) from ineuron_student group by student_batch
select student_batch, max(student_marks) from ineuron_student group by student_batch
select student_batch, avg(student_marks) from ineuron_student group by student_batch
select student_batch, sum(student_marks) from ineuron_student group by student_batch

select count(student_batch) from ineuron_student 

select count(distinct student_batch) from ineuron_student

select student_batch, count(*) from ineuron_student group by student_batch
select * from ineuron_student order by student_id asc

select student_name from ineuron_student 
where student_marks in ( select max(student_marks) from ineuron_student 
                         where student_batch="fsda")

SELECT student_id, student_batch, student_stream, student_marks,row_number() 
over (order by student_marks) as 'row number' 
from ineuron_student


SELECT student_id, student_batch, student_stream, student_marks,row_number() 
over (partition by student_batch order by student_marks desc) as 'row_number1' 
from ineuron_student 

SELECT * FROM (SELECT student_id, student_batch, student_stream, student_marks,row_number() 
over (partition by student_batch order by student_marks desc) as 'row_number1' 
from ineuron_student ) as test where row_number1=1

-- selecting the 1st rank of the student
SELECT * FROM (SELECT student_id, student_batch, student_stream, student_marks,
               row_number() over (partition by student_batch order by student_marks desc) as 'row_number1' ,
                rank() over (partition by student_batch order by student_marks desc) as 'rank_row' 
			  from ineuron_student ) as test
              where rank_row=1
-- dense_rank() and the selection with 2, 3,4 rank in the student marks 
SELECT student_id, student_batch, student_stream, student_marks,
               row_number() over (partition by student_batch order by student_marks desc) as 'row_number1' ,
                rank() over (partition by student_batch order by student_marks desc) as 'rank_row',
                dense_rank() over (partition by student_batch order by student_marks desc) as 'dense_rank'
			  from ineuron_student
-- student with 2nd rank              
SELECT * FROM (SELECT student_id, student_batch, student_stream, student_marks,
               row_number() over (partition by student_batch order by student_marks desc) as 'row_number1' ,
                rank() over (partition by student_batch order by student_marks desc) as 'rank_row',
                dense_rank() over (partition by student_batch order by student_marks desc) as 'dense_rank'
			  from ineuron_student) as test where `dense_rank`= 2
-- student with 3rd rank
SELECT * FROM (SELECT student_id, student_batch, student_stream, student_marks,
               row_number() over (partition by student_batch order by student_marks desc) as 'row_number1' ,
                rank() over (partition by student_batch order by student_marks desc) as 'rank_row',
                dense_rank() over (partition by student_batch order by student_marks desc) as 'dense_rank'
			  from ineuron_student) as test where `dense_rank`= 3
              
-- all student rank
SELECT * FROM (SELECT student_id, student_batch, student_stream, student_marks,
               row_number() over (partition by student_batch order by student_marks desc) as 'row_number1' ,
                rank() over (partition by student_batch order by student_marks desc) as 'rank_row',
                dense_rank() over (partition by student_batch order by student_marks desc) as 'dense_rank'
			  from ineuron_student) as test where `dense_rank` in (1,2,3)