-- ==========================================================
-- Retail Sales & Customer Analytics Platform
-- 10_advanced_business_queries.sql
-- Queries 51–60
-- Advanced Window Functions
-- ==========================================================

SET search_path TO analytics;

-- ==========================================================
-- Query 51
-- Monthly Revenue Running Total
-- ==========================================================

WITH monthly_sales AS
(
SELECT
DATE_TRUNC('month',order_purchase_timestamp) AS month,
SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY 1
)

SELECT
month,
ROUND(revenue::NUMERIC,2) AS revenue,

ROUND(
SUM(revenue)
OVER(
ORDER BY month
)::NUMERIC,2
) AS running_total

FROM monthly_sales
ORDER BY month;

-- ==========================================================
-- Query 52
-- Month over Month Growth %
-- ==========================================================

SELECT
    month,

    ROUND(revenue::NUMERIC, 2) AS revenue,

    ROUND(
        LAG(revenue) OVER (ORDER BY month)::NUMERIC,
        2
    ) AS previous_month,

    ROUND(
        (
            (
                revenue -
                LAG(revenue) OVER (ORDER BY month)
            )
            /
            NULLIF(LAG(revenue) OVER (ORDER BY month), 0)
            * 100
        )::NUMERIC,
        2
    ) AS growth_percent

FROM monthly_sales
ORDER BY month;
-- ==========================================================
-- Query 53
-- 3 Month Moving Average
-- ==========================================================

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
)

SELECT
    month,
    ROUND(revenue::NUMERIC, 2) AS revenue,

    ROUND(
        AVG(revenue)
        OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )::NUMERIC,
        2
    ) AS moving_average

FROM monthly_sales
ORDER BY month;

-- ==========================================================
-- Query 54
-- Top Customer per State
-- ==========================================================

WITH customer_sales AS
(
SELECT

customer_state,

o.customer_id,

SUM(price) revenue

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN order_items oi
ON oi.order_id=o.order_id

GROUP BY

customer_state,
o.customer_id
)

SELECT *

FROM

(

SELECT

*,

ROW_NUMBER()

OVER(

PARTITION BY customer_state

ORDER BY revenue DESC

) rn

FROM customer_sales

)t

WHERE rn=1;

-- ==========================================================
-- Query 55
-- Top Seller per State
-- ==========================================================

WITH seller_sales AS
(
SELECT

seller_state,

seller_id,

SUM(price) revenue

FROM sellers s

JOIN order_items oi
ON s.seller_id=oi.seller_id

GROUP BY

seller_state,
seller_id
)

SELECT *

FROM

(

SELECT

*,

ROW_NUMBER()

OVER(

PARTITION BY seller_state

ORDER BY revenue DESC

) rn

FROM seller_sales

)t

WHERE rn=1;

-- ==========================================================
-- Query 56
-- Revenue Quartiles
-- ==========================================================

SELECT

seller_id,

SUM(price) revenue,

NTILE(4)

OVER(

ORDER BY SUM(price)

) revenue_quartile

FROM order_items

GROUP BY seller_id;

-- ==========================================================
-- Query 57
-- Highest Order Value per Customer
-- ==========================================================

SELECT

customer_id,

MAX(order_value) highest_order

FROM

(

SELECT

o.customer_id,

oi.order_id,

SUM(price) order_value

FROM orders o

JOIN order_items oi
ON o.order_id=oi.order_id

GROUP BY

o.customer_id,
oi.order_id

)t

GROUP BY customer_id;

-- ==========================================================
-- Query 58
-- Revenue Contribution %
-- ==========================================================

SELECT

product_category_name,

ROUND(SUM(price)::NUMERIC,2) revenue,

ROUND(

SUM(price)

/

SUM(SUM(price))
OVER()

*100

,2

) contribution_percent

FROM products p

JOIN order_items oi
ON p.product_id=oi.product_id

GROUP BY product_category_name

ORDER BY revenue DESC;

-- ==========================================================
-- Query 59
-- Seller Rank using Dense Rank
-- ==========================================================

SELECT

seller_id,

ROUND(SUM(price)::NUMERIC,2) revenue,

DENSE_RANK()

OVER(

ORDER BY SUM(price) DESC

) seller_rank

FROM order_items

GROUP BY seller_id;

-- ==========================================================
-- Query 60
-- Monthly Revenue Difference
-- ==========================================================

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    month,
    ROUND(revenue::NUMERIC, 2) AS revenue,

    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY month)
        )::NUMERIC,
        2
    ) AS revenue_difference

FROM monthly_sales
ORDER BY month;