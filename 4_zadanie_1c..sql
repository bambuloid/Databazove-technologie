--1
CREATE DATABASE retail

CREATE TABLE retail_sales (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description TEXT,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price DECIMAL(10,2),
    customer_id INT,
    country VARCHAR(100)
)

SELECT * FROM retail_sales

--2
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    quantity,
    unit_price,
    quantity * unit_price AS revenue,
    SUM(quantity * unit_price) OVER (
        PARTITION BY customer_id
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '14 days' PRECEDING
                  AND CURRENT ROW
    ) AS revenue_last_14_days
FROM retail_sales
WHERE customer_id IS NOT NULL
ORDER BY customer_id, invoice_date;

--3
SELECT
    stock_code,
    country,
    invoice_date,
    quantity,
    ROUND(AVG(quantity) OVER (
        PARTITION BY stock_code, country
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '7 days' PRECEDING
            AND CURRENT ROW
    ), 2) AS avg_quantity_7_days FROM retail_sales

--4
WITH objednavky AS (
    SELECT DISTINCT
        customer_id,
        invoice_no,
        invoice_date
    FROM retail_sales
    WHERE customer_id IS NOT NULL
),
tabulka AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,
        LEAD(invoice_date) OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date
        ) AS next_invoice_date
    FROM objednavky
)
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    next_invoice_date,
    next_invoice_date - invoice_date AS days_to_next_invoice
FROM tabulka
WHERE next_invoice_date IS NOT NULL
ORDER BY days_to_next_invoice DESC;

--5
WITH tabulka AS (
SELECT 
    stock_code,
    invoice_no,
    invoice_date,
    LAG(unit_price) OVER (
        PARTITION BY stock_code
        ORDER BY invoice_date, invoice_no
    ) AS previous_price,
    unit_price AS current_price
FROM retail_sales
)
SELECT
    *,
    current_price - previous_price AS price_difference
FROM tabulka
WHERE previous_price - current_price IS NOT NULL AND previous_price - current_price <> 0.00
ORDER BY invoice_date ASC

--6
WITH tabulka AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    *,
    NTILE(4) OVER (
        ORDER BY total_amount DESC
    ) AS sales_quartile
FROM tabulka
ORDER BY total_amount DESC

--7
WITH tabulka AS (
    SELECT
     country,
     EXTRACT(MONTH FROM invoice_date) AS month,
     SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY country, month
)
SELECT
 *,
 NTILE(4) OVER (
    PARTITION BY country
    ORDER BY total_amount ASC
 ) AS sales_quartile FROM tabulka

--8

WITH tabulka AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,
        stock_code,
        description,
        quantity,
        unit_price,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date ASC
        ) AS poradie
    FROM retail_sales
    WHERE customer_id IS NOT NULL
)
SELECT
    *
FROM tabulka
WHERE poradie = 1
ORDER BY customer_id ASC;

--9

WITH tabulka AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        quantity * unit_price AS amount,
        ROW_NUMBER() OVER (
            PARTITION BY invoice_no
            ORDER BY quantity * unit_price DESC
        ) AS row_num
    FROM retail_sales
)
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    amount,
    row_num
FROM tabulka
WHERE row_num <= 3
ORDER BY invoice_no, row_num;

--10
WITH tabulka AS (
    SELECT
        country,
        DATE_TRUNC('month', invoice_date) AS month,
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY country, month, customer_id
),
ranking AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY country, month
            ORDER BY total_amount DESC
        ) AS sales_rank
    FROM tabulka
)
SELECT *
FROM ranking
WHERE sales_rank <= 5
ORDER BY country, month, sales_rank, customer_id;

--11

WITH tabulka AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        DENSE_RANK() OVER (
            PARTITION BY invoice_no
            ORDER BY unit_price DESC
        ) AS price_rank
    FROM retail_sales
),
ranking AS (
    SELECT *
    FROM tabulka
    WHERE price_rank <= 5
)
SELECT *
FROM ranking
ORDER BY invoice_no, price_rank, stock_code;
