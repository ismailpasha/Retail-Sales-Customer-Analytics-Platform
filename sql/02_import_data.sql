-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 02_import_data.sql
-- Import CSV Files into PostgreSQL
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- CUSTOMERS
-- ==========================================================

COPY customers
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/customers_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- ORDERS
-- ==========================================================

COPY orders
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/orders_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- ORDER ITEMS
-- ==========================================================

COPY order_items
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/order_items_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- PRODUCTS
-- ==========================================================

COPY products
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/products_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- PAYMENTS
-- ==========================================================

COPY payments
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/payments_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- REVIEWS
-- ==========================================================

COPY reviews
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/reviews_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- SELLERS
-- ==========================================================

COPY sellers
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/sellers_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- GEOLOCATION
-- ==========================================================

COPY geolocation
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/geolocation_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- CATEGORY TRANSLATION
-- ==========================================================

COPY category_translation
FROM 'E:/Projects/Retail Sales & Customer Analytics Platform/data/cleaned/category_translation_clean.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);

-- ==========================================================
-- VERIFY IMPORT
-- ==========================================================

SELECT 'customers' AS table_name, COUNT(*) AS rows FROM customers
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