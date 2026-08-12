-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 07_views.sql
-- Analytics Views
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- SALES ANALYTICS VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_sales AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_status,
    o.order_year,
    o.order_month,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    oi.total_item_cost,
    p.product_category_name
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN products p
ON oi.product_id = p.product_id;

-- ==========================================================
-- CUSTOMER ANALYTICS VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_customers AS
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- ==========================================================
-- PAYMENT ANALYTICS VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_payments AS
SELECT
    p.order_id,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    o.order_purchase_timestamp,
    o.order_status
FROM payments p
JOIN orders o
ON p.order_id = o.order_id;

-- ==========================================================
-- DELIVERY ANALYTICS VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_delivery AS
SELECT
    order_id,
    order_status,
    delivery_time_days,
    delivery_delay_days,
    estimated_vs_actual_delivery,
    delivery_status,
    is_delayed
FROM orders;

-- ==========================================================
-- REVIEW ANALYTICS VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_reviews AS
SELECT
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_category,
    o.order_purchase_timestamp
FROM reviews r
JOIN orders o
ON r.order_id = o.order_id;

-- ==========================================================
-- SELLER PERFORMANCE VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_seller_sales AS
SELECT
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_sales,
    AVG(oi.price) AS avg_sale
FROM order_items oi
JOIN sellers s
ON oi.seller_id = s.seller_id
GROUP BY
    oi.seller_id,
    s.seller_city,
    s.seller_state;

-- ==========================================================
-- PRODUCT PERFORMANCE VIEW
-- ==========================================================

CREATE OR REPLACE VIEW vw_product_sales AS
SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(*) AS units_sold,
    SUM(oi.price) AS revenue,
    AVG(oi.price) AS average_price
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY
    oi.product_id,
    p.product_category_name;