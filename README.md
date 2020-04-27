# Pewlett-Hackard-Analysis

## Background of problem
PH wants to analyze their employee data to plan for employees who are retiring, new employees that need mentoring, and identify areas for better data gathering and structure to improve their business. For this project, I reviewed data that PH has in multiple files and created a postgres database that makes it easier to query and anayze data.

## Part_1
To start this analysis, I created an entity relationship diagram (ERD), as shwn below, to visualize the various csv files that PH provided. This involved a review of the fields in each file, determining commonality, and creating a schema that described the relationships between the csv files. (You can find the schma from which the ERD is derived at: https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/Challenge_files/EmployeeDB_QuickDBD_schema.txt)

  ![](https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/Challenge_files/EmployeeDB%20ERD.png)  
    
    
## Part_2
Based on this ERD, I created a database and wrote several SQL queries to create tables to understand the data. With the csv files provided, the first step was to create six tables: Department, Employees, Dept Managers, Salaries, Dept Employees and Titles. A copy of the full sql queries file is at: https://github.com/aramaswami/Pewlett-Hackard-Analysis/blob/master/queries.sql
  
PH management wanted to specifically analyze and create two tables that they presented as challenges : (i) Table_1: Number of Retiring Employees by Title; and (ii) Table_2: Mentorship Eligibility.
  
### Table_1: Number of Retiring Employees by Title



