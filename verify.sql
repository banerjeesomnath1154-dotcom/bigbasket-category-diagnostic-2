/*
===============================================================================
BIGBASKET CAPSTONE DIAGNOSTIC - VERIFICATION SCRIPT (verify.sql)
===============================================================================
Verification Results for bigbasket_capstone.db (Generated with random.seed(42)):

1. Table Row Counts:
   - products:         31
   - customers:        50
   - orders:           500
   - category_targets: 6

2. Orders Status Breakdown:
   - Delivered: 434
   - Cancelled: 42
   - Pending:   24
===============================================================================
*/

-- Count check for products table (Expected: 31)
SELECT COUNT(*) AS products_count FROM products;

-- Count check for customers table (Expected: 50)
SELECT COUNT(*) AS customers_count FROM customers;

-- Count check for orders table (Expected: 500)
SELECT COUNT(*) AS orders_count FROM orders;

-- Count check for category_targets table (Expected: 6)
SELECT COUNT(*) AS category_targets_count FROM category_targets;

-- Status breakdown for orders table (Expected: Delivered: 434, Cancelled: 42, Pending: 24)
SELECT status, COUNT(*) AS status_count
FROM orders
GROUP BY status
ORDER BY status;
