/*
Part 1: House Price Trends Over Time
Understanding how house prices fluctuate over time helps investors and policymakers predict market trends and investment opportunities.
The following should be investigated:
•	How have average house prices changed by year?
•	Are prices showing seasonal trends (e.g. higher sales in summer vs winter)?
SQL Queries:
•	Compute the average sale price per year.
•	Compute the average sale price per month.
•	Compute the average sale price per season (quarter).
*/

-- View data and decide which columns are of interest
SELECT *
FROM FACT_price_paid
LEFT OUTER JOIN DIM_date
ON FACT_price_paid.date_of_transfer_id = DIM_date.date_of_transfer_id
LIMIT 100;

/*
Salary Average
*/

-- Computes average sales price for each year
SELECT DIM_date.year,
       AVG(FACT_price_paid.price)
FROM FACT_price_paid
LEFT OUTER JOIN DIM_date
ON FACT_price_paid.date_of_transfer_id = DIM_date.date_of_transfer_id
GROUP BY DIM_date.year;

-- Computes average sales price for each year (but uses aliases)
SELECT d.year,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year;

/*
NOTE: All remaining queries will use aliases
*/

-- Computes average sales price for each month and orders the months correctly
SELECT d.month,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.month
ORDER BY 
  CASE d.month
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
  END;

  -- Computes average sales price for quarter
SELECT d.quarter,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.quarter;

/*
Volume
*/

-- Computes volume of transactions for each year
SELECT d.year,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year;

-- Computes volume of transactions for each month and orders the months correctly
SELECT d.month,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.month
ORDER BY 
  CASE d.month
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
  END;

  -- Computes volume of transactions for each quarter
SELECT d.quarter,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.quarter;

/*
Conclusion:
From my queries and calculations, it's shown that there's only been a 21% increase in property prices between 2018 and 2024. 
Furthermore, each months' and quarters' average sales is practically identical, meaning that there's no particular season or month where individuals are more or less likely to buy or sell their home.
2021 was the year with the most transactions.
It doesn't look like month or season has an effect on the volume of transactions eithers
*/