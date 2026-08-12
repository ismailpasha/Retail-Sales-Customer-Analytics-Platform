-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 03_primary_keys.sql
-- Add Primary Keys
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- CUSTOMERS
-- ==========================================================

ALTER TABLE customers
ADD CONSTRAINT pk_customers
PRIMARY KEY (customer_id);

-- ==========================================================
-- ORDERS
-- ==========================================================

ALTER TABLE orders
ADD CONSTRAINT pk_orders
PRIMARY KEY (order_id);

-- ==========================================================
-- PRODUCTS
-- ==========================================================

ALTER TABLE products
ADD CONSTRAINT pk_products
PRIMARY KEY (product_id);

-- ==========================================================
-- PAYMENTS
-- ==========================================================

ALTER TABLE payments
ADD CONSTRAINT pk_payments
PRIMARY KEY (order_id, payment_sequential);

-- ==========================================================
-- REVIEWS
-- ==========================================================

ALTER TABLE reviews
ADD CONSTRAINT pk_reviews
PRIMARY KEY (review_id, order_id);

-- ==========================================================
-- SELLERS
-- ==========================================================

ALTER TABLE sellers
ADD CONSTRAINT pk_sellers
PRIMARY KEY (seller_id);

-- ==========================================================
-- ORDER ITEMS
-- ==========================================================

ALTER TABLE order_items
ADD CONSTRAINT pk_order_items
PRIMARY KEY (order_id, order_item_id);

-- ==========================================================
-- CATEGORY TRANSLATION
-- ==========================================================

ALTER TABLE category_translation
ADD CONSTRAINT pk_category_translation
PRIMARY KEY (product_category_name);

-- ==========================================================
-- GEOLOCATION
-- No primary key because duplicate latitude/longitude records
-- are expected in the source dataset.
--

SELECT review_id, COUNT(*) AS occurrences
FROM analytics.reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


SELECT
    tc.table_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'analytics'
ORDER BY tc.table_name;


SELECT review_id,
       order_id,
       COUNT(*) AS duplicate_count
FROM analytics.reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1;ALTER TABLE analytics.reviews
ADD CONSTRAINT pk_reviews
PRIMARY KEY (review_id, order_id);


SELECT
    tc.constraint_name,
    kcu.column_name,
    kcu.ordinal_position
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
ON tc.constraint_name = kcu.constraint_name
AND tc.table_schema = kcu.table_schema
WHERE tc.table_schema = 'analytics'
AND tc.table_name = 'reviews'
AND tc.constraint_type = 'PRIMARY KEY'
ORDER BY kcu.ordinal_position;