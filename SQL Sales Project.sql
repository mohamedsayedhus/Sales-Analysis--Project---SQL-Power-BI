USE SalesEcommerce

SELECT  max (Sales)
FROM [US  E-commerce records 2020]

SELECT Customer_ID
FROM [US  E-commerce records 2020]

--**In The Beginning 
-- SUM Total (Sales - Quantity - Profit )

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
GROUP BY Sales_distribution, Category, Quantity
ORDER BY Sales_distribution DESC

----------------------------------------------------------
-- CET BY Whatever I need 
------------------------Here is the ranking according to the number of customers-----------------------------

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





