# BigBasket Category Performance Diagnostic

## 📌 Project Overview

This repository contains a unified, multi-tool Category Performance Diagnostic for **BigBasket**, India's leading online grocery platform. The objective of this project is to eliminate reporting discrepancies across business analytics tools by establishing a single source of truth for category revenue performance. The diagnostic builds a deterministic SQLite data warehouse (`bigbasket\_capstone.db`), reconciles category totals to the exact rupee across SQL queries and an automated Excel workbook (`category\_revenue\_reconciliation.xlsx`), visualizes performance trends via an interactive Tableau Public dashboard, and independently validates raw, uncleaned order exports using Pandas in Jupyter Notebook (`category\_cleaning\_and\_validation.ipynb`).

\---

## 🗂️ Repository Structure

```text
bigbasket-category-diagnostic/
│
├── README.md                              <-- Master project documentation \& executive summary
├── DATA\_STORY.md                          <-- Executive data story \& category recommendations
├── ai\_log.md                              <-- AI-assisted prompting log (RCTCF structured)
│
├── data/
│   ├── bigbasket\_capstone.db              <-- Primary SQLite database
│   ├── monthly\_category\_revenue.csv       <-- Ground-truth SQL export (36 rows, ₹88,282 total)
│   ├── orders\_raw.csv                     <-- Messy raw order export (used in Part 4)
│   └── products.csv                       <-- Product catalog reference table
│
├── scripts/
│   ├── generate\_data.py                   <-- Deterministic dataset generation script (seed 42)
│   ├── verify.sql                         <-- Data verification queries (row counts \& status distribution)
│   ├── 01\_foundations.sql                 <-- Foundational SQL syntax queries
│   ├── 02\_aggregation\_joins.sql           <-- Grouping, HAVING, and zero-count LEFT JOIN queries
│   └── 03\_reporting.sql                   <-- Tiering, monthly report, \& floating-point target variance
│
├── excel/
│   └── category\_revenue\_reconciliation.xlsx <-- Part 2 spreadsheet cross-validation workbook
│
└── notebooks/
    └── category\_cleaning\_and\_validation.ipynb <-- Part 4 Pandas data cleaning \& validation notebook
```

\---

## ⚙️ How to Regenerate Data \& Database

To regenerate the exact SQLite database and raw CSV files, run `generate\_data.py` with Python 3:

```bash
python3 generate\_data.py
```

*Note: Do not modify `random.seed(42)` inside `generate\_data.py`, as the deterministic acceptance criteria depend on this exact output.*

\---

## 🔍 SQL Task Mapping (`/scripts/`)

All database tasks are implemented across modular SQL scripts:

* **Database Verification (`verify.sql`)**: Contains row count assertions (31 products, 50 customers, 500 orders, 6 category targets) and order status counts (434 Delivered, 42 Cancelled, 24 Pending).
* **Part 1 Foundations (`01\_foundations.sql`)**: Covers `WHERE`, `DISTINCT`, `ORDER BY + LIMIT`, `AS`, `IN`, `BETWEEN / NOT BETWEEN`, and `IS NULL`.
* **Part 1 Aggregations \& Joins (`02\_aggregation\_joins.sql`)**:

  * Query 2(a): `INNER JOIN` with `HAVING total\_revenue > 10000` filter.
  * Query 2(b): `LEFT JOIN` using `COUNT(o.order\_id)` preserving `Premium Face Cream 50g` with a count of `0`.
* **Part 1 Reporting \& Diagnostics (`03\_reporting.sql`)**:

  * Query 3(a): 3-tier `CASE WHEN` product revenue classification (`High`, `Medium`, `Low`).
  * Query 3(b): Monthly category business report (source for `monthly\_category\_revenue.csv`).
  * Query 3(c): Floating-point target variance calculation `((total\_revenue - target\_revenue\_inr) \* 100.0) / target\_revenue\_inr` and status tagging (`Above Target`, `Below Target - Watch`, `Below Target - Critical`).

\---

## 📊 Spreadsheet Workbook (`/excel/`)

* **Filename**: `category\_revenue\_reconciliation.xlsx`
* **Features**: Contains `Monthly Data` (unmodified CSV import), `Category Targets` reference sheet, a working `Pivot Table`, and a `Category Summary` sheet.
* **Reconciliation Outcome**: Uses `XLOOKUP`, `SUMIF`, percentage variance formulas, nested `IF` tiering, and conditional formatting. The `Matches Part 1 SQL total?` column evaluates to **Yes for every category**, confirming rupee-for-rupee consistency (**₹88,282 grand total**).

\---

## 📈 Tableau Public Dashboard \& Data Story

* **Live Dashboard URL**:https://public.tableau.com/authoring/BigBasketCategoryPerformanceDiagnostic\_/Sheet1#1  

* **Dashboard Features**:

  * **KPI Cards**: Total Revenue (₹88,282), Delivered Orders (434), Average Order Value (₹203.41), Categories Meeting Target (3 / 6).
  * **Monthly Trend Chart**: Continuous time-series line chart tracking Jan–Jun 2026 revenue.
  * **Category Bar Chart**: Descending category revenue bar chart color-coded by target tier (Green = Above Target, Amber = Watch, Red = Critical).
  * **Interactive Filter**: Category filter affecting all dashboard worksheets simultaneously.
* **Data Story \& Recommendations**: See full narrative in [DATA\_STORY.md](./DATA_STORY.md).

\---

## 📝 AI-Assisted Prompting Log (`ai\_log.md`)

* **File Location**: [ai\_log.md](./ai_log.md)
* **Structure**: Formatted according to the **RCTCF framework** (Role, Context, Task, Constraints, Format) detailing prompt design and the concrete verification steps performed on AI-suggested SQL queries.

\---

## 🐍 Part 4 Pandas Data Cleaning \& Validation Notebook (`/notebooks/`)

* **File Location**: [category\_cleaning\_and\_validation.ipynb](./notebooks/category_cleaning_and_validation.ipynb)
* **Scope**: Cleans `orders\_raw.csv` by removing duplicate rows, standardizing city/category whitespace and casing, imputing missing revenue values using catalog unit prices, and correcting corrupted statistical outliers.
* **Validation Result**: Confirms that Python/Pandas identifies **Household Essentials** as the top category (₹21,715) and **HomeEssentials Traders** as the top supplier (₹21,715), perfectly matching Part 1 SQL diagnostic findings.

