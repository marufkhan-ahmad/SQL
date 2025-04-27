USE SalesDB;
SELECT * FROM Sales.Orders;

--Find the total sales across all orders
--Additionally provide details such as order Id, and order date

/* Here groupby Limits can't do aggregation
and provide details at same time so we can use window function
*/

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) TotalSales
FROM 
   Sales.Orders
   GROUP BY 
   ProductID,
   OrderID,
   OrderDate;


--Result Granularity
-- Window Function returns
-- a result for each row
--Here in this query there are multiple windows of productId

SELECT
	OrderID,
	OrderDate,
	ProductID,
   SUM(Sales) OVER(PARTITION BY ProductID)
   AS Total_Sales
FROM 
	Sales.Orders;


--only one window 
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() AS total_sales
FROM
   Sales.Orders;



