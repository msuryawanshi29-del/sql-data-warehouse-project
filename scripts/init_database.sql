-- =====================================================
-- Script: Medallion Architecture Schema Setup
-- Author: [Your Name]
-- Date: [YYYY-MM-DD]
-- =====================================================

-- =====================================================
-- PURPOSE:
-- This script creates three schemas (bronze, silver, gold)
-- to implement the Medallion Architecture in a data warehouse.
--
-- Bronze Layer : Stores raw, unprocessed data
-- Silver Layer : Stores cleaned and transformed data
-- Gold Layer   : Stores aggregated, business-ready data
--
-- This structure helps in organizing data pipelines,
-- improving data quality, and enabling scalable analytics.
-- =====================================================

-- =====================================================
-- WARNINGS / NOTES:
-- 1. Ensure you have sufficient privileges to create schemas.
-- 2. Existing schemas will NOT be overwritten due to 
--    "IF NOT EXISTS" clause.
-- 3. Naming conventions should align with your organization’s standards.
-- 4. Avoid storing business-critical curated data in Bronze layer.
-- 5. Use proper access control:
--    - Restrict write access to Bronze
--    - Control transformations in Silver
--    - Provide read-only access for Gold (BI tools)
-- =====================================================

-- Create Bronze Layer Schema (Raw Data)
CREATE SCHEMA IF NOT EXISTS bronze;

-- Create Silver Layer Schema (Cleaned Data)
CREATE SCHEMA IF NOT EXISTS silver;

-- Create Gold Layer Schema (Business Data)
CREATE SCHEMA IF NOT EXISTS gold;
