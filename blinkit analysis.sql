USE blinkit_db;
SELECT COUNT(*) FROM blinkit;
SELECT * FROM blinkit;

-- DATA CLEANING........
UPDATE blinkit
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;
SELECT DISTINCT(Item_Fat_Content) FROM blinkit;

-- A. KPI's 

-- 1. Total_Sales
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10, 2)) AS Total_Sales_Millions
FROM blinkit;
SELECT SUM(Sales) FROM blinkit
WHERE Item_Fat_Content = "Low Fat";

-- 2. Avg_Sales
SELECT CAST(AVG(Sales) AS DECIMAL(10, 2)) AS Total_Sales_Avg
FROM blinkit;

-- 3. No_of_Items
SELECT COUNT(*) AS No_of_Item FROM blinkit
WHERE Outlet_Establishment_Year = 2022;

-- 4. Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit;

-- 5. Total_Sales by Item_Fat_Content
SELECT Item_Fat_Content, 
			CAST(SUM(Sales)/1000 AS DECIMAL(10, 2)) AS Total_Sales_Thousands,
            CAST(AVG(Sales) AS DECIMAL(10, 2)) AS Total_Sales_Avg,
            COUNT(*) AS No_of_Item,
            CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit
-- WHERE Outlet_Establishment_Year = 2022
GROUP BY Item_Fat_Content;

-- 6. Total_Sales by Item_Type
SELECT Item_Type, 
			CAST(SUM(Sales)/1000 AS DECIMAL(10, 2)) AS Total_Sales_Thousands,
            CAST(AVG(Sales) AS DECIMAL(10, 2)) AS Total_Sales_Avg,
            COUNT(*) AS No_of_Item,
            CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit
GROUP BY Item_Type
Limit 5;

-- 7. Fat Content by Outlet by Total_Sales
SELECT Outlet_Location_Type, Item_Fat_Content, 
			CAST(SUM(Sales)/1000000 AS DECIMAL(10, 2)) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Location_Type, Item_Fat_Content;

SELECT 
    Outlet_Location_Type,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales ELSE 0 END), 2) AS Low_Fat,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales ELSE 0 END), 2) AS Regular
FROM (
    SELECT 
        Outlet_Location_Type, 
        Item_Fat_Content, 
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;







