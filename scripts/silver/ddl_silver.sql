/*
===============================================================================
DDL Script: Create Silver Layer Tables
===============================================================================

🎯 Purpose:
    This script creates the Silver Layer tables in the data warehouse.

    The Silver Layer represents:
    - Cleaned and standardized data
    - Structured data ready for transformation
    - Intermediate layer between Bronze (raw) and Gold (business-ready)

📌 Data Flow:
    Bronze → Raw ingestion (no transformation)
    Silver → Cleaned, validated, standardized
    Gold   → Analytical model (Star Schema)

📊 Tables Created:
    1. crm_cust_info  → Customer data (CRM)
    2. crm_prd_info   → Product data (CRM)
    3. crm_sale_info  → Sales transactions (CRM)
    4. erp_cust       → Customer demographics (ERP)
    5. erp_loc        → Customer location (ERP)
    6. erp_cat        → Product category mapping (ERP)

⚙️ Common Design:
    - All tables include dwh_create_date for audit tracking
    - Data types are normalized and cleaned
    - Ready for transformation into Gold Layer

===============================================================================
*/

-- =============================================================================
-- 1. TABLE: silver.crm_cust_info
-- =============================================================================
/*
Description:
    Stores cleaned customer data from CRM system.

Grain:
    One record per customer (latest version)

Columns:
    - cst_id             → Unique customer ID
    - cst_key            → Business key used across systems
    - cst_firstname      → Customer first name
    - cst_lastname       → Customer last name
    - cst_marital_status → Standardized marital status
    - cst_gndr           → Standardized gender
    - cst_create_date    → Customer creation date
    - dwh_create_date    → Data warehouse load date
*/

DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATE DEFAULT CURRENT_DATE
);


-- =============================================================================
-- 2. TABLE: silver.crm_prd_info
-- =============================================================================
/*
Description:
    Stores cleaned product data from CRM system.

Grain:
    One record per product per time period

Columns:
    - prd_id         → Product ID
    - cat_id         → Category ID
    - prd_key        → Business product key
    - prd_nm         → Product name
    - prd_cost       → Product cost
    - prd_line       → Product line (Mountain, Road, etc.)
    - prd_start_dt   → Product start date
    - prd_end_dt     → Product end date (NULL = active)
    - dwh_create_date → Data warehouse load date
*/

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATE DEFAULT CURRENT_DATE
);


-- =============================================================================
-- 3. TABLE: silver.crm_sale_info
-- =============================================================================
/*
Description:
    Stores cleaned sales transaction data from CRM.

Grain:
    One record per sales transaction (order line level)

Columns:
    - sls_ord_num    → Order number
    - sls_prd_key    → Product key
    - sls_cust_id    → Customer ID
    - sls_order_dt   → Order date
    - sls_ship_dt    → Shipping date
    - sls_due_dt     → Due date
    - sls_sales      → Total sales amount
    - sls_quantity   → Quantity sold
    - sls_price      → Unit price
    - dwh_create_date → Data warehouse load date
*/

DROP TABLE IF EXISTS silver.crm_sale_info;

CREATE TABLE silver.crm_sale_info (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATE DEFAULT CURRENT_DATE
);


-- =============================================================================
-- 4. TABLE: silver.erp_cust
-- =============================================================================
/*
Description:
    Stores customer demographic data from ERP system.

Grain:
    One record per customer

Columns:
    - cid             → Customer ID (mapped to CRM)
    - bdate           → Birthdate
    - gen             → Gender
    - dwh_create_date → Load date
*/

DROP TABLE IF EXISTS silver.erp_cust;

CREATE TABLE silver.erp_cust (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50),
    dwh_create_date DATE DEFAULT CURRENT_DATE
);


-- =============================================================================
-- 5. TABLE: silver.erp_loc
-- =============================================================================
/*
Description:
    Stores customer location details from ERP.

Grain:
    One record per customer

Columns:
    - cid             → Customer ID
    - cntry           → Country name
    - dwh_create_date → Load date
*/

DROP TABLE IF EXISTS silver.erp_loc;

CREATE TABLE silver.erp_loc (
    cid VARCHAR(50),
    cntry VARCHAR(50),
    dwh_create_date DATE DEFAULT CURRENT_DATE
);


-- =============================================================================
-- 6. TABLE: silver.erp_cat
-- =============================================================================
/*
Description:
    Stores product category hierarchy from ERP.

Grain:
    One record per category

Columns:
    - id              → Category ID
    - cat             → Category name
    - subcat          → Subcategory name
    - maintenance     → Maintenance type
    - dwh_create_date → Load date
*/

DROP TABLE IF EXISTS silver.erp_cat;

CREATE TABLE silver.erp_cat (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),
    dwh_create_date DATE DEFAULT CURRENT_DATE
);


-- =============================================================================
-- ✅ END OF SCRIPT
-- =============================================================================
