-- Databricks notebook source
SELECT COUNT(*) AS bronze_sales
FROM workspace.bronze.sales_raw;

SELECT COUNT(*) AS silver_sales
FROM workspace.silver.sales_clean;

SELECT COUNT(*) AS fact_sales
FROM workspace.gold.fact_sales;

-- COMMAND ----------

SELECT
    TransactionID,
    COUNT(*)

FROM workspace.gold.fact_sales

GROUP BY TransactionID

HAVING COUNT(*) > 1;

-- COMMAND ----------

SELECT *

FROM workspace.gold.fact_sales

WHERE CustomerSK IS NULL
OR ProductSK IS NULL
OR StoreSK IS NULL;

-- COMMAND ----------

SELECT *

FROM workspace.gold.fact_sales f

LEFT JOIN workspace.gold.dim_customer c
ON f.CustomerSK = c.CustomerSK

WHERE c.CustomerSK IS NULL;

-- COMMAND ----------

SELECT *

FROM workspace.gold.fact_sales

WHERE Amount <= 0;

-- COMMAND ----------

SELECT
    CustomerID,
    COUNT(*)

FROM workspace.gold.dim_customer

WHERE IsActive = 1

GROUP BY CustomerID

HAVING COUNT(*) > 1;