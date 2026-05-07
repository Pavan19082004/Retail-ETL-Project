-- Databricks notebook source
USE retail_dwh;

-- COMMAND ----------

DROP TABLE workspace.bronze.customers_raw;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS workspace.bronze.customers_raw (
    CustomerID STRING,
    CustomerName STRING,
    Email STRING,
    City STRING,
    Address STRING,
    LastUpdated STRING
)
USING DELTA;

-- COMMAND ----------

COPY INTO workspace.bronze.customers_raw

FROM (
    SELECT
        CustomerID,
        CustomerName,
        Email,
        City,
        Address,
        LastUpdated

    FROM 's3://retail-etl-project52/landing/customers/'
)

FILEFORMAT = CSV
FORMAT_OPTIONS (
    'header' = 'true'
);

-- COMMAND ----------

SELECT * FROM workspace.bronze.customers_raw;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC products table
-- MAGIC

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS workspace.bronze.products_raw (
    ProductID STRING,
    ProductName STRING,
    Category STRING,
    UnitPrice STRING
)
USING DELTA;

-- COMMAND ----------

COPY INTO workspace.bronze.products_raw

FROM (
    SELECT
        ProductID,
        ProductName,
        Category,
        UnitPrice

    FROM 's3://retail-etl-project52/landing/products/'
)

FILEFORMAT = CSV
FORMAT_OPTIONS (
    'header' = 'true'
);

-- COMMAND ----------

-- MAGIC %md
-- MAGIC stores table

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS workspace.bronze.stores_raw (
    StoreID STRING,
    StoreName STRING,
    Region STRING
)
USING DELTA;

-- COMMAND ----------

COPY INTO workspace.bronze.stores_raw

FROM (
    SELECT
        StoreID,
        StoreName,
        Region

    FROM 's3://retail-etl-project52/landing/stores/'
)

FILEFORMAT = CSV
FORMAT_OPTIONS (
    'header' = 'true'
);

-- COMMAND ----------

-- MAGIC %md
-- MAGIC sales table

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS workspace.bronze.sales_raw (
    TransactionID STRING,
    CustomerID STRING,
    ProductID STRING,
    StoreID STRING,
    Quantity STRING,
    TxnDate STRING
)
USING DELTA;

-- COMMAND ----------

TRUNCATE TABLE workspace.bronze.sales_raw;

-- COMMAND ----------

COPY INTO workspace.bronze.sales_raw

FROM (
    SELECT
        TransactionID,
        CustomerID,
        ProductID,
        StoreID,
        Quantity,
        TxnDate

    FROM 's3://retail-etl-project52/landing/sales/'
)

FILEFORMAT = CSV

FORMAT_OPTIONS (
    'header' = 'true'
);

-- COMMAND ----------

SELECT * FROM workspace.bronze.sales_raw;

-- COMMAND ----------

SELECT COUNT(*) FROM workspace.bronze.customers_raw;

SELECT COUNT(*) FROM workspace.bronze.products_raw;

SELECT COUNT(*) FROM workspace.bronze.stores_raw;

SELECT COUNT(*) FROM workspace.bronze.sales_raw;