-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 01_create_schema_tables.sql
-- PostgreSQL 18
-- ==========================================================

DROP SCHEMA IF EXISTS analytics CASCADE;
CREATE SCHEMA analytics;

SET search_path TO analytics;

-- ==========================================================
-- CUSTOMERS
-- ==========================================================

CREATE TABLE customers (
    customer_id                 VARCHAR(50),
    customer_unique_id          VARCHAR(50),
    customer_zip_code_prefix    INTEGER,
    customer_city               VARCHAR(100),
    customer_state              CHAR(2)
);

-- ==========================================================
-- ORDERS
-- ==========================================================

CREATE TABLE orders (
    order_id                            VARCHAR(50),
    customer_id                         VARCHAR(50),
    order_status                        VARCHAR(20),
    order_purchase_timestamp            TIMESTAMP,
    order_approved_at                   TIMESTAMP,
    order_delivered_carrier_date        TIMESTAMP,
    order_delivered_customer_date       TIMESTAMP,
    order_estimated_delivery_date       DATE,

    order_year_month                    VARCHAR(7),
    order_day                           VARCHAR(15),
    order_month                         VARCHAR(15),

    delivery_time_days                  DOUBLE PRECISION,
    approval_time_hours                 DOUBLE PRECISION,
    delivery_delay_days                 DOUBLE PRECISION,
    estimated_vs_actual_delivery        DOUBLE PRECISION,

    order_year                          INTEGER,
    order_quarter                       SMALLINT,

    is_delayed                          VARCHAR(3),
    delivery_status                     VARCHAR(20)
);

-- ==========================================================
-- ORDER ITEMS
-- ==========================================================

CREATE TABLE order_items (
    order_id                    VARCHAR(50),
    order_item_id               INTEGER,
    product_id                  VARCHAR(50),
    seller_id                   VARCHAR(50),
    shipping_limit_date         TIMESTAMP,

    price                       DOUBLE PRECISION,
    freight_value               DOUBLE PRECISION,
    total_item_cost             DOUBLE PRECISION,
    freight_percentage          DOUBLE PRECISION
);

-- ==========================================================
-- PRODUCTS
-- ==========================================================

CREATE TABLE products (
    product_id                      VARCHAR(50),
    product_category_name           VARCHAR(100),

    product_name_lenght             DOUBLE PRECISION,
    product_description_lenght      DOUBLE PRECISION,
    product_photos_qty              DOUBLE PRECISION,

    product_weight_g                DOUBLE PRECISION,
    product_length_cm               DOUBLE PRECISION,
    product_height_cm               DOUBLE PRECISION,
    product_width_cm                DOUBLE PRECISION,
    product_volume_cm3              DOUBLE PRECISION
);

-- ==========================================================
-- PAYMENTS
-- ==========================================================

CREATE TABLE payments (
    order_id                    VARCHAR(50),
    payment_sequential          INTEGER,
    payment_type                VARCHAR(30),
    payment_installments        INTEGER,
    payment_value               DOUBLE PRECISION
);

-- ==========================================================
-- REVIEWS
-- ==========================================================

CREATE TABLE reviews (
    review_id                   VARCHAR(50),
    order_id                    VARCHAR(50),
    review_score                INTEGER,

    review_comment_title        TEXT,
    review_comment_message      TEXT,

    review_creation_date        TIMESTAMP,
    review_answer_timestamp     TIMESTAMP,

    review_category             VARCHAR(20)
);

-- ==========================================================
-- SELLERS
-- ==========================================================

CREATE TABLE sellers (
    seller_id                   VARCHAR(50),
    seller_zip_code_prefix      INTEGER,
    seller_city                 VARCHAR(100),
    seller_state                CHAR(2)
);

-- ==========================================================
-- GEOLOCATION
-- ==========================================================

CREATE TABLE geolocation (
    geolocation_zip_code_prefix     INTEGER,
    geolocation_lat                 DOUBLE PRECISION,
    geolocation_lng                 DOUBLE PRECISION,
    geolocation_city                VARCHAR(100),
    geolocation_state               CHAR(2)
);

-- ==========================================================
-- CATEGORY TRANSLATION
-- ==========================================================

CREATE TABLE category_translation (
    product_category_name           VARCHAR(100),
    product_category_name_english   VARCHAR(100)
);