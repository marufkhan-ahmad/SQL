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


