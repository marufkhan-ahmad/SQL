SELECT * FROM dbo.shahnawaz_15_to_24_April;
SELECT COUNT(*) AS totalrows FROM dbo.shahnawaz_15_to_24_April;
SELECT 
	res_id,
	order_date,
	status,
	COUNT(order_date) OVER(PARTITION BY res_id) AS RN
FROM
   dbo.shahnawaz_15_to_24_April;