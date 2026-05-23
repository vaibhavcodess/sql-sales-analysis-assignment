USE SuperstoreDB;

-- View first 5 rows
SELECT TOP 5 *
FROM Orders;

-- High sales orders
SELECT TOP 10 *
FROM Orders
WHERE Sales > 1000;

-- Loss making orders
SELECT TOP 10 *
FROM Orders
WHERE Profit < 0;

-- Total sales by category
SELECT Category, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Category;

-- Total sales by category sorted highest first
SELECT Category, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Category
ORDER BY TotalSales DESC;

-- Top 5 customers by sales
SELECT TOP 5 Customer_Name, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Customer_Name
ORDER BY TotalSales DESC;