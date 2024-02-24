USE SalesEcommerce

SELECT  max (Sales)
FROM [US  E-commerce records 2020]

SELECT *
FROM [US  E-commerce records 2020]

--**In The Beginning 
-- SUM Of Total (Sales - Quantity - Profit )

SELECT (SUM(Sales)) AS TotalSales
FROM [US  E-commerce records 2020]

SELECT (SUM (Quantity)) AS TotalQuantitys
FROM [US  E-commerce records 2020]

SELECT (SUM (Profit)) AS TotalProfit
FROM [US  E-commerce records 2020]

-- Top City By Ordared 

SELECT City, Quantity, Sales
FROM [US  E-commerce records 2020]
ORDER BY Quantity DESC 

-- Top State By Ordared 

SELECT State, SUM(Quantity) AS TotalQuantity, SUM(Sales) AS TotalSales
FROM [US  E-commerce records 2020]
GROUP BY State
ORDER BY State DESC;


-- Selling categories

SELECT Category, (Sales) AS TotalSales
FROM [US  E-commerce records 2020]
ORDER BY 2 DESC
-- Final Gode 
SELECT Category, COUNT(Quantity) As TotalQunatity
FROM [US  E-commerce records 2020]
GROUP BY Category
ORDER BY TotalQunatity DESC

-- Top 10 Product selling

SELECT Top 10 Product_Name, COUNT(Quantity) As Total_P_Qunatity
FROM [US  E-commerce records 2020]
GROUP BY Product_Name
ORDER BY Total_P_Qunatity DESC

-- Sales distribution
--In this part, it selects the sales, category, and uses a CASE statement to classify sales into different categories based on their values. 
--The results are then ordered in descending order based on the first column (TotalSales).

SELECT (Min(Sales)) As TotalSales, (AVG(Sales)), (MAX(Sales))
FROM [US  E-commerce records 2020]

SELECT (Sales) As TotalSales, Category,
		CASE 
			WHEN Sales <= 1000 THEN 'Less Then 1K'
			WHEN Sales >= 1000 AND Sales <= 5000 THEN '1k To 5k'
			WHEN Sales >= 5001  AND Sales <= 10000 THEN '5k To 10k'
		  ELSE 'More than 10k'
		END AS Sales_distribution
FROM [US  E-commerce records 2020]
ORDER BY 1 DESC

-- Sales clusters By Category & Quantity 
--This query is designed to analyze and count the total quantity of items for each sales distribution category and category combination from the "US E-commerce records 2020" table. 

SELECT Sales_distribution, Category,
COUNT (Quantity) AS Total_Quantity
FROM 
	(SELECT 
		CASE 
			WHEN Sales <= 1000 THEN 'Less Then 1K'
			WHEN Sales <= 1001 AND Sales <= 5000 THEN '1k To 5k'
			WHEN Sales <= 5001  AND Sales <= 10000 THEN '5k To 10k'
			ELSE 'More than 10k'
		END AS Sales_distribution, Category, Quantity
		FROM [US  E-commerce records 2020]
	) AS Subqury
GROUP BY Sales_distribution, Category
ORDER BY Sales_distribution DESC

----------------------------------------------------------
-- CET BY Whatever I need 
------------------------Here is the ranking according to the number of customers-----------------------------
--The query aims to analyze and rank customers based on the total count of customers for each unique combination of Quantity and Sales values, 
--considering only records where Sales is between 1000 and 14000. The DENSE_RANK() function is used to assign a rank to each record based on the descending order of Total_Cus_Quantity

WITH CTE_Ecommerce AS (
    SELECT 
        Customer_ID, 
        Segment, 
        City, 
        Category, 
        Ship_Mode,
        COUNT(Customer_ID) OVER (PARTITION BY Quantity) AS Total_Cus_Quantity,
        COUNT(Customer_ID) OVER (PARTITION BY Sales) AS Total_Cus_Sales
    FROM [US  E-commerce records 2020]
    WHERE Sales BETWEEN 1000 AND 14000
)

SELECT 
    *,
    DENSE_RANK() OVER (ORDER BY Total_Cus_Quantity DESC) AS Customer_Rank
FROM CTE_Ecommerce
ORDER BY Total_Cus_Quantity DESC;

------------------------ Here is the grouping by category and Segment ------------------------------- 
SELECT 
    Category, 
    Segment, 
    Total_Cus_Quantity 
FROM CTE_Ecommerce
GROUP BY Category, Segment, Total_Cus_Quantity
ORDER BY 1, 2, 3 DESC; 

---------------------------------------------------------------------------

--In this Case, we use a Numbers CTE to generate a sequence of numbers and then use it to create a DateSeries CTE. 
--The HAVING clause is used to limit the iterations based on the date range. 
--Finally, we join the DateSeries with the e-commerce records to find the missing order dates.

WITH Numbers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values
)

, DateSeries AS (
    SELECT DATEADD(DAY, n, MIN(Order_Date)) AS OrderDate,
	     CASE  
            WHEN (DATEPART(WEEKDAY , DATEADD(DAY, n, MIN(Order_Date))) % 7) IN (6, 7) THEN 'Weekend'
            ELSE 'Work Day'
        END AS DayType
    FROM [US  E-commerce records 2020]
    CROSS JOIN Numbers
    GROUP BY n
    HAVING DATEADD(DAY, n, MIN(Order_Date)) <= MAX(Order_Date)
)

SELECT ds.OrderDate AS Missing_order_date, ds.DayType
FROM DateSeries ds
LEFT JOIN [US  E-commerce records 2020] o
ON ds.OrderDate = o.Order_Date
WHERE o.Order_Date IS NULL





