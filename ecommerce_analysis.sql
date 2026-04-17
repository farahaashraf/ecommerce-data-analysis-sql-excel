-- ============================================================
-- E-Commerce Sales Analysis
-- Dataset: Online Retail (Kaggle) | ~525K rows after cleaning
-- Author: Farah Ashraf
-- ============================================================
-- NOTE: IsProduct = 1 excludes non-product stock codes
-- (e.g. POST, BANK CHARGES, DOT) from all revenue queries.
-- ============================================================


-- ============================================================
-- 1. REVENUE KPIs
-- ============================================================

-- Total product revenue
SELECT SUM(TotalPrice) AS total_revenue
FROM ecommerce
WHERE IsProduct = 1;

-- Product vs. non-product revenue breakdown
SELECT 
    CASE WHEN IsProduct = 1 THEN 'Product' ELSE 'Non-Product' END AS revenue_type,
    SUM(TotalPrice) AS revenue
FROM ecommerce
GROUP BY CASE WHEN IsProduct = 1 THEN 'Product' ELSE 'Non-Product' END;

-- Monthly revenue trend — detect growth and seasonality
-- Finding: Revenue peaked at £1.45M in Nov 2011, lowest in Feb 2011 (£508K)
SELECT 
    Year, 
    Month,
    SUM(TotalPrice) AS total_revenue
FROM ecommerce
WHERE IsProduct = 1
GROUP BY Year, Month
ORDER BY Year, Month;

-- Average order value (revenue per invoice)
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT InvoiceNo, SUM(TotalPrice) AS order_total
    FROM ecommerce
    WHERE IsProduct = 1
    GROUP BY InvoiceNo
) sub;


-- ============================================================
-- 2. MARKET ANALYSIS
-- ============================================================

-- Revenue by country — top and underperforming markets
-- Finding: UK = £8.7M (83% of total), Netherlands #2 at £284K
SELECT 
    Country,
    SUM(TotalPrice) AS revenue
FROM ecommerce
WHERE IsProduct = 1
GROUP BY Country
ORDER BY revenue DESC;

-- UK vs. rest of world split
SELECT 
    CASE WHEN Country = 'United Kingdom' THEN 'UK' ELSE 'Rest of World' END AS market,
    SUM(TotalPrice) AS revenue
FROM ecommerce
WHERE IsProduct = 1
GROUP BY CASE WHEN Country = 'United Kingdom' THEN 'UK' ELSE 'Rest of World' END;

-- Revenue by country and month — regional seasonality
SELECT 
    Year, 
    Month, 
    Country, 
    SUM(TotalPrice) AS revenue
FROM ecommerce
WHERE IsProduct = 1
GROUP BY Year, Month, Country
ORDER BY Year, Month, revenue DESC;


-- ============================================================
-- 3. CUSTOMER KPIs
-- ============================================================

-- Total unique customers (includes "Unknown" guest buyers)
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM ecommerce;

-- Top 10 customers by lifetime value (total spend)
-- Finding: Customer 14646 spent £279K; top 10 combined = £1.46M
SELECT TOP 10
    CustomerID, 
    SUM(TotalPrice) AS clv
FROM ecommerce
WHERE IsProduct = 1
GROUP BY CustomerID
ORDER BY clv DESC;

-- Repeat customers — bought more than once
SELECT COUNT(*) AS repeat_customer_count
FROM (
    SELECT CustomerID
    FROM ecommerce
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) > 1
) sub;

-- Repeat purchase rate (% of customers who came back)
SELECT 
    ROUND(
        100.0 * COUNT(CASE WHEN order_count > 1 THEN 1 END) / COUNT(*), 2
    ) AS repeat_rate_pct
FROM (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS order_count
    FROM ecommerce
    GROUP BY CustomerID
) sub;


-- ============================================================
-- 4. PRODUCT KPIs
-- ============================================================

-- Top 10 products by revenue
SELECT TOP 10
    Description, 
    SUM(TotalPrice) AS revenue
FROM ecommerce
WHERE IsProduct = 1
GROUP BY Description
ORDER BY revenue DESC;

-- Top 10 products by quantity sold
SELECT TOP 10
    Description, 
    SUM(Quantity) AS total_quantity
FROM ecommerce
WHERE IsProduct = 1
GROUP BY Description
ORDER BY total_quantity DESC;


-- ============================================================
-- 5. ORDER & TRANSACTION KPIs
-- ============================================================

-- Total number of orders (distinct invoices)
SELECT COUNT(DISTINCT InvoiceNo) AS total_orders
FROM ecommerce;

-- Average number of items per order
SELECT AVG(item_count) AS avg_items_per_order
FROM (
    SELECT InvoiceNo, SUM(Quantity) AS item_count
    FROM ecommerce
    WHERE IsProduct = 1
    GROUP BY InvoiceNo
) sub;

-- Order volume per month — compare with revenue to identify growth driver
-- Finding: Growth tracks order volume (Nov = 2,751 orders vs Feb = 1,093)
SELECT 
    Year, 
    Month, 
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM ecommerce
WHERE IsProduct = 1
GROUP BY Year, Month
ORDER BY Year, Month;
