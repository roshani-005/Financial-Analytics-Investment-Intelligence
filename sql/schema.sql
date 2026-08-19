CREATE TABLE IF NOT EXISTS dim_date (
    date_id DATE PRIMARY KEY,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day_of_week VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_asset (
    asset_id SERIAL PRIMARY KEY,
    ticker VARCHAR(10) UNIQUE NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    sector VARCHAR(100),
    industry VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS fact_market_daily (
    date_id DATE NOT NULL REFERENCES dim_date(date_id),
    asset_id INT NOT NULL REFERENCES dim_asset(asset_id),
    open NUMERIC(14,4) NOT NULL,
    high NUMERIC(14,4) NOT NULL,
    low NUMERIC(14,4) NOT NULL,
    close NUMERIC(14,4) NOT NULL,
    volume BIGINT NOT NULL,
    daily_return NUMERIC(14,8),
    daily_range_pct NUMERIC(14,8),
    sma_20 NUMERIC(14,4),
    sma_50 NUMERIC(14,4),
    rolling_volatility_20d NUMERIC(14,8),
    drawdown NUMERIC(14,8),
    PRIMARY KEY (date_id, asset_id)
);

CREATE INDEX IF NOT EXISTS idx_market_asset_date ON fact_market_daily(asset_id, date_id);
CREATE INDEX IF NOT EXISTS idx_market_close ON fact_market_daily(close);
