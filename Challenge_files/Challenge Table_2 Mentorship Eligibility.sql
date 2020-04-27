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