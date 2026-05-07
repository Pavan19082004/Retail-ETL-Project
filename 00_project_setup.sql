-- Databricks notebook source
SELECT 'Retail ETL Project Started';

-- COMMAND ----------

CREATE DATABASE IF NOT EXISTS retail_dwh;

USE retail_dwh;

-- COMMAND ----------

SELECT current_timestamp();

-- COMMAND ----------

LIST 's3://retail-etl-project52/';

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS workspace.bronze;

CREATE SCHEMA IF NOT EXISTS workspace.silver;

CREATE SCHEMA IF NOT EXISTS workspace.gold;

CREATE SCHEMA IF NOT EXISTS workspace.logs;

CREATE SCHEMA IF NOT EXISTS workspace.rejected;

-- COMMAND ----------

SHOW SCHEMAS IN workspace;