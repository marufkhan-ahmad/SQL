USE SalesDB;
SELECT * FROM Sales.Orders;

;WITH TopOrders AS (
		SELECT
			CustomerID,
			OrderID,
			Sales,
			RANK() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) AS TopRank
		FROM
		   Sales.ORDERS
)
	SELECT
	   * FROM
	   TopOrders
	   WHERE 
	      TopRank <= 3;
