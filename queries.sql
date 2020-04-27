-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
    dept_no VARCHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);
-- Creating tables for PH-EmployeeDB
CREATE TABLE employees (
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(40) NOT NULL,
	gender VARCHAR(2) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no),
    UNIQUE (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE salaries (
  	emp_no INT NOT NULL,
  	salary INT NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employees (
  	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
  	PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
  	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (emp_no,title,from_date)
);

--Verify if tables were created as expected
SELECT * FROM dept_employees;
SELECT * FROM titles;
SELECT * FROM dept_employees;

--Determine retirement eligibility based on hire date and dob
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Count the queries
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Determine eligibility and create new table called retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Update retirement_info table to add emp_no (remember to DROP TABLE created earlier prior to executing)
DROP TABLE retirement_info;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Verify if query returned expected result
SELECT * FROM retirement_info

-- Join departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Join retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no;

-- Use alias for table names and left join retirement_info and dept_employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no;

-- 7.3.3 Use alias names to join dept_names and departments
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- 7.3.3 Repeat join departments and dept_manager tables but use aliases
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- 7.3.3 Use aliases and create table current_emp for active employees only
--First create new table current_emp
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
-- Join and filter
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- 7.3.4 Employee count, grouby and order by department number
SELECT COUNT(ce.emp_no), de.dept_no
--Create new table count_by_dept and save to csv
INTO count_by_dept
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
--Add query to create new table and save to csv

-- 7.3.5 part_1
SELECT * FROM salaries
ORDER BY to_date DESC;

--7.3.5 part_1 Add last_name and gendes to query
--FIRST drop tabke if rerunning quesry
DROP TABLE emp_info;
--Run query
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
--create new_table emp_info
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- 7.3.5 part_2
-- List of managers per department
-- DROP TABLE if running script
drop table manager_info;

SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
ON (dm.emp_no = ce.emp_no);

-- 7.3.5 part_3
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employees AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--7.3.6 Sales_dept list
--drop table before rerunning script
drop table sales_emp;
--step_1 Join retirement_info and dept_employees to create new table sales_emp 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.dept_no
--INTO sales_emp
FROM retirement_info as ri
INNER JOIN dept_employees as de
ON ri.emp_no = de.emp_no
;
--step_2 join sales_emp with departments table and filter for Sales dept only
SELECT se.emp_no,
	se.first_name,
	se.last_name,
	d.dept_name
FROM sales_emp as se
INNER JOIN departments as d
ON (se.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales')
;


--Challenge Table_1 Number of Retiring Employees by Title
--step_1 Join retirement_info and titles to create new table titles_emp 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ti.title,
	ti.from_date
INTO titles_emp
FROM retirement_info as ri
INNER JOIN titles as ti
ON ri.emp_no = ti.emp_no
;
--step_2 Join titles_emp and salaries, and order by emp_no. Running this query will output the desired list.
SELECT te.emp_no,
	te.first_name,
	te.last_name,
	te.title,
	te.from_date,
	sa.salary
INTO challenge_1__not_distinct
FROM titles_emp as te
INNER JOIN salaries as sa
ON (te.emp_no = sa.emp_no)
ORDER BY te.emp_no;
;
--step_3 select distinct
-- drop table created in this step to rerun
drop table Challenge_Retiring_Employees;

--select distinct on emp_no and return all columns
Select distinct on (emp_no) *
Into Challenge_Retiring_Employees
from challenge_1__not_distinct
order by emp_no
;


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