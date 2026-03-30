
/*
===============================================================================
DDL Script: Create Gold Views (PostgreSQL)
===============================================================================

🎯 Purpose:
    This script creates the Gold Layer views in the data warehouse.

    The Gold Layer represents:
    - Business-ready data
    - Star Schema (Dimensions + Fact)
    - Cleaned, enriched, and joined datasets

    These views are designed for:
    - BI tools (Power BI, Tableau)
    - Analytics & reporting
    - Business users

📌 Data Flow:
    Bronze → Raw Data
    Silver → Cleaned & Standardized
    Gold   → Business Model (Star Schema)

📊 Objects Created:
    1. gold.dim_customers  → Customer Dimension
    2. gold.dim_products   → Product Dimension
    3. gold.fact_sales     → Sales Fact Table

⚠️ Notes:
    - Uses ROW_NUMBER() for surrogate keys (not stable for production)
    - Consider materialized views or tables for large datasets
    - Uses LEFT JOIN to preserve fact completeness

===============================================================================
*/

-- =============================================================================
-- 1. DIMENSION: gold.dim_customers
-- =============================================================================
/*
Description:
    Customer dimension enriched with:
    - CRM data (primary source)
    - ERP customer demographics
    - Country information

Business Logic:
    - CRM is the primary source for gender
    - ERP is fallback if CRM gender is missing
    - Surrogate key generated using ROW_NUMBER()

Grain:
    One record per customer
*/

DROP VIEW IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,  -- Surrogate key
    ci.cst_id        AS customer_id,
    ci.cst_key       AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname  AS last_name,
    la.cntry         AS country,
    ci.cst_marital_status AS marital_status,

    -- Gender Logic: CRM → ERP → default
    CASE 
        WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    ca.bdate         AS birthdate,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc la
    ON ci.cst_key = la.cid;


-- =============================================================================
-- 2. DIMENSION: gold.dim_products
-- =============================================================================
/*
Description:
    Product dimension enriched with:
    - Product details from CRM
    - Category mapping from ERP

Business Logic:
    - Only active products are included
    - Historical records (with end date) are excluded

Grain:
    One record per active product
*/

DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_cat pc
    ON pn.cat_id = pc.id

-- Only current/active products
WHERE pn.prd_end_dt IS NULL;


-- =============================================================================
-- 3. FACT TABLE: gold.fact_sales
-- =============================================================================
/*
Description:
    Sales fact table combining:
    - Sales transactions
    - Customer dimension
    - Product dimension

Business Logic:
    - Links fact with dimensions using business keys
    - Uses LEFT JOIN to avoid data loss

Grain:
    One record per sales transaction (order line level)

Measures:
    - sales_amount
    - quantity
    - price

Foreign Keys:
    - product_key → dim_products
    - customer_key → dim_customers
*/

DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price

FROM silver.crm_sale_info sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;


-- =============================================================================
-- ✅ END OF SCRIPT
-- =============================================================================
