/*
Part 5: Transactions by Property Age (New Vs Old Properties)
New-build properties may have different pricing trends and market appeal compared to older homes.
The following should be investigated:
•	Do newly built properties (Y) sell at a premium compared to established properties (N)?
•	Do newly built properties (Y) sell at a premium compared to established properties (N)? (in particular years or regions)?
•	Which property age has the highest volume of transactions?
•	Which property age has the highest volume of transactions (by year or region)?
SQL Queries & Tableau Visuals:
•	SQL: Calculate average price per property age (overall, by year and by region).
•	SQL: Calculate which property age has the highest volume of transactions (overall, by year, and by region).
*/

/*
AVERAGE PRICE
*/

-- Computes average sales price for each Property Age
SELECT o.old_or_new,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
GROUP BY o.old_or_new
;

-- Computes average sales price for each Property Age by year
SELECT d.year,
       o.old_or_new,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
LEFT OUTER JOIN DIM_date D
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year,
         o.old_or_new
;

-- Computes average sales price for each Property Age by region
SELECT l.county,
       l.district,
       o.old_or_new,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district,
         o.old_or_new
ORDER BY l.county ASC,
         l.district ASC,
         o.old_or_new
;

-- Computes the percentage change on average price for each property age from 2018 to 2024
SELECT o.old_or_new,
       -- Get 2018 and 2024 average prices
       AVG(f.price) FILTER (WHERE d.year = 2018) AS avg_price_2018,
       AVG(f.price) FILTER (WHERE d.year = 2024) AS avg_price_2024,
       -- Calculate percentage change
       CASE 
            WHEN AVG(f.price) FILTER (WHERE d.year = 2018) IS NOT NULL 
            AND AVG(f.price) FILTER (WHERE d.year = 2018) > 0 
            THEN 
                ((AVG(f.price) FILTER (WHERE d.year = 2024) 
                - AVG(f.price) FILTER (WHERE d.year = 2018)) 
                / AVG(f.price) FILTER (WHERE d.year = 2018)) * 100
        ELSE NULL
        END AS percentage_change
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2024) -- Only include relevant years
GROUP BY o.old_or_new
ORDER BY percentage_change DESC;

/*
VOLUME
*/

-- Computes highest volume of transactions for each Property Age
SELECT o.old_or_new,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
GROUP BY o.old_or_new
;

-- Computes highest volume of transactions for each Property Age by year
SELECT d.year,
       o.old_or_new,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
LEFT OUTER JOIN DIM_date D
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year,
         o.old_or_new
;

-- Computes highest volume of transactions for each Property Age by region
SELECT l.county,
       l.district,
       o.old_or_new,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN dim_old_or_new o
ON f.old_or_new_id = o.old_or_new_id
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district,
         o.old_or_new
ORDER BY l.county ASC,
         l.district ASC,
         o.old_or_new
;

/*
Conclusion:
- The average price of new builds is higher at £371,681, than an old build's at £333557 (not much difference)
- With regard to the volume of transactions, there are far less new builds (644912) than old builds (5,065,745) being purchased
- For old builds, the average sales price has increased by 23% between the years 2018 to 2024. For new builds, it's 17.5%.
-With regard to the volume of transactions over years, they stay near constant except for massive spike in 2021.
*/