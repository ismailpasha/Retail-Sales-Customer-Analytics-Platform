-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 09_business_queries.sql
-- Part 1: Basic Business Queries
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- Query 1
-- Total Customers
-- ==========================================================

SELECT COUNT(*) AS total_customers
FROM customers;

-- ==========================================================
-- Query 2
-- Total Orders
-- ==========================================================

SELECT COUNT(*) AS total_orders
FROM orders;

-- ==========================================================
-- Query 3
-- Total Products
-- ==========================================================

SELECT COUNT(*) AS total_products
FROM products;

-- ==========================================================
-- Query 4
-- Total Sellers
-- ==========================================================

SELECT COUNT(*) AS total_sellers
FROM sellers;

-- ==========================================================
-- Query 5
-- Total Revenue
-- ==========================================================

SELECT
ROUND(SUM(price)::NUMERIC, 2) AS total_revenue
FROM order_items;

-- ==========================================================
-- Query 6
-- Average Order Value
-- ==========================================================

SELECT
ROUND(AVG(total_item_cost)::NUMERIC, 2) AS average_order_value
FROM order_items;

-- ==========================================================
-- Query 7
-- Total Freight Charges
-- ==========================================================

SELECT
ROUND(SUM(freight_value)::NUMERIC, 2) AS total_freight
FROM order_items;

-- ==========================================================
-- Query 8
-- Revenue by Order Status
-- ==========================================================

SELECT
    o.order_status,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;

-- ==========================================================
-- Query 9
-- Number of Orders by Status
-- ==========================================================

SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ==========================================================
-- Query 10
-- Monthly Revenue
-- ==========================================================

SELECT
    order_year,
    order_month,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    order_year,
    order_month
ORDER BY
    order_year,
    MIN(order_purchase_timestamp);



-- ==========================================================
-- Queries 11–20 : Customer Analytics
-- ==========================================================

-- ==========================================================
-- Query 11
-- Customers by State
-- ==========================================================

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;


-- ==========================================================
-- Query 12
-- Top 10 Customer Cities
-- ==========================================================

SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;


-- ==========================================================
-- Query 13
-- Revenue by Customer State
-- ==========================================================

SELECT
    c.customer_state,
    ROUND(SUM(oi.price)::NUMERIC,2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;


-- ==========================================================
-- Query 14
-- Top 10 Customer Cities by Revenue
-- ==========================================================

SELECT
    c.customer_city,
    ROUND(SUM(oi.price)::NUMERIC,2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;


-- ==========================================================
-- Query 15
-- Top 10 Customers by Spending
-- ==========================================================

SELECT
    c.customer_id,
    ROUND(SUM(oi.price)::NUMERIC,2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- ==========================================================
-- Query 16
-- Repeat Customers
-- ==========================================================

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;


-- ==========================================================
-- Query 17
-- Average Orders per Customer
-- ==========================================================

SELECT
    ROUND(AVG(order_count)::NUMERIC,2) AS avg_orders_per_customer
FROM
(
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) t;


-- ==========================================================
-- Query 18
-- Customer Lifetime Value (Top 10)
-- ==========================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price)::NUMERIC,2) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC
LIMIT 10;


-- ==========================================================
-- Query 19
-- New Customers by Year
-- ==========================================================

SELECT
    o.order_year,
    COUNT(DISTINCT o.customer_id) AS new_customers
FROM orders o
GROUP BY o.order_year
ORDER BY o.order_year;


-- ==========================================================
-- Query 20
-- Customer Distribution by State
-- ==========================================================

SELECT
    customer_state,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;	



-- ==========================================================
-- Queries 21–30 : Product & Seller Analytics
-- ==========================================================

-- ==========================================================
-- Query 21
-- Top 10 Best-Selling Products
-- ==========================================================

SELECT
    product_id,
    COUNT(*) AS units_sold
FROM order_items
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 10;


-- ==========================================================
-- Query 22
-- Top 10 Revenue-Generating Products
-- ==========================================================

SELECT
    oi.product_id,
    ROUND(SUM(oi.price)::NUMERIC,2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;


-- ==========================================================
-- Query 23
-- Top Product Categories by Units Sold
-- ==========================================================

SELECT
    COALESCE(p.product_category_name,'Unknown') AS category,
    COUNT(*) AS units_sold
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY category
ORDER BY units_sold DESC
LIMIT 10;


-- ==========================================================
-- Query 24
-- Revenue by Product Category
-- ==========================================================

SELECT
    COALESCE(p.product_category_name,'Unknown') AS category,
    ROUND(SUM(oi.price)::NUMERIC,2) AS revenue
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY category
ORDER BY revenue DESC;


-- ==========================================================
-- Query 25
-- Average Product Price by Category
-- ==========================================================

SELECT
    COALESCE(p.product_category_name,'Unknown') AS category,
    ROUND(AVG(oi.price)::NUMERIC,2) AS average_price
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY category
ORDER BY average_price DESC;


-- ==========================================================
-- Query 26
-- Top 10 Sellers by Revenue
-- ==========================================================

SELECT
    seller_id,
    ROUND(SUM(price)::NUMERIC,2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;


-- ==========================================================
-- Query 27
-- Top 10 Sellers by Orders
-- ==========================================================

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 10;


-- ==========================================================
-- Query 28
-- Revenue by Seller State
-- ==========================================================

SELECT
    s.seller_state,
    ROUND(SUM(oi.price)::NUMERIC,2) AS revenue
FROM sellers s
JOIN order_items oi
ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY revenue DESC;


-- ==========================================================
-- Query 29
-- Average Revenue per Seller
-- ==========================================================

SELECT
    ROUND(AVG(seller_revenue)::NUMERIC,2) AS avg_revenue_per_seller
FROM
(
    SELECT
        seller_id,
        SUM(price) AS seller_revenue
    FROM order_items
    GROUP BY seller_id
) t;


-- ==========================================================
-- Query 30
-- Seller Performance Ranking
-- ==========================================================

SELECT
    seller_id,
    ROUND(SUM(price)::NUMERIC,2) AS revenue,
    RANK() OVER (
        ORDER BY SUM(price) DESC
    ) AS seller_rank
FROM order_items
GROUP BY seller_id
ORDER BY seller_rank
LIMIT 20;



-- ==========================================================
-- Queries 31–40 : Delivery, Reviews & Payments
-- ==========================================================

-- ==========================================================
-- Query 31
-- Average Delivery Time (Days)
-- ==========================================================

SELECT
    ROUND(AVG(delivery_time_days)::NUMERIC,2) AS avg_delivery_days
FROM orders
WHERE delivery_time_days IS NOT NULL;


-- ==========================================================
-- Query 32
-- Average Delivery Delay (Days)
-- ==========================================================

SELECT
    ROUND(AVG(delivery_delay_days)::NUMERIC,2) AS avg_delay_days
FROM orders
WHERE delivery_delay_days IS NOT NULL;


-- ==========================================================
-- Query 33
-- On-Time vs Late Deliveries
-- ==========================================================

SELECT
    is_delayed,
    COUNT(*) AS total_orders
FROM orders
GROUP BY is_delayed
ORDER BY total_orders DESC;


-- ==========================================================
-- Query 34
-- Delivery Status Distribution
-- ==========================================================

SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY delivery_status
ORDER BY total_orders DESC;


-- ==========================================================
-- Query 35
-- Review Score Distribution
-- ==========================================================

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;


-- ==========================================================
-- Query 36
-- Average Review Score
-- ==========================================================

SELECT
    ROUND(AVG(review_score)::NUMERIC,2) AS average_review_score
FROM reviews;


-- ==========================================================
-- Query 37
-- Revenue by Payment Type
-- ==========================================================

SELECT
    payment_type,
    ROUND(SUM(payment_value)::NUMERIC,2) AS revenue
FROM payments
GROUP BY payment_type
ORDER BY revenue DESC;


-- ==========================================================
-- Query 38
-- Payment Type Distribution
-- ==========================================================

SELECT
    payment_type,
    COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;


-- ==========================================================
-- Query 39
-- Average Installments by Payment Type
-- ==========================================================

SELECT
    payment_type,
    ROUND(AVG(payment_installments)::NUMERIC,2) AS avg_installments
FROM payments
GROUP BY payment_type
ORDER BY avg_installments DESC;


-- ==========================================================
-- Query 40
-- Average Order Value by Payment Type
-- ==========================================================

SELECT
    payment_type,
    ROUND(AVG(payment_value)::NUMERIC,2) AS avg_order_value
FROM payments
GROUP BY payment_type
ORDER BY avg_order_value DESC;

-- ==========================================================
-- Query 41
-- Monthly Order Volume
-- ==========================================================

SET search_path TO analytics;

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY
    DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY
    month;
-- ==========================================================
-- Query 42
-- Monthly Average Order Value
-- ==========================================================

WITH order_values AS
(
    SELECT
        o.order_id,
        o.order_year,
        o.order_month,
        SUM(oi.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.order_year,
        o.order_month
)

SELECT
    order_year,
    order_month,
    ROUND(AVG(order_value)::NUMERIC, 2) AS average_order_value
FROM order_values
GROUP BY
    order_year,
    order_month
ORDER BY
    order_year,
    order_month;


-- ==========================================================
-- Query 43
-- Seller State Revenue Contribution
-- ==========================================================

SELECT
    s.seller_state,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue,
    ROUND(
        (
            SUM(oi.price)
            / SUM(SUM(oi.price)) OVER ()
            * 100
        )::NUMERIC,
        2
    ) AS revenue_contribution_percent
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_state
ORDER BY
    revenue DESC;


-- ==========================================================
-- Query 44
-- Top 10 Products by Revenue with Units Sold
-- ==========================================================

SELECT
    oi.product_id,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue,
    ROUND(AVG(oi.price)::NUMERIC, 2) AS average_price
FROM order_items oi
GROUP BY
    oi.product_id
ORDER BY
    revenue DESC
LIMIT 10;	


-- ==========================================================
-- Query 45
-- Product Category Revenue Contribution
-- ==========================================================

WITH category_sales AS
(
    SELECT
        COALESCE(
            p.product_category_name,
            'Unknown'
        ) AS category,
        SUM(oi.price) AS revenue
    FROM order_items oi
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        COALESCE(
            p.product_category_name,
            'Unknown'
        )
)

SELECT
    category,
    ROUND(revenue::NUMERIC, 2) AS revenue,
    ROUND(
        (
            revenue / SUM(revenue) OVER () * 100
        )::NUMERIC,
        2
    ) AS revenue_contribution_percent
FROM category_sales
ORDER BY
    revenue DESC
LIMIT 10;


-- ==========================================================
-- Query 46
-- Average Revenue per Customer by State
-- ==========================================================

SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue,
    ROUND(
        (
            SUM(oi.price)
            / COUNT(DISTINCT c.customer_id)
        )::NUMERIC,
        2
    ) AS revenue_per_customer
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_state
ORDER BY
    revenue_per_customer DESC;


-- ==========================================================
-- Query 47
-- Payment Type Revenue Contribution
-- ==========================================================

SELECT
    payment_type,
    ROUND(SUM(payment_value)::NUMERIC, 2) AS revenue,
    ROUND(
        (
            SUM(payment_value)
            / SUM(SUM(payment_value)) OVER ()
            * 100
        )::NUMERIC,
        2
    ) AS revenue_contribution_percent
FROM payments
GROUP BY
    payment_type
ORDER BY
    revenue DESC;	

-- ==========================================================
-- Query 48
-- Delivery Performance by Review Score
-- ==========================================================

SET search_path TO analytics;

SELECT
    r.review_score,
    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(
        DISTINCT CASE
            WHEN o.is_delayed = 'Yes'
            THEN o.order_id
        END
    ) AS delayed_orders,

    ROUND(
        (
            COUNT(
                DISTINCT CASE
                    WHEN o.is_delayed = 'Yes'
                    THEN o.order_id
                END
            ) * 100.0
            / NULLIF(COUNT(DISTINCT o.order_id), 0)
        )::NUMERIC,
        2
    ) AS delayed_order_percent

FROM orders o

JOIN reviews r
    ON o.order_id = r.order_id

GROUP BY
    r.review_score

ORDER BY
    r.review_score DESC;	


-- ==========================================================
-- Query 49
-- Cancelled Orders and Revenue Impact
-- ==========================================================

SELECT
    o.order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COALESCE(SUM(oi.price), 0)::NUMERIC,
        2
    ) AS associated_revenue
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_status
ORDER BY
    total_orders DESC;	


-- ==========================================================
-- Query 50
-- Top 10 Sellers Revenue Contribution
-- ==========================================================

WITH seller_sales AS
(
    SELECT
        seller_id,
        SUM(price) AS revenue
    FROM order_items
    GROUP BY
        seller_id
),

ranked_sellers AS
(
    SELECT
        seller_id,
        revenue,
        ROW_NUMBER() OVER (
            ORDER BY revenue DESC
        ) AS seller_rank
    FROM seller_sales
)

SELECT
    seller_rank,
    seller_id,
    ROUND(revenue::NUMERIC, 2) AS revenue,
    ROUND(
        (
            revenue
            / SUM(revenue) OVER ()
            * 100
        )::NUMERIC,
        2
    ) AS revenue_contribution_percent
FROM ranked_sellers
WHERE seller_rank <= 10
ORDER BY
    seller_rank;	