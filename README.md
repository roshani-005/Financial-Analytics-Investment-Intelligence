# Financial Data Intelligence & Investment Analytics

An end-to-end **financial data intelligence platform** designed around real market data and an extensible company-fundamentals layer. The project is intentionally focused on Python data gathering/cleansing, ETL, PostgreSQL/DBMS, advanced SQL, Power BI, relational database design, optimization, analytics, and basic GenAI.

## Business objective

Turn raw market and company-financial data into a trusted analytical model that can answer:

- How is a company performing financially?
- How is its market price behaving?
- How are revenue, EBITDA, net income and EPS changing over reporting periods?
- How do valuation and profitability metrics compare across companies/sectors?
- Which companies satisfy configurable financial screening criteria?

This is an **analytics and screening project**, not personalized investment advice.

## Data sources

### Market data
The supplied TSLA source contains **2,766 daily records from 2015-01-02 through 2025-12-31** with Date, Open, High, Low, Close and Volume. A sample is committed at `data/raw/TSLA_sample.csv`.

### Fundamentals
The project now supports a separate, real company-fundamentals source. Put a verified CSV at:

`data/raw/company_fundamentals.csv`

Expected minimum fields:

`Ticker, Company, Report_Date/Year, Revenue, EBITDA, Net_Income, EPS`

Optional fields such as `Total_Assets`, `Total_Debt`, `Market_Cap`, `Enterprise_Value`, `Sector`, and `Industry` enable additional valuation analysis. **No financial fundamentals are fabricated by the project.**

## Architecture

```text
REAL MARKET DATA + REAL COMPANY FUNDAMENTALS
                    ↓
              Python ETL
                    ↓
       Cleaning + normalization
                    ↓
          Validation + quality checks
                    ↓
              PostgreSQL
                    ↓
          Relational / star model
                    ↓
        Advanced SQL analytics
        ├── Joins
        ├── CTEs
        ├── Window functions
        ├── Views
        └── Triggers / audit controls
                    ↓
                Power BI
                    ↓
        Financial intelligence
        ├── Company performance
        ├── Market performance
        ├── Profitability
        ├── Valuation
        ├── Sector comparison
        └── Screening
                    ↓
        Basic natural-language → SQL
```

## Repository structure

```text
Financial-Analytics-Investment-Intelligence/
├── data/
│   ├── raw/
│   │   ├── TSLA_sample.csv
│   │   └── company_fundamentals.csv   # supplied/verified source
│   └── processed/
├── src/
│   ├── etl.py
│   ├── fundamentals_etl.py
│   ├── load_postgres.py
│   └── run_pipeline.py
├── sql/
│   ├── schema.sql
│   ├── analytics.sql
│   ├── fundamental_analytics.sql
│   └── triggers.sql
├── powerbi/
│   └── DASHBOARD.md
├── genai/
│   └── text_to_sql.py
└── reports/
```

## Run locally

```bash
pip install -r requirements.txt
python src/run_pipeline.py
```

For the full financial-intelligence workflow, place the verified fundamentals CSV in `data/raw/company_fundamentals.csv` and run the ETL before loading PostgreSQL.

## SQL analytics

The project deliberately demonstrates the SQL skills required for an analyst/data-intelligence workflow:

- Multi-table joins
- CTEs
- `LAG`, `LEAD`, `RANK`, `ROW_NUMBER`
- Running calculations with window functions
- Reusable views
- Trigger-based audit controls
- Indexes and query-friendly keys

## Power BI

See `powerbi/DASHBOARD.md` for the dashboard specification:

1. Executive Financial Overview
2. Company Performance
3. Market Performance & Risk
4. Valuation & Screening

## Scope and honesty

The project does not claim data or metrics that are not present in the supplied sources. In particular, revenue, EBITDA, EPS, market capitalization, P/E and EV/EBITDA are only calculated when their required real inputs are available.

Spark, Databricks and Snowflake are **not falsely claimed as implemented technologies**. Python is the implemented data-engineering layer.

## Disclaimer

This project is for educational and portfolio analytics. It does not provide personalized investment recommendations.
