--Adding dates
SELECT
       transaction_date AS purchase_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name,
       Dayofmonth(transaction_date) AS day_of_month,
CASE 
       WHEN Day_name IN ('Sun','Sat') THEN 'weekend'
       ELSE 'weekday'
END AS day_classification,

--Adding date_format(transaction_time,'HH:mm:ss') AS purchase_time.
CASE
       WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '05:00:00' AND '10:59:59' THEN '01. Morning'
       WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '11:00:00' AND '15:59:59' THEN '02. Afternoon'
       WHEN date_format(transaction_time, 'HH:mm:ss') >= '16:00:00' THEN '03. Evening'
END AS time_buckets,

--Adding Counts of IDS
       COUNT(DISTINCT transaction_id) AS Number_of_sales,
       COUNT(DISTINCT product_id) AS Number_of_products,
       COUNT(DISTINCT store_id) AS Number_of_stores,

---Adding Revenue
SUM(transaction_qty*unit_price) AS revenue_per_day,

CASE
    WHEN revenue_per_day <=50 THEN '01. Low Spend'
    WHEN revenue_per_day BETWEEN 51 AND 100 THEN '02. Med Spend'
    ELSE '03.High Spend'
END AS spend_bucket,

--Adding Categorical Columns
    store_location,
    product_category,
    product_detail
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1` 
GROUP BY 
       transaction_date,
       Dayname(transaction_date),
       Monthname(transaction_date),
       Dayofmonth(transaction_date),
CASE
       WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
       ELSE 'Weekday'
END,
CASE
       WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '05:00:00' AND '10:59:59' THEN '01. Morning'
       WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '11:00:00' AND '15:59:59' THEN '02. Afternoon'
       WHEN date_format(transaction_time, 'HH:mm:ss') >= '16:00:00' THEN '03. Evening'
END,
       store_location,
       product_category,
       product_detail;
