-- Ideal Execution

COPY public.DIM_date
FROM 'C:\Users\Vikram Kapoor\OneDrive\CURRENT LAPTOP\Independent Study\Coding\SQL\HMLR_Price_Paid_Project_SQL\3. ddm_csv_files\DIM_date.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_location
FROM 'C:\Users\Vikram Kapoor\OneDrive\CURRENT LAPTOP\Independent Study\Coding\SQL\HMLR_Price_Paid_Project_SQL\3. ddm_csv_files\DIM_location.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_property_type
FROM 'C:\Users\Vikram Kapoor\OneDrive\CURRENT LAPTOP\Independent Study\Coding\SQL\HMLR_Price_Paid_Project_SQL\3. ddm_csv_files\DIM_property_type.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_old_or_new
FROM 'C:\Users\Vikram Kapoor\OneDrive\CURRENT LAPTOP\Independent Study\Coding\SQL\HMLR_Price_Paid_Project_SQL\3. ddm_csv_files\DIM_old_or_new.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_duration
FROM 'C:\Users\Vikram Kapoor\OneDrive\CURRENT LAPTOP\Independent Study\Coding\SQL\HMLR_Price_Paid_Project_SQL\3. ddm_csv_files\DIM_duration.csv'
DELIMITER ',' CSV HEADER;

COPY public.FACT_price_paid
FROM 'C:\Users\Vikram Kapoor\OneDrive\CURRENT LAPTOP\Independent Study\Coding\SQL\HMLR_Price_Paid_Project_SQL\3. ddm_csv_files\FACT_price_paid.csv'
DELIMITER ',' CSV HEADER;

/*
PostgreSQL doesn't have permission to access my OneDrive or personal documents file, so the above code cannot be run.
A possible solutions would be to grant 'NETWORK SERVICE' to the file containing the CSVs, however this would be a security risk.
I went with the option of creating a temporary folder in the 'C:' drive, move the CSVs there and run the below code.
*/

COPY public.DIM_date
FROM 'C:\tmp\3. ddm_csv_files\DIM_date.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_location
FROM 'C:\tmp\3. ddm_csv_files\DIM_location.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_property_type
FROM 'C:\tmp\3. ddm_csv_files\DIM_property_type.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_old_or_new
FROM 'C:\tmp\3. ddm_csv_files\DIM_old_or_new.csv'
DELIMITER ',' CSV HEADER;

COPY public.DIM_duration
FROM 'C:\tmp\3. ddm_csv_files\DIM_duration.csv'
DELIMITER ',' CSV HEADER;

COPY public.FACT_price_paid
FROM 'C:\tmp\3. ddm_csv_files\FACT_price_paid.csv'
DELIMITER ',' CSV HEADER;

-- Confirm FACT and DIM tables are uploaded

SELECT * FROM FACT_price_paid LIMIT 100;
SELECT * FROM DIM_date LIMIT 100;
SELECT * FROM DIM_location LIMIT 100;
SELECT * FROM DIM_property_type LIMIT 100;
SELECT * FROM DIM_old_or_new LIMIT 100;
SELECT * FROM DIM_duration LIMIT 100;