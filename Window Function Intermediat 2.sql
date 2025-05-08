USE SalesDB;
SELECT * FROM Sales.Orders;

--Har SalesPersonID ke liye:

--Top Sale OrderID (sabse zyada Sales)

--Bottom Sale OrderID (sabse kam Sales) ek hi query me nikalna hai.

;WITH RankedOrders AS(
			SELECT
				SalesPersonID,
				OrderID,
				Sales,
				ROW_NUMBER() OVER(PARTITION BY SalesPersonID ORDER BY Sales DESC) AS TopRanked,
				ROW_NUMBER() OVER(PARTITION BY SalesPersonID ORDER BY Sales ASC) AS BottomRanked
			FROM
				Sales.Orders
)
SELECT
	SalesPersonID,
	MAX(CASE WHEN TopRanked = 1 THEN OrderID END) AS TopSaleOrderID,
	MAX(CASE WHEN BottomRanked = 1 THEN OrderID END) AS BottomSaleOrderID
FROM 
  RankedOrders
GROUP BY
	SalesPersonID
ORDER BY
	SalesPersonID;


--Har SalesPersonID ke liye:

--Top N Sales Orders (highest sales)

--Bottom N Sales Orders (lowest sales) ko ek hi query me nikalna hai.
WITH RankedOrders AS(
			SELECT
			    SalesPersonID,
				OrderID,
				Sales,
				ROW_NUMBER() OVER(PARTITION BY SalesPersonID ORDER BY Sales DESC) AS TopRanked,
				ROW_NUMBER() OVER(PARTITION BY SalesPersonID ORDER BY Sales ASC) AS BottomRanked
			FROM
			  Sales.Orders
)

SELECT
	SalesPersonID,
	OrderID,
	Sales,
	CASE
		WHEN TopRanked <= 3 THEN 'Top Order'
		WHEN BottomRanked <= 3 THEN 'Bottom Order'
	ELSE NULL
	END AS 
	    OrderCategory
FROM 
	RankedOrders
WHERE 
	TopRanked <= 3
OR
	BottomRanked <= 3
ORDER BY
      SalesPersonID,
	  OrderCategory,
	  Sales
	  DESC;

--Rank customers based on their first order's sales.

WITH CustomerOrders AS(
		SELECT
		   CustomerID,
		   OrderID,
		   Sales,
		   ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstSale
		FROM 
		  Sales.Orders
)

SELECT
	CustomerID,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS CustomerRank
FROM 
   CustomerOrders

WHERE
   FirstSale <= 1
ORDER BY
    CustomerRank;

--Find the total number of orders placed by
--each CustomerID using COUNT() OVER (PARTITION BY CustomerID).
SELECT
	OrderID,
	CustomerID,
	COUNT(OrderID) OVER(PARTITION BY CustomerID ) AS TotalOrders
FROM
	Sales.Orders;

--Calculate running total sales across all orders sorted by OrderDate.
SELECT
	OrderID,
	OrderDate,
	Sales,
	SUM(Sales) OVER(ORDER BY OrderDate) AS TotalSales
FROM
  Sales.Orders;

--Rank SalesPersonID based on their total sales.
WITH SalesTable AS(
		SELECT
			SalesPersonID,
			SUM(Sales) AS TotalSales
		FROM
			Sales.Orders

		GROUP BY
			SalesPersonID
)
SELECT
	SalesPersonID,
	RANK() OVER(ORDER BY TotalSales DESC) AS TotalNumberSales
FROM
	SalesTable;

--Rank customers based on their total quantity ordered.
;WITH QuantityOrders AS(
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
	DENSE_RANK() OVER(ORDER BY TotalQuantity DESC) AS TotalQuantityOrder
FROM
	QuantityOrders;

--Calculate cumulative sales for each ProductID.

			SELECT
				ProductID,
				OrderID,
				OrderDate,
				SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AS CumulativeSales
			FROM
				Sales.Orders;

--Find the maximum quantity ordered for each SalesPerson.
SELECT
	SalesPersonID,
	Quantity,
	MAX(Quantity) OVER(PARTITION BY SalesPersonID) AS MaxmQuantity
FROM
	Sales.Orders;

--Find the minimum shipment duration per Customer.
SELECT
	CustomerID,
	ShipDate,
	MIN(ShipDate) OVER(PARTITION BY CustomerID) AS MinmShipment
FROM
   Sales.Orders;

--Another Approach
SELECT
    CustomerID,
    MIN(DATEDIFF(DAY, OrderDate, ShipDate)) AS MinShipmentDuration
FROM
    Sales.Orders
GROUP BY
    CustomerID;

--Calculate the cumulative number of orders for each ShipAddress.
SELECT
	OrderID,
	ShipAddress,
	COUNT(OrderID) OVER(PARTITION BY ShipAddress ORDER BY OrderID) AS cumulativeOrders
FROM
	Sales.Orders;

--Find the sum of sales for each OrderStatus using window function.
SELECT
	OrderStatus,
	SUM(Sales) OVER(PARTITION BY OrderStatus) AS SumOfSales
FROM
   Sales.Orders;
			
--Find the cumulative sales growth for each Customer over time.
SELECT
	Sales,
	CustomerID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS Cumulative_sales_growth
FROM
  Sales.Orders;

--Rank products by total sales amount and show ties (DENSE_RANK()).
WITH SalesTable AS(
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
	DENSE_RANK() OVER(ORDER BY TotalSales DESC) AS totalproductsales
FROM
  SalesTable;

-- LAG(), LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE()

--Use LAG() to find the difference in Sales between the current and previous order for each CustomerID.
  SELECT 
	OrderID,
	CustomerID,
	Sales,
	Sales - LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderID) AS salesDifference
FROM
   Sales.Orders;

--Using CTE
WITH SalesDiff AS (
		SELECT
		   CustomerID,
		   OrderID,
		   Sales,
		   Sales - LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderID) AS SalesDifference
		FROM
		  Sales.Orders
	)

	SELECT
	   *
	   FROM SalesDiff;

--Use LEAD() to find the next ShipDate for each order placed by the same CustomerID.
SELECT
	ShipDate,
	OrderID,
	CustomerID,
	LEAD(ShipDate) OVER(PARTITION BY CustomerID ORDER BY OrderID) AS NextShipDate
FROM
   Sales.Orders;

--Detect if the OrderStatus has changed between consecutive orders for the same SalesPersonID using LAG().
SELECT
	OrderStatus,
	OrderID,
	SalesPersonID,
	LAG(OrderStatus) OVER(PARTITION BY SalesPersonID ORDER BY OrderID) AS PerviousOrderStatus,
	CASE
		WHEN OrderStatus != LAG(OrderStatus) OVER(PARTITION BY SalesPersonID ORDER BY OrderID)
        THEN 'Changed'
		ELSE 'Same'
		END AS StatusChanged
FROM
  Sales.Orders;

--Use LAG() to find how many days passed since the last order per CustomerID (using OrderDate).
SELECT
	OrderDate,
	CustomerID,
	OrderID,
	LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PrevOrderDate,
	DATEDIFF(DAY, LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) AS daypassed
FROM
   Sales.Orders;

--Use LEAD() to calculate how many days until the next shipment per SalesPersonID.
SELECT
	OrderDate,
	ShipDate,
	SalesPersonID,
	LEAD(ShipDate) OVER(PARTITION BY SalesPersonID ORDER BY ShipDate) as prevshipdate,
	DATEDIFF(DAY, ShipDate, LEAD(ShipDate) OVER(PARTITION BY SalesPersonID ORDER BY ShipDate)) AS Shipdate
FROM
  Sales.Orders;

--Use FIRST_VALUE() to get the first OrderDate for each CustomerID.
SELECT
	OrderDate,
	OrderID,
	CustomerID,
	FIRST_VALUE(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS FirstOrder
FROM
   Sales.Orders;

--Use LAST_VALUE() to find the most recent ShipDate for each CustomerID.
WITH LastValue AS(
		SELECT
			ShipDate,
			CustomerID,
			LAST_VALUE(ShipDate) OVER(PARTITION BY CustomerID ORDER BY ShipDate
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
			) 
			AS MostRecentShipDate
		FROM
		   Sales.Orders
)
   SELECT * FROM LastValue;


				

