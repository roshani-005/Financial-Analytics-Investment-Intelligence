# Financial Data Intelligence & Investment Analytics

An end-to-end financial analytics project built around real historical **Tesla (TSLA)** market data. The project demonstrates Python data gathering/cleansing, ETL, PostgreSQL relational design, advanced SQL, Power BI analytics, XGBoost forecasting, database optimization, and a basic safe natural-language-to-SQL concept.

## Dataset

The supplied `data/raw/TSLA.csv` contains **2,766 daily records from 2015-01-02 through 2025-12-31** with Date, Open, High, Low, Close and Volume. The raw file has no missing values and no duplicate rows.

The project does **not** invent revenue, EBITDA, EPS, P/E, EV/EBITDA or other financial fundamentals that are absent from the supplied source.

## Architecture

```text
TSLA CSV
   ↓
Python ETL
   ↓
Cleaning + validation + feature engineering
   ↓
PostgreSQL relational model
   ↓
SQL analytics (Joins / CTEs / Views / Window Functions / Triggers)
   ↓
Power BI dashboard
   ↓
XGBoost next-day close forecasting
   ↓
Basic safe natural-language → SQL concept
```

## Run locally

```bash
pip install -r requirements.txt
python src/run_pipeline.py
```

Outputs:
- `data/processed/tsla_daily_features.csv`
- `data/processed/data_quality_report.csv`
- `reports/forecast_test_results.csv`
- `reports/forecast_metrics.json`

## PostgreSQL

1. Create a PostgreSQL database.
2. Run `sql/schema.sql`.
3. Use `src/load_postgres.py` to load the processed dataset.
4. Run `sql/analytics.sql` and `sql/triggers.sql`.

## Power BI

See `powerbi/DASHBOARD.md` for the four-page dashboard design and DAX measures.

## Scope and honesty

The project demonstrates the requested Python, ETL, Power BI, DBMS, SQL, analytics, data-engineering, relational-design and GenAI concepts without falsely claiming technologies that are not implemented. Spark/Databricks/Snowflake are not required for this version.

The supplied dataset is market-price data only, so this version focuses on market analytics and forecasting. A verified fundamentals dataset can later be joined by ticker and reporting period if fundamental valuation analysis is required.

## Disclaimer

This project is for educational and portfolio analytics. It does not provide personalized investment recommendations.
