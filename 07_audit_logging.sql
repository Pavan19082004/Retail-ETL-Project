-- Databricks notebook source
CREATE TABLE IF NOT EXISTS workspace.logs.etl_audit_log (

    layer_name STRING,

    table_name STRING,

    row_count BIGINT,

    load_timestamp TIMESTAMP,

    status STRING

)
USING DELTA;

-- COMMAND ----------

INSERT INTO workspace.logs.etl_audit_log

SELECT
    'Bronze',
    'sales_raw',
    COUNT(*),
    CURRENT_TIMESTAMP(),
    'SUCCESS'

FROM workspace.bronze.sales_raw;

-- COMMAND ----------

SELECT * FROM workspace.logs.etl_audit_log;