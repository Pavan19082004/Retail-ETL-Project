-- Databricks notebook source
CREATE TABLE IF NOT EXISTS workspace.gold.fact_sales (

    SalesSK BIGINT GENERATED ALWAYS AS IDENTITY,

    TransactionID INT,

    CustomerSK BIGINT,

    ProductSK BIGINT,

    StoreSK BIGINT,

    Quantity INT,

    Amount DECIMAL(10,2),

    TxnDate DATE

)
USING DELTA;

-- COMMAND ----------

TRUNCATE TABLE workspace.gold.fact_sales;

-- COMMAND ----------

INSERT INTO workspace.gold.fact_sales (

    TransactionID,
    CustomerSK,
    ProductSK,
    StoreSK,
    Quantity,
    Amount,
    TxnDate

)

SELECT

    s.TransactionID,

    c.CustomerSK,

    p.ProductSK,

    st.StoreSK,

    s.Quantity,

    s.Quantity * p.UnitPrice AS Amount,

    s.TxnDate

FROM workspace.silver.sales_clean s

JOIN workspace.gold.dim_customer c
ON s.CustomerID = c.CustomerID
AND c.IsActive = 1

JOIN workspace.gold.dim_product p
ON s.ProductID = p.ProductID

JOIN workspace.gold.dim_store st
ON s.StoreID = st.StoreID;

-- COMMAND ----------

SELECT * FROM workspace.gold.fact_sales;

-- COMMAND ----------

SELECT * FROM workspace.silver.sales_clean;

-- COMMAND ----------

SELECT
    CustomerSK,
    CustomerID,
    IsActive
FROM workspace.gold.dim_customer
ORDER BY CustomerID;

-- COMMAND ----------

SELECT
    ProductSK,
    ProductID
FROM workspace.gold.dim_product
ORDER BY ProductID;

-- COMMAND ----------

SELECT
    StoreSK,
    StoreID
FROM workspace.gold.dim_store
ORDER BY StoreID;