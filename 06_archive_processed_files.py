# Databricks notebook source
dbutils.fs.mv(
    "s3://retail-etl-project52/landing/sales/",
    "s3://retail-etl-project52/archive/sales/",
    True
)

dbutils.fs.mv(
    "s3://retail-etl-project52/landing/customers/",
    "s3://retail-etl-project52/archive/customers/",
    True
)

dbutils.fs.mv(
    "s3://retail-etl-project52/landing/products/",
    "s3://retail-etl-project52/archive/products/",
    True
)

dbutils.fs.mv(
    "s3://retail-etl-project52/landing/stores/",
    "s3://retail-etl-project52/archive/stores/",
    True
)