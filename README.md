# Financial Data Intelligence & Investment Analytics

An end-to-end financial analytics project built around real historical **Tesla (TSLA)** market data. The project demonstrates Python data gathering/cleansing, ETL, PostgreSQL relational design, advanced SQL, Power BI analytics, XGBoost forecasting, database optimization, and a basic safe natural-language-to-SQL concept.

## Dataset

The supplied source contains **2,766 daily records from 2015-01-02 through 2025-12-31** with Date, Open, High, Low, Close and Volume. The raw source has no missing values and no duplicate rows.

A real source sample is committed at `data/raw/TSLA_sample.csv`. Place the complete supplied file at `data/raw/TSLA.csv` before running the full pipeline. The project does not replace missing financial fundamentals with synthetic values.

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

The project demonstrates Python, ETL, Power BI, DBMS, SQL, analytics, data-engineering, relational-design and basic GenAI concepts without falsely claiming technologies that are not implemented. Spark/Databricks/Snowflake are not falsely claimed.

The supplied dataset is market-price data only, so this version focuses on market analytics and forecasting. It does **not** fabricate revenue, EBITDA, EPS, market capitalization, P/E or EV/EBITDA. A verified fundamentals dataset can later be joined by ticker and reporting period if fundamental valuation analysis is required.

## Validation result from the full supplied source

- 2,766 rows processed
- 0 duplicate dates
- 0 source missing values
- 0 invalid OHLC relationships
- 0 non-positive volumes
- XGBoost chronological 80/20 holdout: MAE **22.17**, RMSE **36.18**

## Disclaimer

This project is for educational and portfolio analytics. It does not provide personalized investment recommendations.
