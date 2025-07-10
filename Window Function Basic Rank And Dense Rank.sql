USE SalesDB;
SELECT * FROM
Sales.Orders;

-- Basic Level (10 Questions)
--1. Use RANK() to rank orders based on Sales in descending order.

SELECT
  OrderID,
  Sales,
  RANK() OVER(ORDER BY Sales DESC) AS SalesRank
FROM
    Sales.Orders;

--Use DENSE_RANK() to rank customers based on total Quantity ordered.
SELECT
	CustomerID,
	SUM(Quantity) AS TotalQuantity,
	DENSE_RANK() OVER(ORDER BY SUM(Quantity)) AS Ranks
FROM
   Sales.Orders
GROUP BY
      CustomerID;

--With CTE

;WITH CustomerTable AS(
	 SELECT
	    CustomerID,
		SUM(Quantity) AS TotalQuantity
	 FROM 
	    Sales.Orders
	GROUP BY
	      CustomerID
)

SELECT
   CustomerID,
   TotalQuantity,
   DENSE_RANK() OVER(ORDER BY TotalQuantity DESC) AS Rank

FROM
   CustomerTable
ORDER BY
      Rank;

--Find the RANK() of orders based on OrderDate (earlier orders rank first).
SELECT
   OrderId,
   OrderDate,
   RANK() OVER(ORDER BY OrderDate ASC) AS RankOrder,
   DENSE_RANK() OVER(ORDER BY OrderDate ASC) AS DenseRankOrder
FROM
	Sales.Orders;


----Find the total Sales per CustomerID using aggregation (SUM() OVER()).
 SELECT
 	Sales,
	CustomerID,
	SUM(Sales) OVER(PARTITION BY CustomerID) AS TotalSales,
--Adding DESNE_RANK() Means you can see the RANK Of Orders without skipping ranks
	DENSE_RANK() OVER(ORDER BY CustomerID) AS Rank
FROM 
   Sales.Orders

   
--Find the average Sales per SalesPersonID using AVG() OVER().
SELECT
	Sales,
	SalesPersonID,
	AVG(Sales) OVER(PARTITION BY SalesPersonID) AS AverageSales
FROM
  Sales.Orders;


--Rank products based on total sales amount using RANK().
SELECT
   ProductID,
   SUM(Sales) AS TotalSales,
   RANK() OVER(ORDER BY SUM(Sales))AS RANK
FROM
   Sales.Orders
   
GROUP BY
	ProductID;
	
--using CTE
;WITH SalesTable AS(
		SELECT
		  ProductID,
		  SUM(Sales) AS TotalSales
	    FROM
		   Sales.Orders
		GROUP BY
			ProductID
)

SELECT
   ProductID,
   RANK() OVER(ORDER BY TotalSales) AS SalesRank
FROM
	SalesTable
ORDER BY
      SalesRank;

--Calculate cumulative Sales using SUM() OVER (ORDER BY OrderDate).
SELECT
	OrderDate,
	SUM(Sales) OVER(ORDER BY OrderDate) AS CumulativeSales
FROM
	Sales.Orders;
	
	
--using cte
;WITH SalesTable AS(
	  SELECT
	     OrderDate,
		 SUM(Sales) OVER(ORDER BY OrderDate) AS CumulativeSales
	  FROM
	     Sales.Orders
)

SELECT
	OrderDate,
	DENSE_RANK() OVER(ORDER BY CumulativeSales) AS DenseRank
FROM
   SalesTable;


--Calculate cumulative Quantity sold using SUM() OVER (ORDER BY ShipDate).
SELECT
	ShipDate,
	SUM(Quantity) OVER(ORDER BY ShipDate) AS CumulativeQuantity
FROM
   Sales.Orders
   
   
;WITH CumulativeTable AS(
	  SELECT
	     ShipDate,
		 SUM(Quantity) AS CumulativeQuantity
	  FROM
	     Sales.Orders
	  GROUP BY
	        ShipDate
)

SELECT
	ShipDate,
	DENSE_RANK() OVER(ORDER BY CumulativeQuantity) AS DenseRank
FROM
   CumulativeTable;


--Find the MAX() sales value per ProductID using window aggregation.
SELECT
   ProductID,
   MAX(Sales) OVER(PARTITION BY ProductID) AS MaxmSales
FROM
	Sales.Orders
	
	
--using cte
;WITH MaxmSalesTable AS(
			SELECT
			   ProductID,
			   MAX(Sales) AS MaximumSales
			FROM
			  Sales.Orders
			GROUP BY
				ProductID
)

SELECT
	ProductID,
	DENSE_RANK() OVER(ORDER BY MaximumSales DESC) AS DenseRank
FROM
   MaxmSalesTable;
----Find the MIN() order quantity per CustomerID using window aggregation.
SELECT
    CustomerID,
    MIN(Quantity) OVER (PARTITION BY CustomerID) AS MinmQuantity
FROM
    Sales.Orders;

--USING CTE
;WITH MinTable AS (
		SELECT
			CustomerID,
			MIN(Quantity) AS minmquantity
		FROM
		  Sales.Orders
		GROUP BY
		      CustomerID
)

SELECT
	CustomerID,
	DENSE_RANK() OVER(ORDER BY minmquantity) AS DenseRank
FROM
	MinTable;




   
