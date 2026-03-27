-- =====================================================
-- Procedure: bronze.load_bronze()
-- Layer    : Bronze (Raw Data Ingestion)
-- =====================================================

-- =====================================================
-- PURPOSE:
-- This procedure loads raw CSV data into Bronze layer tables
-- from CRM and ERP source files.
--
-- Steps:
-- 1. Truncate existing data
-- 2. Load fresh data using COPY command
--
-- This is part of the ingestion step in ETL pipeline.
-- =====================================================

-- =====================================================
-- ⚠️ IMPORTANT WARNING:
--
-- This procedure uses the COPY command, which reads files
-- from the PostgreSQL SERVER machine (not your local system).
--
-- If your CSV files are stored on your local machine,
-- this procedure will FAIL with error:
--
-- "could not open file... No such file or directory"
--
-- =====================================================

-- =====================================================
-- ✅ SOLUTIONS / ALTERNATIVES:
--
-- Option 1 (Recommended for Local Development):
-- Use \copy command from psql or pgAdmin (client-side)
--
-- Option 2 (Production Approach):
-- Place CSV files in server-accessible directory
-- and update file paths accordingly
--
-- Option 3 (Best Practice):
-- Use ETL tools / Python scripts (Pandas, Airflow, etc.)
-- to load data instead of direct COPY
--
-- =====================================================

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN

    -- ===============================
    -- CRM CUSTOMER
    -- ===============================
    RAISE NOTICE 'Loading crm_cust_info...';

    TRUNCATE TABLE bronze.crm_cust_info;

    COPY bronze.crm_cust_info
    FROM 'C:/Users/Quation/Downloads/datawarehouse/cust_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');


    -- ===============================
    -- CRM PRODUCT
    -- ===============================
    RAISE NOTICE 'Loading crm_prd_info...';

    TRUNCATE TABLE bronze.crm_prd_info;

    COPY bronze.crm_prd_info
    FROM 'C:/Users/Quation/Downloads/datawarehouse/prd_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');


    -- ===============================
    -- CRM SALES
    -- ===============================
    RAISE NOTICE 'Loading crm_sale_info...';

    TRUNCATE TABLE bronze.crm_sale_info;

    COPY bronze.crm_sale_info
    FROM 'C:/Users/Quation/Downloads/datawarehouse/sales_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');


    -- ===============================
    -- ERP CUSTOMER
    -- ===============================
    RAISE NOTICE 'Loading erp_cust...';

    TRUNCATE TABLE bronze.erp_cust;

    COPY bronze.erp_cust
    FROM 'C:/Users/Quation/Downloads/datawarehouse/erp_cust.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');


    -- ===============================
    -- ERP LOCATION
    -- ===============================
    RAISE NOTICE 'Loading erp_loc...';

    TRUNCATE TABLE bronze.erp_loc;

    COPY bronze.erp_loc
    FROM 'C:/Users/Quation/Downloads/datawarehouse/erp_loc.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');


    -- ===============================
    -- ERP CATEGORY
    -- ===============================
    RAISE NOTICE 'Loading erp_cat...';

    TRUNCATE TABLE bronze.erp_cat;

    COPY bronze.erp_cat
    FROM 'C:/Users/Quation/Downloads/datawarehouse/erp_cat.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');


    -- Final message
    RAISE NOTICE 'Bronze load completed successfully';

END;
$$;
