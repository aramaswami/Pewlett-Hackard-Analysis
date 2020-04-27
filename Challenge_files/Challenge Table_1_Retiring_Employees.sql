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