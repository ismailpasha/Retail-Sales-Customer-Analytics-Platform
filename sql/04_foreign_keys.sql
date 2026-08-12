-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 04_foreign_keys.sql
-- Add Foreign Keys
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- ORDERS -> CUSTOMERS
-- ==========================================================

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- ==========================================================
-- PAYMENTS -> ORDERS
-- ==========================================================

ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- ==========================================================
-- REVIEWS -> ORDERS
-- ==========================================================

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- ==========================================================
-- ORDER ITEMS -> ORDERS
-- ==========================================================

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- ==========================================================
-- ORDER ITEMS -> SELLERS
-- ==========================================================

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

-- ==========================================================
-- IMPORTANT NOTE
-- ==========================================================
-- We intentionally DO NOT create:
--
-- order_items.product_id -> products.product_id
--
-- Reason:
-- The dataset contains 18 product IDs in order_items that
-- do not exist in the products table.
--
-- This is a known data-quality issue in the Olist dataset.
-- Omitting this FK preserves the complete original dataset.
-- ==========================================================