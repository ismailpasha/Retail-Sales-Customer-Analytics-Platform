-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 08_validation.sql
-- Database Validation Script
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- 1. ROW COUNTS
-- ==========================================================

SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation
ORDER BY table_name;

-- ==========================================================
-- 2. PRIMARY KEYS
-- ==========================================================

SELECT
    tc.table_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
WHERE tc.table_schema='analytics'
AND tc.constraint_type='PRIMARY KEY'
ORDER BY tc.table_name;

-- ==========================================================
-- 3. FOREIGN KEYS
-- ==========================================================

SELECT
    tc.table_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
WHERE tc.table_schema='analytics'
AND tc.constraint_type='FOREIGN KEY'
ORDER BY tc.table_name;

-- ==========================================================
-- 4. CHECK CONSTRAINTS
-- ==========================================================

SELECT
    tc.table_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
WHERE tc.table_schema='analytics'
AND tc.constraint_type='CHECK'
ORDER BY tc.table_name;

-- ==========================================================
-- 5. INDEXES
-- ==========================================================

SELECT
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname='analytics'
ORDER BY tablename,indexname;

-- ==========================================================
-- 6. VIEWS
-- ==========================================================

SELECT
    table_name
FROM information_schema.views
WHERE table_schema='analytics'
ORDER BY table_name;

-- ==========================================================
-- 7. ORPHAN PRODUCT CHECK
-- (Expected: 18 rows in this dataset)
-- ==========================================================

SELECT COUNT(*) AS orphan_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id=p.product_id
WHERE p.product_id IS NULL;