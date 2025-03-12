/*
Part 3: Property Type Comparison
Different property types appreciate at different rates, affecting investment value and buyer affordability.
The following should be investigated:
•	How do detached, semi-detached, terraced and flats compare in price?
•	How do detached, semi-detached, terraced and flats compare in price (by year or region)?
•	Which property type has the highest volume of transactions?
•	Which property type has the highest volume of transactions (by year or region)?
SQL Queries & Tableau Visuals:
•	SQL: Calculate average price per property type (D, S, T, F) (overall, by year and by region)
•	SQL: Calculate which property type (D, S, T, F) has the highest volume of transactions (overall, by year, and by region)
*/

/*
AVERAGE PRICE
*/

-- Computes average sales price for each Property Type
SELECT t.property_type,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
GROUP BY t.property_type
;

-- Computes average sales price for each Property Type by year
SELECT d.year,
       t.property_type,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
LEFT OUTER JOIN DIM_date D
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year,
         t.property_type
;

-- Computes average sales price for each Property Type by region
SELECT l.county,
       l.district,
       t.property_type,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district,
         t.property_type
ORDER BY l.county ASC,
         l.district ASC,
         t.property_type
;

-- Computes the percentage change on average price for each property type from 2018 to 2024
SELECT t.property_type,
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
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2024)
GROUP BY t.property_type
ORDER BY percentage_change DESC;

/*
VOLUME
*/

-- Computes highest volume of transactions for each property type
SELECT t.property_type,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
GROUP BY t.property_type
;

-- Computes highest volume of transactions for each property type by year
SELECT d.year,
       t.property_type,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
LEFT OUTER JOIN DIM_date D
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY d.year,
         t.property_type
;

-- Computes highest volume of transactions for each property type by region
SELECT l.county,
       l.district,
       t.property_type,
       COUNT(f.transaction_id) AS volume_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_property_type t
ON f.property_type_id = t.property_type_id
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district,
         t.property_type
ORDER BY l.county ASC,
         l.district ASC,
         t.property_type
;

/*
Conclusion:
- According to the data detached homes have the highest average price (£465,587), followed by flats (£318,043), then semi detached (£291,108) then terraced (£277,245).
- With regard to the volume of transactions, semi-detached homes are purchased the most (1,654,341 sales), followed by terraced (1,555,122 sales), then detached (1,499,123) then flats (1,002,071).
- Terraced homes have the largest percentage increase in average price paid from 2018 to 2024 (26%), followed by the near identical semi-detached (25.9%) and detached (25.4%) (a negligible difference)
- Something worth noting is that flat prices stay near constant from 2018 to 2024, with only a 5% increase
- With regard to the volume of transactions by year, it follows a binomial pattern for each property type, increasing until 2021, where it goes down until it's even lower in 2024 than it started in 2018
- To get insight into region prices and volumes, a heat map would be necessary
*/