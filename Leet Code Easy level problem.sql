-- 175 Combine Two Tables

-- write a solution to report the first name, last name
-- city, and state of each person in the Person table.
-- if address of a personId is not present in the Address table,
-- report null instead.

USE LeetCode;
SELECT * FROM dbo.Person;
SELECT * FROM dbo.Address;

;WITH Reporttables AS(
			SELECT
			   p.firstName,
			   p.lastName,
			   a.city,
			   a.state
			FROM
			   dbo.Person AS p
			LEFT JOIN
				 dbo.Address AS a
			ON
			   p.personId = a.personId
)
    SELECT * FROM  Reporttables;


-- Employee Earning More Than Their Manager
SELECT * FROM dbo.Employee;

WITH HighestSalary AS(
		SELECT
		    e1.name AS Employee
	    FROM
		   dbo.Employee e1
		JOIN
		   dbo.Employee e2 
		ON
		  e1.managerId = e2.id
		WHERE
		   e1.salary > e2.salary
)
   SELECT * FROM HighestSalary;
