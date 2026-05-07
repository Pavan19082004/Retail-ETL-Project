# Retail ETL Data Warehouse Pipeline

## Overview

This project is an end-to-end Retail ETL pipeline developed using AWS S3, Databricks, Delta Lake, and SQL. The pipeline ingests raw retail datasets from cloud storage, processes and cleans the data using Medallion Architecture, builds warehouse-ready fact and dimension tables, and automates the complete workflow using Databricks Workflows.

---

## Tech Stack

* AWS S3
* Databricks SQL
* Delta Lake
* SQL
* Databricks Workflows

---

## Architecture

```text id="zwqx9g"
AWS S3 → Bronze Layer → Silver Layer → Gold Layer
        → Validation → Archive → Audit Logging
```

---

## Project Layers

### Bronze Layer

Raw data ingestion from S3 into Delta tables.

Tables:

* customers_raw
* products_raw
* stores_raw
* sales_raw

---

### Silver Layer

Data cleansing and standardization.

Operations:

* Null handling
* Trimming spaces
* Date conversion
* Datatype casting
* Text formatting

Tables:

* customers_clean
* products_clean
* stores_clean
* sales_clean

---

### Gold Layer

Business-ready warehouse tables.

Dimension Tables:

* dim_customer
* dim_product
* dim_store

Fact Table:

* fact_sales

Features:

* Surrogate keys
* Revenue calculation
* Analytical modeling
* SCD Type 2 implementation

---

## SCD Type 2

Implemented on the customer dimension to maintain historical changes.

Tracked using:

* StartDate
* EndDate
* IsActive

---

## Validation Checks

* Duplicate detection
* Null foreign key validation
* Active record validation
* Row count verification

---

## Automation

The entire ETL flow is automated using Databricks Workflows.

Pipeline Order:

```text id="hrf08u"
bronze_load
   ↓
silver_transform
   ↓
gold_dimensions
   ↓
fact_load
   ↓
validation
   ↓
archive_files
   ↓
audit_logging
```

---

## Key Highlights

* Built using Medallion Architecture
* Implemented SCD Type 2 logic
* Automated ETL orchestration
* Used Delta tables for reliable storage
* Integrated AWS S3 with Databricks
* Developed validation and audit mechanisms

---

## Future Improvements

* PySpark-based transformations
* Real-time streaming ingestion
* Dashboard integration
* CI/CD deployment

---

## Author

Pavan Renukuntla
