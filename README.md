# Pewlett-Hackard-Analysis

## Background of problem
PH wants to analyze their employee data to plan for employees who are retiring, new employees that need mentoring, and identify areas for better data gathering and structure to improve their business. For this project, I reviewed data that PH has in multiple files and created a postgres database that makes it easier to query and anayze data.

## Part_1
To start this analysis, I created an entity relationship diagram (ERD), as shwn below, to visualize the various csv files that PH provided. This involved a review of the fields in each file, determining commonality, and creating a schema that described the relationships between the csv files. (You can find the schma from which the ERD is derived at: https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/Challenge_files/EmployeeDB_QuickDBD_schema.txt)

  ![](https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/Challenge_files/EmployeeDB%20ERD.png)  
    
    
## Part_2
Based on this ERD, I created a database and wrote several SQL queries to create tables to understand the data. With the csv files provided, the first step was to create six tables: Department, Employees, Dept Managers, Salaries, Dept Employees and Titles. A copy of the full sql queries file is at: https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/queries.sql
  
PH management wanted to specifically analyze and create two tables that they presented as challenges : (i) Table_1: Number of Retiring Employees by Title; and (ii) Table_2: Mentorship Eligibility.
  
#### Table_1: Number of Retiring Employees by Title
PH wanted to create a table that showed the following:  
- Employee number
- First and last name
- Title
- from_date
- Salary

This involved two join operations, ie. combining two tables. The first join was retirement_info and the titles to create new table, an the second was to join the new table with employees table with salary data. Finally, I applied a select distinct operation to eliminate duplicate rows that resulted form the join operations. Note that the code is also included in the sql queries file referenced earlier.  
  
Challenge Table_1 Number of Retiring Employees by Title. A csv file of the output table is at: https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/Challenge_files/Challenge_Retiring_Employees.csv  

  
#### Table_2: Mentorship Eligibility
Due to high anticipated staff turnover, PH wanted to create a table that showed a list of employees that they may want to mentor. To address this issue, I created a table with following information:
- Employee number
- First and last name
- Title
- from_date and to_date

To do this, I joined the employees and titles tables to create new list, and used this new list to include only the desired columns. I noticed several instances of duplicate data so I applied a select 'distict operation' to retain unique employee data. Following is the code that I wrote, and as beofe this is included in the sql query file.
  
--Challenge Table_2 Mentorship Eligibility
--step_1 Join employees and titles tables to create new mentor_emp 
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	ti.title,
	ti.from_date,
	ti.to_date
INTO mentor_emp
FROM employees as e
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
;
--step_2 select desired columns from mentor_emp table. Running this query will output the desired list.
-- drop table created in this step to rerun
drop table challenge_2_not_distinct;

SELECT emp_no,first_name,last_name,title,from_date,to_date
INTO challenge_2_not_distinct
FROM mentor_emp
Order by emp_no
;
--step3 select distinct
-- drop table created in this step to rerun
drop table challenge_Mentorship_Eligibility;

--select distinct on emp_no and return all columns
Select distinct on (emp_no) *
Into challenge_Mentorship_Eligibility
from challenge_2_not_distinct
order by emp_no
;
  
  
## Part_3: Analysis and Discussion
PH tasked me with reviewing their employee data and creating a database and queries to understand and plan their workforce. I have a few observations and recommendations based on my analysis.
- PH has more than 300,000 employees. Their challenge is that some 41,380 are scheduled to retire. This poses a significant challenge in succession planning, training, and retention.
- An analysis of the employee base also shows that the younger team is about 1940 employees. This is an important group to train and mentor as next gen leaders.
- A particular concern may be that more than 7300 of reiring emploees are in sales. The company should review all customer accounts that may be impacted and develop a communications and coverage strategy.
- I'd also recommend better monitoring of assignment of department heads. As of the query date, it appears some departments were not assigned managers.

The employee data is very helpful but can be improved in many ways. Tracking promotions, salary hikes, review and ratin, and other data may help in developing a more effective HR strategy. A periodic analysis of potential risks due to retirements and other workforce disruption would also be helpful.
