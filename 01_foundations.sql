-- ===============================================================================
-- BIGBASKET CAPSTONE DIAGNOSTIC - FOUNDATIONAL SQL QUERIES (01_foundations.sql)
-- ===============================================================================

-- 1. SELECT / WHERE: Orders placed by customers residing in a specific city ('Bengaluru')
SELECT 
    o.order_id, 
    o.customer_id, 
    c.name AS customer_name,
    c.city, 
    o.amount_inr, 
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.city = 'Bengaluru'
ORDER BY o.order_id;

-- 2. DISTINCT: List every distinct product category stocked by BigBasket
SELECT DISTINCT category
FROM products
ORDER BY category;

-- 3. ORDER BY + LIMIT: Identify the top 5 highest-value orders by amount_inr
SELECT 
    order_id, 
    customer_id, 
    product_id, 
    amount_inr, 
    order_date,
    status
FROM orders
ORDER BY amount_inr DESC
LIMIT 5;

-- 4. ALIAS (AS): Rename aggregates and columns for clean reporting
SELECT 
    status, 
    COUNT(*) AS total_orders, 
    SUM(amount_inr) AS gross_revenue_inr,
    AVG(amount_inr) AS avg_order_value_inr
FROM orders
GROUP BY status;

-- 5. IN: Filter orders whose payment_mode is in a designated 2-mode list ('UPI', 'Credit Card')
SELECT 
    order_id, 
    customer_id,
    amount_inr, 
    payment_mode, 
    status
FROM orders
WHERE payment_mode IN ('UPI', 'Credit Card')
ORDER BY order_id;

-- 6. BETWEEN / NOT BETWEEN: Filter orders by order value ranges
-- 6a. Orders with amount_inr BETWEEN 200 and 500 (inclusive)
SELECT 
    order_id, 
    amount_inr, 
    payment_mode, 
    status
FROM orders
WHERE amount_inr BETWEEN 200 AND 500
ORDER BY amount_inr DESC;

-- 6b. Orders with amount_inr NOT BETWEEN 200 and 500
SELECT 
    order_id, 
    amount_inr, 
    payment_mode, 
    status
FROM orders
WHERE amount_inr NOT BETWEEN 200 AND 500
ORDER BY amount_inr DESC;

-- 7. IS NULL: Identify orders with no rating recorded (Cancelled and Pending orders)
SELECT 
    order_id, 
    customer_id,
    status, 
    rating, 
    amount_inr
FROM orders
WHERE rating IS NULL
ORDER BY status, order_id;
