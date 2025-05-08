-- 175 Combine Two Tables

-- write a solution to report the first name, last name
-- city, and state of each person in the Person table.
-- if address of a personId is not present in the Address table,
-- report null instead.

-- USE LeetCode;
-- SELECT * FROM dbo.Person;
-- SELECT * FROM dbo.Address;

-- ;WITH Reporttables AS(
-- 			SELECT
-- 			   p.firstName,
-- 			   p.lastName,
-- 			   a.city,
-- 			   a.state
-- 			FROM
-- 			   dbo.Person AS p
-- 			LEFT JOIN
-- 				 dbo.Address AS a
-- 			ON
-- 			   p.personId = a.personId
-- )
--     SELECT * FROM  Reporttables;


-- Employee Earning More Than Their Manager
-- SELECT * FROM dbo.Employee;

-- WITH HighestSalary AS(
-- 		SELECT
-- 		    e1.name AS Employee
-- 	    FROM
-- 		   dbo.Employee e1
-- 		JOIN
-- 		   dbo.Employee e2 
-- 		ON
-- 		  e1.managerId = e2.id
-- 		WHERE
-- 		   e1.salary > e2.salary
-- )
--    SELECT * FROM HighestSalary;


-- Duplicate Eamails

-- CREATE TABLE DuplicateEmails(
-- 			id INTEGER PRIMARY KEY,
-- 			email VARCHAR(30)
-- );

-- INSERT INTO dbo.DuplicateEmails(id, email)
-- VALUES (4, 'a@b.com'),
--        (5, 'c@d.com'),
--        (6, 'a@b.com');

-- SELECT * FROM dbo.DuplicateEmails;

-- Solution using groupby
-- SELECT
-- 	DISTINCT
--      email
-- FROM
--    dbo.DuplicateEmails
-- GROUP BY email
-- HAVING COUNT(*) > 1;

-- Solution 2
-- WITH Duplicates AS(
-- 	 SELECT
-- 	 	email,
-- 		COUNT(*) OVER(PARTITION BY email) AS rn
-- 	FROM 
-- 	   dbo.DuplicateEmails
-- )

-- SELECT 
--    DISTINCT
--      email
-- FROM
--     Duplicates
-- WHERE rn > 1;


-- CREATE TABLE Customers(
-- 			 id INTEGER PRIMARY KEY,
-- 			 name VARCHAR(20)
-- );

-- INSERT INTO dbo.Customers(id, name)
-- 					VALUES(1, 'Joe'),
-- 					      (2, 'Henry'),
-- 						  (3, 'Sam'),
-- 						  (4, 'Max');
-- SELECT * FROM dbo.Customers;

-- CREATE TABLE Orders(
-- 				id INTEGER PRIMARY KEY,
-- 				customerId INTEGER
-- );

-- INSERT INTO dbo.Orders(id, customerId)
-- 				VALUES(1, 3),
-- 				       (2, 1);

-- SELECT * FROM dbo.Orders;

-- Solution Using Subquery
-- SELECT
--    name AS Customers
-- FROM
--    dbo.Customers

-- WHERE id NOT IN (SELECT CustomerId FROM dbo.Orders);

-- Solution Using LEFT JOIN

-- SELECT
--    c.name AS Customers
-- FROM  dbo.Customers c
-- LEFT JOIN dbo.Orders o  ON 
-- c.id = o.customerId
-- WHERE customerId IS NULL;

-- Game Play Analysis 1

-- CREATE TABLE Activities(
-- 	 player_id INTEGER,
-- 	 device_id INTEGER,
-- 	 event_date date,
-- 	 games_played int,
-- 	 PRIMARY KEY(player_id, event_date)
-- );

-- INSERT INTO dbo.Activities(player_id, device_id, event_date, games_played)
-- 				VALUES(1, 2, '2016-03-01', 5),
-- 					  (1, 2, '2016-05-02', 6),
-- 					  (2, 3, '2017-06-25', 1),
-- 					  (3, 1, '2016-03-02', 0),
-- 					  (3, 4, '2018-07-03', 5);

-- WITH Gametable AS(
-- 	  SELECT
-- 	  	player_id,
-- 		event_date AS first_login,
-- 		ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS rn
-- 	  FROM
-- 	     dbo.Activities
-- )
-- SELECT
--   player_id,
--   first_login
-- FROM  
--     Gametable
-- WHERE rn = 1;

USE Flipshope;
SELECT * FROM dbo.Partners_April;
SELECT COUNT(*) FROM dbo.Partners_April;