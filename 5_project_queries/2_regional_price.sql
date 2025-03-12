/*
Part 2: Regional Price Insights
Understanding regional price variations helps investors, home buyers, and policymakers make informed decisions about where to invest, buy, or regulate housing markets.
The following should be investigated:
•	What are the most expensive and most affordable counties / towns?
•	How are property prices distributed geographically?
•	Are there any emerging high-growth areas where prices are rising quickly?
SQL Queries & Tableau Visuals:
•	SQL: Compute the average property price per county / district. Following this, rank the top 20 and bottom 20.
*/

-- View data and decide which columns are of interest
SELECT *
FROM FACT_price_paid
LEFT OUTER JOIN DIM_location
ON FACT_price_paid.location_id = DIM_location.location_id
LIMIT 100;

/*
Columns town_city, district and county were the location columns with no blanks.
They would also work well for observing property prices by location. Counties (largest) -> Districts -> Towns / Cities (smallest).
After experimenting with columns county and district, I've decided to use district for location exploration.
Districts get more specific than counties, however, still cover a large enough area.
I will maintain having counties there so we know which county a district belongs to.
*/

/*
Salary Average
*/

-- Computes average sales price for each district (and refers which country a district belongs)
SELECT l.county,
       l.district,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district;

-- Computes top 20 most expensive districts in the UK to buy
SELECT l.county,
       l.district,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district
ORDER BY avg_price DESC
LIMIT 20;

-- Computes top 20 most affordable districts in the UK to buy
SELECT l.county,
       l.district,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district
ORDER BY avg_price ASC
LIMIT 20;

-- Computes top 20 most affordable counties in the UK to buy
SELECT l.county,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county
ORDER BY avg_price ASC
LIMIT 20;

-- Computes average sales price for each district and year

SELECT l.county,
       l.district,
       d.year,
       AVG(f.price) AS avg_price
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY l.county,
         l.district,
         d.year
;

-- Computes the percentage change on average price for each district from 2018 to 2024
SELECT l.county,
       l.district,
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
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2024) -- Only include relevant years
GROUP BY l.county, 
         l.district
ORDER BY percentage_change DESC;

/*
NOTE: In the above code, some districts didn't have sales in 2024, thus some values were NULL.
      Below code takes this into account by using COALESCE(). Uses the first NOT NULL value.
*/

-- Computes the percentage change on average price for each district from 2018 to 2024
-- NOTE: This will now take into account those that didn't have sales in 2024 or 2023 by using the previous years sales
SELECT l.county,
       l.district,
       AVG(f.price) FILTER (WHERE d.year = 2018) AS avg_price_2018,
       -- COALESCE() used to take into account 2024 or 2023 being NULL
       COALESCE(AVG(f.price) FILTER (WHERE d.year = 2024), 
                AVG(f.price) FILTER (WHERE d.year = 2023), 
                AVG(f.price) FILTER (WHERE d.year = 2022)) AS latest_price,
       CASE 
            WHEN AVG(f.price) FILTER (WHERE d.year = 2018) IS NOT NULL 
            AND AVG(f.price) FILTER (WHERE d.year = 2018) > 0 
            THEN 
                ((COALESCE(AVG(f.price) FILTER (WHERE d.year = 2024), 
                           AVG(f.price) FILTER (WHERE d.year = 2023), 
                           AVG(f.price) FILTER (WHERE d.year = 2022)) 
                - AVG(f.price) FILTER (WHERE d.year = 2018)) 
                / AVG(f.price) FILTER (WHERE d.year = 2018)) * 100
        ELSE NULL
        END AS percentage_change
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2022, 2023, 2024) -- Only include relevant years
GROUP BY l.county, 
         l.district
ORDER BY percentage_change DESC;

/*
Now we remove the NULLs to get a Top 20 List for growing areas
*/

-- Computes top 20 fastest growing districts from 2018 to 2024
SELECT l.county,
       l.district,
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
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2024) 
GROUP BY l.county, 
         l.district
HAVING 
    CASE 
        WHEN AVG(f.price) FILTER (WHERE d.year = 2018) IS NOT NULL 
        AND AVG(f.price) FILTER (WHERE d.year = 2018) > 0 
        THEN 
            ((AVG(f.price) FILTER (WHERE d.year = 2024) 
            - AVG(f.price) FILTER (WHERE d.year = 2018)) 
            / AVG(f.price) FILTER (WHERE d.year = 2018)) * 100
    ELSE NULL
    END IS NOT NULL -- Makes it so only NOT NULL percentage_change is included. Had to lfie the whole case since you can't just type 'HAVING percentage_change IS NOT NULL'
ORDER BY percentage_change DESC
LIMIT 20;

-- Computes top 20 fastest growing districts from 2018 to 2024 (or 2023, or 2022 if no sale was made in previous year)
SELECT l.county,
       l.district,
       AVG(f.price) FILTER (WHERE d.year = 2018) AS avg_price_2018,
       COALESCE(AVG(f.price) FILTER (WHERE d.year = 2024), 
                AVG(f.price) FILTER (WHERE d.year = 2023), 
                AVG(f.price) FILTER (WHERE d.year = 2022)) AS latest_price,
       CASE 
            WHEN AVG(f.price) FILTER (WHERE d.year = 2018) IS NOT NULL 
            AND AVG(f.price) FILTER (WHERE d.year = 2018) > 0 
            THEN 
                ((COALESCE(AVG(f.price) FILTER (WHERE d.year = 2024), 
                           AVG(f.price) FILTER (WHERE d.year = 2023), 
                           AVG(f.price) FILTER (WHERE d.year = 2022)) 
                - AVG(f.price) FILTER (WHERE d.year = 2018)) 
                / AVG(f.price) FILTER (WHERE d.year = 2018)) * 100
        ELSE NULL
        END AS percentage_change
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2022, 2023, 2024)
GROUP BY l.county, 
         l.district
HAVING 
    CASE 
        WHEN AVG(f.price) FILTER (WHERE d.year = 2018) IS NOT NULL 
        AND AVG(f.price) FILTER (WHERE d.year = 2018) > 0 
        THEN 
            ((COALESCE(AVG(f.price) FILTER (WHERE d.year = 2024), 
                       AVG(f.price) FILTER (WHERE d.year = 2023), 
                       AVG(f.price) FILTER (WHERE d.year = 2022)) 
            - AVG(f.price) FILTER (WHERE d.year = 2018)) 
            / AVG(f.price) FILTER (WHERE d.year = 2018)) * 100
    ELSE NULL
    END IS NOT NULL -- Makes it so only NOT NULL percentage_change is included. Had to lfie the whole case since you can't just type 'HAVING percentage_change IS NOT NULL'
ORDER BY percentage_change DESC
LIMIT 20;


/*
Volume
*/

-- Computes volume of transactions for each district (and refers which country a district belongs)
SELECT l.county,
       l.district,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district;

-- Top 20 volume of transactions for each district (and refers which country a district belongs)
SELECT l.county,
       l.district,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district
ORDER BY number_of_transactions DESC
LIMIT 20;

-- Bottom 20 volume of transactions for each county (and refers which country a district belongs)
SELECT l.county,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county
ORDER BY number_of_transactions ASC
LIMIT 20;

-- Bottom 20 volume of transactions for each district (and refers which country a district belongs)
SELECT l.county,
       l.district,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
GROUP BY l.county,
         l.district
ORDER BY number_of_transactions ASC
LIMIT 20;

-- Computes volume of transactions for each district and year

SELECT l.county,
       l.district,
       d.year,
       COUNT(f.transaction_id) AS number_of_transactions
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
GROUP BY l.county,
         l.district,
         d.year
;

-- Computes top 20 fastest growing districts from 2018 to 2024 (transactions)
SELECT l.county,
       l.district,
       COUNT(f.transaction_id) FILTER (WHERE d.year = 2018) AS number_of_transactions_2018,
       COUNT(f.transaction_id) FILTER (WHERE d.year = 2024) AS number_of_transactions_2024,
       CASE 
            WHEN COUNT(f.transaction_id) FILTER (WHERE d.year = 2018) IS NOT NULL 
            AND COUNT(f.transaction_id) FILTER (WHERE d.year = 2018) > 0 
            THEN 
                ((COUNT(f.transaction_id) FILTER (WHERE d.year = 2024) 
                - COUNT(f.transaction_id) FILTER (WHERE d.year = 2018)) 
                / COUNT(f.transaction_id) FILTER (WHERE d.year = 2018)) * 100
        ELSE NULL
        END AS percentage_change
FROM FACT_price_paid f
LEFT OUTER JOIN DIM_location l
ON f.location_id = l.location_id
LEFT OUTER JOIN DIM_date d
ON f.date_of_transfer_id = d.date_of_transfer_id
WHERE d.year IN (2018, 2024) 
GROUP BY l.county, 
         l.district
HAVING 
    CASE 
        WHEN COUNT(f.transaction_id) FILTER (WHERE d.year = 2018) IS NOT NULL 
        AND COUNT(f.transaction_id) FILTER (WHERE d.year = 2018) > 0 
        THEN 
            ((COUNT(f.transaction_id) FILTER (WHERE d.year = 2024) 
            - COUNT(f.transaction_id) FILTER (WHERE d.year = 2018)) 
            / COUNT(f.transaction_id) FILTER (WHERE d.year = 2018)) * 100
    ELSE NULL
    END IS NOT NULL -- Makes it so only NOT NULL percentage_change is included. Had to lfie the whole case since you can't just type 'HAVING percentage_change IS NOT NULL'
ORDER BY percentage_change DESC;




/*
Conclusion:
- We can observe that the top 20 highest property sale prices occur in Greater London or in London Suburbs such as Surrey, Heartfordshire, Windsor etc.
- Average sale price peaked at £2,276,247 for Kensington and Chelsea.
- Average sale price was at its lowest in Blaenau Gwent, Wales at £127,721.
- The top 5 up-and-coming locations have had their average property price increase between 46% to 58% between 2018 and 2024.
- Windsor and Maidenhead is leading in this regard. Suprisingly, Blaenau Gwent is third in up and coming areas.
*/