-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 06_indexes.sql
-- Performance Indexes
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- Foreign Key Indexes
-- ==========================================================

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_payments_order
ON payments(order_id);

CREATE INDEX idx_reviews_order
ON reviews(order_id);

CREATE INDEX idx_order_items_order
ON order_items(order_id);

CREATE INDEX idx_order_items_seller
ON order_items(seller_id);

CREATE INDEX idx_order_items_product
ON order_items(product_id);

-- ==========================================================
-- Date Indexes
-- ==========================================================

CREATE INDEX idx_orders_purchase_date
ON orders(order_purchase_timestamp);

CREATE INDEX idx_orders_estimated_delivery
ON orders(order_estimated_delivery_date);

-- ==========================================================
-- Status & Analytics Indexes
-- ==========================================================

CREATE INDEX idx_orders_status
ON orders(order_status);

CREATE INDEX idx_orders_year
ON orders(order_year);

CREATE INDEX idx_orders_year_month
ON orders(order_year_month);

CREATE INDEX idx_orders_month
ON orders(order_month);

CREATE INDEX idx_reviews_score
ON reviews(review_score);

CREATE INDEX idx_payments_type
ON payments(payment_type);

CREATE INDEX idx_products_category
ON products(product_category_name);

CREATE INDEX idx_customers_state
ON customers(customer_state);

CREATE INDEX idx_customers_city
ON customers(customer_city);

CREATE INDEX idx_sellers_state
ON sellers(seller_state);

CREATE INDEX idx_geolocation_zip
ON geolocation(geolocation_zip_code_prefix);