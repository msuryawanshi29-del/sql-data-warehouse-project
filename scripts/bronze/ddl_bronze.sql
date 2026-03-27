-- =====================================================
-- Script: Bronze Layer Table Creation
-- Layer : Bronze (Raw Data Layer)
-- =====================================================

-- =====================================================
-- PURPOSE:
-- This script creates raw data tables in the Bronze layer
-- for CRM and ERP systems.
--
-- These tables store unprocessed data ingested directly
-- from source systems (CSV, APIs, databases).
--
-- No transformations, constraints, or business logic
-- are applied at this stage.
-- =====================================================

-- =====================================================
-- WARNINGS / NOTES:
-- 1. Data may contain nulls, duplicates, and inconsistencies.
-- 2. Do NOT apply joins or transformations in Bronze layer.
-- 3. Use Silver layer for cleaning and validation.
-- 4. Ensure consistent data types across ingestion sources.
-- 5. Date fields in sales table are stored as INT (raw format)
--    and should be converted in Silver layer.
-- =====================================================


-- ============================================
-- CRM TABLES
-- ============================================

-- Customer Information Table
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);


-- Product Information Table
CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);


-- Sales Information Table
CREATE TABLE IF NOT EXISTS bronze.crm_sale_info (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,   -- Raw format (e.g., YYYYMMDD)
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);


-- ============================================
-- ERP TABLES
-- ============================================

-- ERP Customer Table
CREATE TABLE IF NOT EXISTS bronze.erp_cust (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);


-- ERP Location Table
CREATE TABLE IF NOT EXISTS bronze.erp_loc (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);


-- ERP Category Table
CREATE TABLE IF NOT EXISTS bronze.erp_cat (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
