-- 02_aggregation_joins.sql
-- BigBasket Category Performance Diagnostic: Aggregations, Joins, and Filtering

-- Query (a): INNER JOIN of orders to products, GROUP BY category, computing COUNT, SUM(amount_inr) (aliased total_revenue), and AVG(amount_inr) for Delivered orders only, with HAVING total_revenue > 10000
SELECT 
    p.category,
    COUNT(o.order_id) AS order_count,
    SUM(o.amount_inr) AS total_revenue,
    ROUND(AVG(o.amount_inr), 2) AS avg_revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category
HAVING total_revenue > 10000
ORDER BY total_revenue DESC;

-- Query (b): LEFT JOIN of products to orders, GROUP BY product, counting total orders per product with COUNT(o.order_id) — not COUNT(*) — ordered ascending to surface the least-ordered products
-- Note: Premium Face Cream 50g has 0 orders and is preserved in output via LEFT JOIN
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COUNT(o.order_id) AS total_orders
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_orders ASC, p.product_name ASC;
