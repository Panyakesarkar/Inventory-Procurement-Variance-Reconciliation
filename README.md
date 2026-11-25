# Inventory & Procurement 3-Way Variance Reconciliation MIS

## Project Overview
An operational MIS reconciliation suite built in Excel and SQL to cross-verify Purchase Orders (PO), Warehouse Goods Receipt Notes (GRN), and Vendor Invoices—detecting overbilling leakages, short supplies, and low-stock reorder risks.

## Key Features
- **Procurement_MIS_Summary:** Executive KPI cards (`SUM`, `COUNTIF`), Vendor Leakage Audit table (`SUMIFS`, `COUNTIFS`), Warehouse Stock Health table, and a Vendor Cost Leakage chart.
- **Three_Way_Audit_Log:** 120 procurement line items with automated discrepancy formulas (`MAX(0, (Billed - GRN) * Unit_Price)`), conditional audit flags (`Matched`, `Overbilled vs GRN`, `Missing GRN`, `Short Supply`), and automated `Reorder Now` alerts.
- **mis_inventory_reconciliation.sql:** SQL queries utilizing `LEFT JOIN`, `COALESCE`, and `CASE WHEN` statements to automate 3-way matching at the database layer.
