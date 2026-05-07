-- Databricks notebook source
CREATE TABLE IF NOT EXISTS workspace.rejected.invalid_customers (
    CustomerID STRING,
    CustomerName STRING,
    Email STRING,
    City STRING,
    Address STRING,
    LastUpdated STRING,
    rejection_reason STRING
)
USING DELTA;

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.silver.customers_clean AS

SELECT
    CAST(CustomerID AS INT) AS CustomerID,

    INITCAP(TRIM(CustomerName)) AS CustomerName,

    LOWER(TRIM(Email)) AS Email,

    TRIM(City) AS City,

    TRIM(Address) AS Address,

    TO_DATE(LastUpdated, 'dd-MM-yyyy') AS LastUpdated

FROM workspace.bronze.customers_raw

WHERE CustomerID IS NOT NULL;

-- COMMAND ----------

SELECT * FROM workspace.silver.customers_clean;

-- COMMAND ----------

SELECT *

FROM workspace.silver.customers_clean

WHERE Email NOT RLIKE '^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$';

-- COMMAND ----------

INSERT INTO workspace.rejected.invalid_customers

SELECT
    CAST(CustomerID AS STRING),
    CustomerName,
    Email,
    City,
    Address,
    CAST(LastUpdated AS STRING),
    'Invalid Email'

FROM workspace.silver.customers_clean

WHERE Email NOT RLIKE '^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$';

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.silver.customers_clean AS

SELECT *

FROM workspace.silver.customers_clean

WHERE Email RLIKE '^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$';

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.silver.customers_clean AS

SELECT
    CustomerID,
    CustomerName,
    Email,
    City,
    Address,
    LastUpdated

FROM (

    SELECT *,

           ROW_NUMBER() OVER (
               PARTITION BY CustomerID
               ORDER BY LastUpdated DESC
           ) AS rn

    FROM workspace.silver.customers_clean

)

WHERE rn = 1;

-- COMMAND ----------

SELECT CustomerID, COUNT(*)

FROM workspace.silver.customers_clean

GROUP BY CustomerID

HAVING COUNT(*) > 1;

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.silver.products_clean AS

SELECT
    CAST(ProductID AS INT) AS ProductID,

    TRIM(ProductName) AS ProductName,

    TRIM(Category) AS Category,

    CAST(UnitPrice AS DECIMAL(10,2)) AS UnitPrice

FROM workspace.bronze.products_raw

WHERE ProductID IS NOT NULL;

-- COMMAND ----------

SELECT * FROM workspace.silver.products_clean;

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.silver.stores_clean AS

SELECT
    CAST(StoreID AS INT) AS StoreID,

    TRIM(StoreName) AS StoreName,

    TRIM(Region) AS Region

FROM workspace.bronze.stores_raw

WHERE StoreID IS NOT NULL;

-- COMMAND ----------

SELECT * FROM workspace.silver.stores_clean;

-- COMMAND ----------

CREATE OR REPLACE TABLE workspace.silver.sales_clean AS

SELECT
    CAST(TransactionID AS INT) AS TransactionID,

    CAST(CustomerID AS INT) AS CustomerID,

    CAST(ProductID AS INT) AS ProductID,

    CAST(StoreID AS INT) AS StoreID,

    CAST(Quantity AS INT) AS Quantity,

    TO_DATE(TxnDate, 'dd-MM-yyyy') AS TxnDate

FROM workspace.bronze.sales_raw

WHERE TransactionID IS NOT NULL;

-- COMMAND ----------

SELECT * FROM workspace.silver.sales_clean;

-- COMMAND ----------

SELECT COUNT(*) FROM workspace.bronze.customers_raw;

SELECT COUNT(*) FROM workspace.silver.customers_clean;

-- COMMAND ----------

SELECT *

FROM workspace.silver.customers_clean

WHERE CustomerID IS NULL;

-- COMMAND ----------

SELECT *

FROM workspace.silver.sales_clean

WHERE Quantity <= 0;

-- COMMAND ----------

SELECT *

FROM workspace.silver.sales_clean

WHERE TxnDate IS NULL;