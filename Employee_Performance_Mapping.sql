use employee_performance_mapping;
select * from data_science_team;
select * from emp_record_table;
select * from proj_table;

-- #Q1 Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department. 
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
from emp_record_table;

-- #2 Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
-- DEPARTMENT, and EMP_RATING if the EMP_RATING is:  
 -- less than two 
-- greater than four  
-- between two and four 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING = 5;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE   EMP_RATING < 2;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE   EMP_RATING < 4;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE   EMP_RATING BETWEEN 2 AND 4;

-- #Q3 Write a query to concatenate the FIRST_NAME and the LAST_NAME of 
-- employees in the Finance department from the employee table and then give 
-- the resultant column alias as NAME. 
select concat(FIRST_NAME, " ",LAST_NAME) as NAME
from emp_record_table
where DEPT = 'FINANCE';

-- #Q4 Write a query to list only those employees who have someone reporting to 
-- them. Also, show the number of reporters (including the President). 
select MANAGER_ID, count(*) As reporters 
from emp_record_table
where MANAGER_ID is not null
group by MANAGER_ID;

-- #Q5 Write a query to list down all the employees from the healthcare and finance 
-- departments using union. Take data from the employee record table. 
select * from emp_record_table
where DEPT = 'FINANCE'
union
select * from emp_record_table
where DEPT = 'HEALTHCARE';

-- #Q6 Write a query to list down employee details such as EMP_ID, FIRST_NAME, 
-- LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also 
-- include the respective employee rating along with the max emp rating for the department.
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING, max(EMP_RATING) over (partition by DEPT) as MaxRating
FROM emp_record_table;

-- #Q7 Write a query to calculate the minimum and the maximum salary of the 
-- employees in each role. Take data from the employee record table.
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING, max(SALARY) over (partition by DEPT) as MaxSalary
FROM emp_record_table;

select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING, min(SALARY) over (partition by DEPT) as MinSalary
FROM emp_record_table;

-- #Q8 Write a query to assign ranks to each employee based on their experience. 
-- Take data from the employee record table.
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT,EXP, dense_rank() over (order by EXP DESC ) As ExpRank
from emp_record_table;

-- #Q9 Write a query to create a view that displays employees in various countries 
-- whose salary is more than six thousand. Take data from the employee record table. 
create view Above6000 as
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT,EXP, COUNTRY,SALARY
from emp_record_table
where SALARY > 6000;

select * from Above6000;

-- #Q10 Write a nested query to find employees with experience of more than ten 
-- years. Take data from the employee record table.
select * 
from emp_record_table
where EXP in (select EXP from emp_record_table where EXP > 10 );

-- #Q11 Write a query to create a stored procedure to retrieve the details of the 
-- employees whose experience is more than three years. Take data from the 
-- employee record table.
delimiter //
Create procedure experience(In Years INT)
begin
select * 
from emp_record_table
where EXP > Years;
end //
Delimiter ;

call experience(3);

-- #Q12Write a query using stored functions in the project table to check whether 
-- the job profile assigned to each employee
 -- in the data science team matches 
-- the organization’s set standard. 
-- The standard being: 
-- For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST', 
-- For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST', 
-- For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST', 
-- For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST', 
-- For an employee with the experience of 12 to 16 years assign 'MANAGER'. 

-- Creating Function
Delimiter //
create function CheckProfile(Exp_years INT, Assigned_Profile Varchar(50))
returns Varchar(100)
deterministic
begin
  declare standard_profile varchar(50);
  
  IF exp_years <= 2 THEN
        SET standard_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp_years > 2 AND exp_years <= 5 THEN
        SET standard_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp_years > 5 AND exp_years <= 10 THEN
        SET standard_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF exp_years > 10 AND exp_years <= 12 THEN
        SET standard_profile = 'LEAD DATA SCIENTIST';
    ELSEIF exp_years > 12 AND exp_years <= 16 THEN
        SET standard_profile = 'MANAGER';
    ELSE
        SET standard_profile = 'UNDEFINED PROFILE';
    END IF;

    IF assigned_profile = standard_profile THEN
        RETURN 'MATCH';
    ELSE
        RETURN CONCAT('MISMATCH: Expected ', standard_profile);
    END IF;

end //

Delimiter ;

-- Using Function
select EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE, CheckProfile(1,'JUNIOR DATA SCIENTIST') as Profile_check
from data_science_team;

-- #Q13  Create an index to improve the cost and performance of the query to find 
-- the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan

-- checking the execution plan
Explain select * 
from emp_record_table 
where FIRST_NAME = "ERIC";

-- creating Index
create index  idx_first_name on emp_record_table(FIRST_NAME(50));

-- Checking the execution plan after creating index
Explain select * 
from emp_record_table 
where FIRST_NAME = "ERIC";

-- #Q14 Write a query to calculate the bonus for all the employees, based on their 
-- ratings and salaries (Use the formula: 5% of salary * employee rating)

select EMP_ID, EMP_RATING, SALARY, (0.05 * SALARY * EMP_RATING) as bonus
from emp_record_table ;

-- #Q15 Write a query to calculate the average salary distribution based on the 
-- continent and country. Take data from the employee record table.
select CONTINENT, COUNTRY, round(Avg(Salary),2) as AvgSalary
from emp_record_table 
group by CONTINENT, COUNTRY
order by CONTINENT, AvgSalary DESC;
