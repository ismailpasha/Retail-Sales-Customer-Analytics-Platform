-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 05_check_constraints.sql
-- Add Check Constraints
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- PAYMENTS
-- ==========================================================

ALTER TABLE payments
ADD CONSTRAINT chk_payment_value
CHECK (payment_value >= 0);

ALTER TABLE payments
ADD CONSTRAINT chk_payment_installments
CHECK (payment_installments >= 0);

-- ==========================================================
-- REVIEWS
-- ==========================================================

ALTER TABLE reviews
ADD CONSTRAINT chk_review_score
CHECK (review_score BETWEEN 1 AND 5);

-- ==========================================================
-- ORDER ITEMS
-- ==========================================================

ALTER TABLE order_items
ADD CONSTRAINT chk_price
CHECK (price >= 0);

ALTER TABLE order_items
ADD CONSTRAINT chk_freight_value
CHECK (freight_value >= 0);

ALTER TABLE order_items
ADD CONSTRAINT chk_total_item_cost
CHECK (total_item_cost >= 0);

ALTER TABLE order_items
ADD CONSTRAINT chk_freight_percentage
CHECK (freight_percentage >= 0);

-- ==========================================================
-- PRODUCTS
-- ==========================================================

ALTER TABLE products
ADD CONSTRAINT chk_product_weight
CHECK (product_weight_g >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_product_length
CHECK (product_length_cm >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_product_height
CHECK (product_height_cm >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_product_width
CHECK (product_width_cm >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_product_volume
CHECK (product_volume_cm3 >= 0);

-- ==========================================================
-- ORDERS
-- ==========================================================

ALTER TABLE orders
ADD CONSTRAINT chk_delivery_time
CHECK (
    delivery_time_days IS NULL
    OR delivery_time_days >= 0
);

ALTER TABLE orders
ADD CONSTRAINT chk_approval_time
CHECK (
    approval_time_hours IS NULL
    OR approval_time_hours >= 0
);

ALTER TABLE orders
ADD CONSTRAINT chk_order_quarter
CHECK (order_quarter BETWEEN 1 AND 4);

ALTER TABLE orders
ADD CONSTRAINT chk_is_delayed
CHECK (is_delayed IN ('Yes','No'));