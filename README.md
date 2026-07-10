# dbForge PostgreSQL AI Workflow

This repository contains the SQL scripts and dbForge project files used in a practical PostgreSQL database workflow demo with **dbForge Studio for PostgreSQL**.

The demo is based on a SaaS-style PostgreSQL database running on AWS RDS and focuses on a realistic developer/DBA workflow rather than a small toy database example.

## Overview

The workflow demonstrates how dbForge Studio can be used to:

* Connect to a cloud PostgreSQL database
* Explore a SaaS-style database schema
* Write and run SQL queries
* Use the visual Query Builder
* Generate SQL with AI Assistant
* Review and optimize SQL queries
* Compare staging and production schemas
* Generate synchronization scripts before deployment

## Demo Scenario

The database represents a SaaS platform with common backend entities such as:

* Tenants
* Users
* Plans
* Subscriptions
* Invoices
* Payments
* Usage events
* Support tickets
* Audit logs

The goal is to simulate a realistic database engineering workflow where a backend developer, DBA, or data-focused engineer needs to inspect data, analyze revenue, optimize a dashboard query, and review schema changes before they reach production.

## Repository Structure

```text
.
├── README.md
├── sql
│   ├── 01_setup_and_seed.sql
│   ├── 02_query_builder_script.sql
│   ├── 03_monthly_recurring_revenue_ai.sql
│   ├── 04_unoptimized_dashboard_query.sql
│   ├── 05_optimized_dashboard_query.sql
│   └── 06_schema_compare_sync_script.sql
└── dbforge
    └── final_saas_staging_vs_saas_prod.scomp
```

## Files

### `01_setup_and_seed.sql`

Creates the SaaS demo database schema and inserts realistic sample data.

This includes tables for tenants, users, subscriptions, invoices, payments, usage events, support tickets, and audit logs.

### `02_query_builder_script.sql`

SQL generated or used during the visual Query Builder section of the demo.

This shows how a query can be built visually and then reviewed as SQL.

### `03_monthly_recurring_revenue_ai.sql`

A monthly recurring revenue query created with the help of AI Assistant.

This query analyzes paid invoices and groups revenue by billing month and subscription plan.

### `04_unoptimized_dashboard_query.sql`

A dashboard-style query that joins multiple SaaS tables.

This query is intentionally useful for demonstrating performance review and optimization because it joins several one-to-many relationships.

### `05_optimized_dashboard_query.sql`

An optimized version of the dashboard query.

This file represents the improved approach after reviewing the query structure, aggregation strategy, and indexing suggestions.

### `06_schema_compare_sync_script.sql`

A schema synchronization script generated from comparing the staging and production databases.

This demonstrates a safer workflow for reviewing database changes before applying them.

### `final_saas_staging_vs_saas_prod.scomp`

A dbForge Schema Compare project file used to compare the staging and production PostgreSQL databases.

## Notes

This repository is intended for educational and demonstration purposes.

Before using any SQL script in a real production environment:

* Review the SQL manually
* Check the target database
* Validate indexes and constraints
* Test the execution plan
* Confirm that no destructive changes are included
* Use a proper deployment or change review process

AI-assisted SQL can be useful, but it should not replace engineering review.

## Tool Used

This workflow was created with **dbForge Studio for PostgreSQL**, part of the dbForge database development and management toolset by Devart.

Learn more: [Devart dbForge](https://www.devart.com/)
