**Introduction**

The focus is on building an employee performance mapping solution for a data science startup. 
We will use SQL to accurately map employees and track their performance.

**Situation**

ScienceQtech is a startup that works in the Data Science field. ScienceQtech has worked on fraud detection, market basket, self-driving cars, supply chain, algorithmic early detection of lung cancer, customer sentiment, and the drug 
discovery field. With the annual appraisal cycle around the corner, the HR department has asked you (Junior Database Administrator) to generate reports on employee details, their performance, and on the project that the employees have 
undertaken, to analyze the employee database and extract specific data based on different requirements.

**Task**

To facilitate a better understanding, managers have provided ratings for each 
employee which will help the HR department to finalize the employee performance 
mapping. As a DBA, you should find the maximum salary of the employees and 
ensure that all jobs meet the organization's profile standard. You also need to 
calculate bonuses to find extra costs for expenses. 
This will improve the overall 
performance of the organization by ensuring that all required employees receive 
training.

<img width="624" height="281" alt="image" src="https://github.com/user-attachments/assets/4be7aedc-28f1-4b1f-9f5e-2a0d74d9d1fc" />

Q3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
Query:
<pre>
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
from emp_record_table;
</pre>

Q4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
1. less than two 
2. greater than four 
3. between two and four
Query:
<pre>
-- 1. less than two 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE   EMP_RATING < 2;
-- 2. greater than four 
Query:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE   EMP_RATING < 4;
-- 3. between two and four
Query:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE   EMP_RATING BETWEEN 2 AND 4;
</pre>

Q5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
Query:
<pre>
select concat(FIRST_NAME, " ",LAST_NAME) as NAME
from emp_record_table
where DEPT = 'FINANCE';
</pre>

Q6. Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
Query:
<pre>
select MANAGER_ID, count(*) As reporters 
from emp_record_table
where MANAGER_ID is not null
group by MANAGER_ID;
</pre>

Q7. Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
Query:
<pre>
select * from emp_record_table
where DEPT = 'FINANCE'
union
select * from emp_record_table
where DEPT = 'HEALTHCARE';
</pre>
  
Q8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
Query:
<pre>
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING, max(EMP_RATING) over (partition by DEPT) as MaxRating
FROM emp_record_table;
</pre>
  
Q9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
<pre>
-- For Maximum salary

-- Query:
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING, max(SALARY) over (partition by DEPT) as MaxSalary
FROM emp_record_table;
-- For Minimum Salary
-- Query:
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING, min(SALARY) over (partition by DEPT) as MinSalary
FROM emp_record_table;
</pre>
  
Q.10 Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
Query:
<pre>
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT,EXP, dense_rank() over (order by EXP DESC ) As ExpRank
from emp_record_table;
</pre>
  
Q.11 Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
<pre>
-- For creating view
-- Query:
create view Above6000 as
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT,EXP, COUNTRY,SALARY
from emp_record_table
where SALARY > 6000;
-- For displaying the view
-- Query:
select * from Above6000;
</pre>
  
Q.12 Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
Query:
<pre>
select * 
from emp_record_table
where EXP in (select EXP from emp_record_table where EXP > 10 );
</pre>
  
Q.13 Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
<pre>
-- For creating Stored Procedure,
-- Query:
delimiter //
Create procedure experience(In Years INT)
begin
select * 
from emp_record_table
where EXP > Years;
end //
Delimiter ;
-- For calling the Procedure,
-- Query:
call experience(3);
</pre> 
  
Q.14 Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard. 
The standard being: 
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST', 
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST', 
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST', 
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST', 
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
<pre>
-- For creating function
-- Query:
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

-- For Using Function
-- Query:
-- Using Function
select EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE, CheckProfile(1,'JUNIOR DATA SCIENTIST') as Profile_check
from data_science_team;
</pre>
      
Q.15 Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
<pre>
-- For checking the Exceution Plan,
-- Query:
  
Explain select * 
from emp_record_table 
where FIRST_NAME = "ERIC";
  
--For creating Index,
-- Query:
  
create index  idx_first_name on emp_record_table(FIRST_NAME(50));
  
-- For checking the Execution Plan after creating index,
-- Query:
  
Explain select * 
from emp_record_table 
where FIRST_NAME = "ERIC";
</pre>

Q.16 Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
Query:
<pre>
select EMP_ID, EMP_RATING, SALARY, (0.05 * SALARY * EMP_RATING) as bonus
from emp_record_table ;
</pre>
  
Q.17 Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
Query:
<pre>
select CONTINENT, COUNTRY, round(Avg(Salary),2) as AvgSalary
from emp_record_table 
group by CONTINENT, COUNTRY
order by CONTINENT, AvgSalary DESC;
</pre>
