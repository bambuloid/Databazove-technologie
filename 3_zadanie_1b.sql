--1
WITH sales_cte AS (
    SELECT DATE_TRUNC('day', sales_date) AS sales_day, SUM(total_amount) AS daily_sales
    FROM flourmills_sale
    GROUP BY sales_day
)
SELECT * FROM sales_cte
WHERE daily_sales > 3000000
ORDER BY daily_sales DESC;

--2
WITH  category_sales AS (
    SELECT product_category, SUM(total_amount) AS cena FROM flourmills_sale
    GROUP BY product_category
)
SELECT * FROM category_sales
ORDER BY cena DESC

--3
with miau AS (
    SELECT product_category, product_name, COUNT(sales_id) total_product_sales FROM flourmills_sale
    GROUP BY product_category, product_name
), 
miau2 AS (
    SELECT *, RANK() OVER(
        PARTITION BY product_category
        ORDER BY total_product_sales
    ) AS category_rank FROM miau
)

SELECT * FROM miau2
WHERE category_rank IN (1,2,3)
ORDER BY product_category, category_rank

--4
with waf AS (
    SELECT customer_type, SUM(total_amount) revenue FROM flourmills_sale
    GROUP BY customer_type
),
waf2 AS (
    SELECT *, RANK() OVER(
        ORDER BY revenue 
    ) AS total_revenue,
        (revenue / (SUM(revenue) OVER()) * 100) AS revenue_percentage FROM waf
)
SELECT customer_type, revenue, total_revenue, revenue_percentage FROM waf2;

--5

WITH posledny_nakup AS (
    SELECT
        customer_id,
        product_name,
        sales_date,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sales_date DESC, sales_id DESC
        ) AS rn
    FROM flourmills_sale
)
SELECT
    customer_id,
    product_name,
    sales_date,
    total_amount
FROM posledny_nakup
WHERE rn = 1
ORDER BY customer_id ASC
LIMIT 5;

--6

WITH RECURSIVE
rozsah AS (
    SELECT
        MIN(sales_date)::DATE AS prvy,
        MAX(sales_date)::DATE AS posledny
    FROM flourmills_sale
),
kalendar AS (
    SELECT prvy AS datum
    FROM rozsah

    UNION ALL

    SELECT (datum + 1)::DATE
    FROM kalendar
    CROSS JOIN rozsah
    WHERE datum < posledny
)
SELECT COUNT(*)
FROM kalendar;


--7

WITH RECURSIVE monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', sales_date) AS month,
        SUM(total_amount) AS revenue
    FROM flourmills_sale
    GROUP BY DATE_TRUNC('month', sales_date)
),
ordered_months AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY month) AS rn,
        month,
        revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT
        rn,
        month,
        revenue,
        revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT
        next.rn,
        next.month,
        next.revenue,
        current.cumulative_revenue + next.revenue
    FROM cumulative_target AS current
    JOIN ordered_months AS next
        ON next.rn = current.rn + 1
    WHERE current.cumulative_revenue < 500000000
)
SELECT
    rn,
    month,
    revenue,
    cumulative_revenue
FROM cumulative_target
WHERE cumulative_revenue >= 500000000
ORDER BY rn
LIMIT 1;
