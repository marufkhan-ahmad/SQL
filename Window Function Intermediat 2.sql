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