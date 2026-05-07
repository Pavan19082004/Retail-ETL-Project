-- Databricks notebook source
CREATE TABLE IF NOT EXISTS workspace.gold.dim_customer (

    CustomerSK BIGINT GENERATED ALWAYS AS IDENTITY,

    CustomerID INT,

    CustomerName STRING,

    Email STRING,

    City STRING,

    Address STRING,

    StartDate DATE,

    EndDate DATE,

    IsActive INT

)
USING DELTA;

-- COMMAND ----------

INSERT INTO workspace.gold.dim_customer (

    CustomerID,
    CustomerName,
    Email,
    City,
    Address,
    StartDate,
    EndDate,
    IsActive

)

SELECT
    CustomerID,
    CustomerName,
    Email,
    City,
    Address,
    CURRENT_DATE(),
    DATE('9999-12-31'),
    1

FROM workspace.silver.customers_clean;

-- COMMAND ----------

SELECT * FROM workspace.gold.dim_customer;

-- COMMAND ----------

SELECT *

FROM workspace.gold.dim_customer

WHERE CustomerID = 1;

-- COMMAND ----------

UPDATE workspace.silver.customers_clean

SET City = 'Bangalore'

WHERE CustomerID = 1;

-- COMMAND ----------

MERGE INTO workspace.gold.dim_customer tgt

USING workspace.silver.customers_clean src

ON tgt.CustomerID = src.CustomerID
AND tgt.IsActive = 1

WHEN MATCHED
AND (
    tgt.City <> src.City
    OR tgt.Address <> src.Address
)

THEN UPDATE SET

    tgt.IsActive = 0,

    tgt.EndDate = CURRENT_DATE();

-- COMMAND ----------

INSERT INTO workspace.gold.dim_customer (

    CustomerID,
    CustomerName,
    Email,
    City,
    Address,
    StartDate,
    EndDate,
    IsActive

)

SELECT
    src.CustomerID,
    src.CustomerName,
    src.Email,
    src.City,
    src.Address,
    CURRENT_DATE(),
    DATE('9999-12-31'),
    1

FROM workspace.silver.customers_clean src

LEFT JOIN workspace.gold.dim_customer tgt

ON src.CustomerID = tgt.CustomerID
AND tgt.IsActive = 1

WHERE tgt.CustomerID IS NULL

OR (
    tgt.City <> src.City
    OR tgt.Address <> src.Address
);

-- COMMAND ----------

SELECT
    CustomerSK,
    CustomerID,
    CustomerName,
    City,
    StartDate,
    EndDate,
    IsActive

FROM workspace.gold.dim_customer

WHERE CustomerID = 1

ORDER BY CustomerSK;

-- COMMAND ----------

SELECT *
FROM workspace.gold.dim_customer
ORDER BY CustomerID, CustomerSK;

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.gold.dim_product AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY ProductID
    ) AS ProductSK,

    ProductID,

    ProductName,

    Category,

    UnitPrice,

    CURRENT_DATE() AS EffectiveDate

FROM workspace.silver.products_clean;

-- COMMAND ----------

SELECT * FROM workspace.gold.dim_product;

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.gold.dim_store AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY StoreID
    ) AS StoreSK,

    StoreID,

    StoreName,

    Region

FROM workspace.silver.stores_clean;

-- COMMAND ----------

SELECT * FROM workspace.gold.dim_store;