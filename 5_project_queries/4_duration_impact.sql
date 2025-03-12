/*
Part 4: Duration Impact on Pricing (Freehold Vs Leasehold)
Understanding how duration impacts property value helps investors, banks, and home buyers assess long-term ownership costs and market demand.
The following should be investigated:
•	Do Freehold properties (F) sell at a higher prices than Leasehold (L) properties?
•	Do Freehold properties (F) sell at a higher prices than Leasehold (L) properties (in particular years or regions)?
•	Are there differences in the proportion of Freehold Vs Leasehold sales?
•	Are there differences yearly in the proportion of Freehold Vs Leasehold sales?
•	Are there regional differences in the proportion of Freehold Vs Leasehold sales?
SQL Queries & Tableau Visuals:
•	SQL: Compare the average price of Freehold Vs Leasehold properties (overall, by year and by region)
•	SQL: Calculate which duration (F, L) has the highest volume of transactions (overall, by year and by region)
*/

/*
AVERAGE PRICE
*/

-- Computes average sales price for each Duration
SELECT du.duration,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
GROUP BY du.duration
;

-- Computes average sales price for each Duration by year
SELECT d.year,
       du.duration,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
LEFT OUTER JOIN DIM_date D
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year,
         du.duration
;

-- Computes average sales price for each Duration by region
SELECT l.county,
       l.district,
       du.duration,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district,
         du.duration
ORDER BY l.county ASC,
         l.district ASC,
         du.duration
;

-- Computes the percentage change on average price for each duration from 2018 to 2024
SELECT du.duration,
       AVG(f.price) FILTER (WHERE d.year = 2018) AS avg_price_2018,
       AVG(f.price) FILTER (WHERE d.year = 2024) AS avg_price_2024,
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
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2024)
GROUP BY du.duration
ORDER BY percentage_change DESC;

/*
VOLUME
*/

-- Computes highest volume of transactions for each Duration
SELECT du.duration,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
GROUP BY du.duration
;

-- Computes highest volume of transactions for each Duration by year
SELECT d.year,
       du.duration,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
LEFT OUTER JOIN DIM_date D
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year,
         du.duration
;

-- Computes highest volume of transactions for each Duration by region
SELECT l.county,
       l.district,
       du.duration,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_duration du
ON f.duration_id = du.duration_id
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district,
         du.duration
ORDER BY l.county ASC,
         l.district ASC,
         du.duration
;

/*
Conclusion:
- According to the data, freehold homes have an average price of £349,599 and for leasehold homes, it's £296,694 
- With regard to the volume of transactions, far more freehold transactions (4,443,916) are taking place than leasehold transactions (1,266,841)
- Freehold properties' average price has a percentage increase of 24.3% between years 2019 and 2024, and leasehold has 8%.
- Every year, the volume of freehold transactions is far higher than leasehold transactions
- Overall, the volume of transactions increases up until 2021, until it starts to decrease.
- To get insight into region prices and volumes, a heat map would be necessary
*/