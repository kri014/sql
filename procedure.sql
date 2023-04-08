-- creating Procedure 
DELIMITER && 
CREATE PROCEDURE krish()
BEGIN 
    SELECT * FROM bank_details;
END && 

CALL krish()

-- for max balance 
DELIMITER && 
CREATE PROCEDURE maxmum_bal()
BEGIN 
    SELECT * FROM bank_details ORDER BY balance DESC limit 1;
END && 

CALL maxmum_bal()
-- Dropping the procedure 
DROP PROCEDURE avg_job_rol
SELECT AVG(balance) FROM bank_details WHERE job='admin.'


-- Creating a procedure for average of the balance for provided job role
DELIMITER && 
CREATE PROCEDURE job_rol(IN sudh VARCHAR(30))
BEGIN 
    SELECT AVG(balance) FROM bank_details WHERE job=sudh;
END && 

CALL krish()
CALL job_rol('management');

CALL job_rol('retired')
-- Creating the procedure with multiple variable input
DELIMITER && 
CREATE PROCEDURE sel_edu_job1(IN v1 VARCHAR(30), IN v2 VARCHAR(30))
BEGIN 
    SELECT * FROM bank_details WHERE education =v1 and job = v2;
END && 


CALL sel_edu_job1('primary','admin.')
CALL sel_edu_job1('primary','retired')


-- Creating a view ( a subset of the bank details with column (age, job, marital, balance, education)

CREATE VIEW bank_view1 AS SELECT age, job, marital, balance, education FROM bank_details;
SELECT * FROM bank_view1
SELECT avg(balance) FROM bank_view1 WHERE job='admin.'
