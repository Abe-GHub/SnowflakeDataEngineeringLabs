/*---------------------------------------------------------------------------
  frostbyte_weathersource.sql
  Mounts the free "Pelmorex Weather Source: Frostbyte" Marketplace listing
  (formerly "Weather Source LLC: frostbyte") as FROSTBYTE_WEATHERSOURCE,
  the database name used by Snowflake-Labs/modern-data-engineering-snowflake
  (module-2 notebook, module-3 hamburg_sales_vs_code.sql).
---------------------------------------------------------------------------*/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

-- 1. Where am I connected?
SELECT CURRENT_ORGANIZATION_NAME() AS org_name,
       CURRENT_ACCOUNT()           AS account_locator,
       CURRENT_REGION()            AS region;

-- 2. Is the listing visible in this account/region?
SHOW AVAILABLE LISTINGS;

SELECT "global_name", "title", "is_imported", "is_ready_for_import"
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "title" ILIKE ANY ('%frostbyte%', '%pelmorex%');
-- Expect global_name = GZSOZ1LLEL.
--   is_ready_for_import = TRUE  -> run step 3a
--   is_ready_for_import = FALSE -> run step 3b first, then 3a
--   no rows                     -> listing not offered here; use a trial
--                                  account in AWS US West 2 or US East 1

-- 3b. (Only if not ready) request cross-region fulfillment and wait
-- CALL SYSTEM$REQUEST_LISTING_AND_WAIT('GZSOZ1LLEL');

-- 3a. Accept terms and mount under the lab's expected name
CALL SYSTEM$ACCEPT_LEGAL_TERMS('DATA_EXCHANGE_LISTING', 'GZSOZ1LLEL');
CREATE DATABASE IF NOT EXISTS FROSTBYTE_WEATHERSOURCE FROM LISTING 'GZSOZ1LLEL';
GRANT IMPORTED PRIVILEGES ON DATABASE FROSTBYTE_WEATHERSOURCE TO ROLE PUBLIC;

-- 4. Verify (same query as module-2 notebook, cell 2)
USE DATABASE FROSTBYTE_WEATHERSOURCE;
USE SCHEMA ONPOINT_ID;
SHOW TABLES;

SELECT city_name,
       country,
       AVG(avg_temperature_air_2m_f) AS avg_temperature,
       SUM(tot_precipitation_in)     AS total_precipitation
FROM history_day
WHERE date_valid_std >= DATEADD(DAY, -7, CURRENT_DATE)
  AND country = 'FR'
GROUP BY city_name, country
ORDER BY total_precipitation DESC;

-- Cleanup (when finished with the lab)
-- DROP DATABASE IF EXISTS FROSTBYTE_WEATHERSOURCE;
