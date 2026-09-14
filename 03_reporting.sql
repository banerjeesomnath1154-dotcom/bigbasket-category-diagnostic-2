-- 03_reporting.sql
-- BigBasket Category Performance Diagnostic: Product Tiering, Monthly Business Reporting, and Target Variance Diagnostics

-- Query (a): Tier every product by its total Delivered revenue
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COALESCE(SUM(CASE WHEN o.status = 'Delivered' THEN o.amount_inr ELSE 0 END), 0) AS total_revenue,
    CASE 
        WHEN COALESCE(SUM(CASE WHEN o.status = 'Delivered' THEN o.amount_inr ELSE 0 END), 0) >= 3000 THEN 'High'
        WHEN COALESCE(SUM(CASE WHEN o.status = 'Delivered' THEN o.amount_inr ELSE 0 END), 0) >= 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_tier
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

-- Query (b): Monthly-by-category business report (Delivered orders only)
-- Serves as the query definition for monthly_category_revenue.csv
SELECT 
    p.category,
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(o.order_id) AS order_count,
    SUM(o.amount_inr) AS total_revenue,
    ROUND(AVG(o.amount_inr), 2) AS avg_revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category, month
ORDER BY p.category ASC, month ASC;

-- Query (c): Derived-fields query comparing category total revenue against monthly targets
WITH category_delivered AS (
    SELECT 
        p.category,
        SUM(o.amount_inr) AS total_revenue
    FROM orders o
    INNER JOIN products p ON o.product_id = p.product_id
    WHERE o.status = 'Delivered'
    GROUP BY p.category
)
SELECT 
    t.category,
    t.target_revenue_inr,
    COALESCE(cd.total_revenue, 0) AS total_revenue,
    (t.target_revenue_inr - COALESCE(cd.total_revenue, 0)) AS variance,
    ROUND(((COALESCE(cd.total_revenue, 0) - t.target_revenue_inr) * 100.0) / t.target_revenue_inr, 2) AS percentage_variance,
    CASE 
        WHEN COALESCE(cd.total_revenue, 0) >= t.target_revenue_inr THEN 'Above Target'
        WHEN ((COALESCE(cd.total_revenue, 0) - t.target_revenue_inr) * 100.0) / t.target_revenue_inr >= -15.0 THEN 'Below Target - Watch'
        ELSE 'Below Target - Critical'
    END AS target_status
FROM category_targets t
LEFT JOIN category_delivered cd ON t.category = cd.category
ORDER BY total_revenue DESC;
