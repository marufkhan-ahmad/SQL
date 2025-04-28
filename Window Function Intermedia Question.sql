SELECT * FROM Sales.Orders;

--Rank orders per SalesPersonID based on Sales.
SELECT
	OrderID,
	SalesPersonID,
	Sales,
	RANK() OVER(PARTITION BY SalesPersonID ORDER BY Sales) AS Rank
FROM
	Sales.Orders;


--Find total Sales per ShipAddress using SUM() OVER (PARTITION BY ShipAddress).
SELECT
	Sales,
	ShipAddress,
	SUM(Sales) OVER(PARTITION BY ShipAddress) AS totalsales
FROM
	Sales.Orders;

--Find the average Quantity per ProductID using AVG() OVER (PARTITION BY ProductID).
SELECT
	ProductID,
	Quantity,
	AVG(Quantity) OVER(PARTITION BY ProductID) AS AvgQuantity
FROM
	Sales.Orders;

--Find the highest sale per CustomerID using MAX() OVER (PARTITION BY CustomerID).
SELECT
	CustomerID,
	Sales,
	MAX(Sales) OVER(PARTITION BY CustomerID) AS HighestSales
FROM
	Sales.Orders;

--Find the minimum sale per SalesPersonID using MIN() OVER (PARTITION BY SalesPersonID).
SELECT
	SalesPersonID,
	Sales,
	MIN(Sales) OVER(PARTITION BY SalesPersonID) AS MinmSales
FROM
   Sales.Orders;

--Rank customers based on their first order's sales.
WITH FirstOrderSales AS (
    SELECT
        CustomerID,
        Sales,
        ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC) AS OrderRank
    FROM
        Sales.Orders
)

SELECT
    CustomerID,
    Sales AS FirstOrderSales,
    RANK() OVER(ORDER BY Sales DESC) AS CustomerRank
FROM
    FirstOrderSales
WHERE
    OrderRank = 1
ORDER BY
    CustomerRank;

--Har SalesPersonID ke liye:

