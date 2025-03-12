CREATE TABLE public.DIM_date
(
    date_of_transfer_id SMALLINT PRIMARY KEY,
    date_of_transfer DATE,
    year SMALLINT,
    month VARCHAR(10),
    quarter CHAR(2)
)
;

CREATE TABLE public.DIM_location
(
    location_id SMALLINT PRIMARY KEY,
    postcode VARCHAR(10),
    paon VARCHAR(50),
    saon VARCHAR(50),
    street VARCHAR(100),
    locality VARCHAR(100),
    town_city VARCHAR(100),
    district VARCHAR(100),
    county VARCHAR(100)
)
;

CREATE TABLE public.DIM_property_type
(
    property_type_id SMALLINT PRIMARY KEY,
    property_type CHAR(1)
)
;

CREATE TABLE public.DIM_old_or_new
(
    old_or_new_id SMALLINT PRIMARY KEY,
    old_or_new CHAR(1)
)
;

CREATE TABLE public.DIM_duration
(
    duration_id SMALLINT PRIMARY KEY,
    duration CHAR(1)
)
;

CREATE TABLE public.FACT_price_paid
(
    transaction_id VARCHAR(75) PRIMARY KEY,
    price INT,
    date_of_transfer_id SMALLINT,
    FOREIGN KEY (date_of_transfer_id) REFERENCES public.DIM_date (date_of_transfer_id),
    location_id SMALLINT,
    FOREIGN KEY (location_id) REFERENCES public.DIM_location (location_id),
    property_type_id SMALLINT,
    FOREIGN KEY (property_type_id) REFERENCES public.DIM_property_type (property_type_id),
    old_or_new_id SMALLINT,
    FOREIGN KEY (old_or_new_id) REFERENCES public.DIM_old_or_new (old_or_new_id),
    duration_id SMALLINT,
    FOREIGN KEY (duration_id) REFERENCES public.DIM_duration (duration_id)
)
;


-- Set ownership of the tables to the postgres user
ALTER TABLE public.FACT_price_paid OWNER to postgres;
ALTER TABLE public.DIM_date OWNER to postgres;
ALTER TABLE public.DIM_location OWNER to postgres;
ALTER TABLE public.DIM_property_type OWNER to postgres;
ALTER TABLE public.DIM_old_or_new OWNER to postgres;
ALTER TABLE public.DIM_duration OWNER to postgres;

-- Correction of column data types when load fails
ALTER TABLE public.DIM_location ALTER COLUMN location_id SET DATA TYPE INT;  -- SMALLINT was too small
ALTER TABLE public.FACT_price_paid ALTER COLUMN location_id SET DATA TYPE INT; -- SMALLINT was too small
ALTER TABLE public.DIM_location ALTER COLUMN paon SET DATA TYPE VARCHAR(100); -- VARCHAR(50) was too small
ALTER TABLE public.DIM_location ALTER COLUMN saon SET DATA TYPE VARCHAR(100); -- VARCHAR(50) was too small