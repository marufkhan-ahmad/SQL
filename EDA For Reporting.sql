--24. Get Top 3 Orders Per CustomerID
--Goal: For each CustomerID, fetch their top 3 highest orders (based on order value).

USE SalesDB;
SELECT * FROM Sales.Orders;
;WITH TopOrder AS(
		SELECT
		   CustomerID,
		   Sales,
		   RANK() OVER(PARTITION BY CustomerID ORDER BY Sales) AS tophighestorder
		FROM
		   Sales.Orders
)

SELECT
   CustomerID,
   Sales
FROM
  TopOrder
WHERE tophighestorder <= 3;

--25. Get the Highest Sale OrderID per CustomerID
--Goal: For every CustomerID, return the OrderID with the highest sales

;WITH HighestSales AS(
			SELECT
			  OrderID,
			  CustomerID,
			  Sales,
			  ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) AS TotalSales
			FROM
			  Sales.Orders
)
SELECT
  OrderID,
  CustomerID,
  Sales
FROM
   HighestSales
WHERE
   TotalSales = 1;


--26. Top 1 Order per CustomerID using ROW_NUMBER()
--Goal: Use ROW_NUMBER() to get the top 1 order for each CustomerID.

;WITH OrderCustomer AS(
		SELECT
			CustomerID,
			OrderID,
			Sales,
			ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales) AS RN
		FROM
		  Sales.Orders
)
SELECT 
	CustomerID,
	OrderID,
	Sales
FROM
	OrderCustomer
WHERE 
	RN = 1;

--Month wise Top selling product.
WITH MonthlyProductSales AS (
    SELECT 
        FORMAT(OrderDate, 'yyyy-MM') AS SaleMonth,
        ProductID,
        SUM(Quantity) AS TotalQuantity,
        RANK() OVER (
            PARTITION BY FORMAT(OrderDate, 'yyyy-MM') 
            ORDER BY SUM(Quantity) DESC
        ) AS rk
    FROM Sales.Orders
    GROUP BY FORMAT(OrderDate, 'yyyy-MM'), ProductID
)
SELECT *
FROM MonthlyProductSales
WHERE rk = 1;




;WITH MonthRanked AS(
		SELECT
		    FORMAT(OrderDate, 'yyyy-MM') AS MonthSales,
			ProductID,
			SUM(Quantity) AS TotalQuantity,
			RANK() OVER(PARTITION BY FORMAT(OrderDate,'yyyy-MM')
			ORDER BY SUM(Quantity) DESC) AS rn
		FROM
		  Sales.Orders
		GROUP BY
		     FORMAT(OrderDate,'yyyy-MM'), ProductID
)
SELECT * 
    FROM
	 MonthRanked
WHERE rn = 1;

-- 30. Max Sales Per Product + Top 5 Products
WITH SalesTable AS(
		SELECT
			ProductID,
			MAX(Sales) AS MaxSales
		FROM
			Sales.Orders
		GROUP BY
			  ProductID
)
SELECT TOP 5*
FROM  SalesTable
ORDER BY
	MaxSales;


-- Monthly Sales + Running Total for Each SalesPerson

WITH MonthlySales AS (
    SELECT 
        SalesPersonID,
        DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SaleMonth,
        SUM(Sales) AS MonthlyTotal
    FROM Sales.Orders
    GROUP BY SalesPersonID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
RunningTotal AS (
    SELECT *,
        SUM(MonthlyTotal) OVER (
            PARTITION BY SalesPersonID 
            ORDER BY SaleMonth
        ) AS CumulativeTotal
    FROM MonthlySales
) 
SELECT * FROM RunningTotal;


--Find the second highest sales order per CustomerID using RANK() or DENSE_RANK().
WITH Highestsales AS(
	  SELECT
	     CustomerID,
		 Sales,
		 DENSE_RANK() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) AS SecondHighestSales
	  FROM
	     Sales.Orders
)
SELECT 
   CustomerID,
   Sales
FROM Highestsales
WHERE SecondHighestSales = 2;

--Identify the top 3 orders (based on Quantity) per ShipAddress using RANK().
WITH TopOrders AS(
		SELECT
			Quantity,
			ShipAddress,
			RANK() OVER(PARTITION BY ShipAddress ORDER BY Quantity DESC) AS rn
		FROM
		   Sales.Orders
)

SELECT
   Quantity,
   ShipAddress
   FROM
     TopOrders
  WHERE rn <= 3;

--Rank all orders by Sales per ProductID and 
--return only those with RANK() = 1 (i.e., top sale per product).
WITH OrdersRanked AS(
		SELECT
			Sales,
			ProductID,
			RANK() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS rn
		FROM
		  Sales.Orders
)

   SELECT
      Sales, ProductID
   FROM
     OrdersRanked
   WHERE rn = 1;

--For each SalesPersonID, calculate the running total of Sales ordered by OrderDate.
WITH RunningTotal AS(
		SELECT
			SalesPersonID,
			Sales,
			OrderDate,
			SUM(Sales) OVER(PARTITION BY SalesPersonID ORDER BY OrderDate DESC) AS RN
      FROM 
	    Sales.Orders
)
SELECT * FROM RunningTotal;

--Calculate running average of sales for each customer across their orders sorted by OrderDate.
WITH RunningAverage AS(
		SELECT
			Sales,
			CustomerID,
			OrderDate,
			AVG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS rn
		FROM
		   Sales.Orders
)

SELECT
   *
FROM
   RunningAverage;