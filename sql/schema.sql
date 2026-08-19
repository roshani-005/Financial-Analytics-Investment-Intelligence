CREATE TABLE IF NOT EXISTS dim_date (
    date_id DATE PRIMARY KEY,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day_of_week VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_company (
    company_id SERIAL PRIMARY KEY,
    ticker VARCHAR(15) UNIQUE NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    sector VARCHAR(100),
    industry VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS fact_market_daily (
    date_id DATE NOT NULL REFERENCES dim_date(date_id),
    company_id INT NOT NULL REFERENCES dim_company(company_id),
    open NUMERIC(18,4) NOT NULL,
    high NUMERIC(18,4) NOT NULL,
    low NUMERIC(18,4) NOT NULL,
    close NUMERIC(18,4) NOT NULL,
    volume BIGINT NOT NULL,
    daily_return NUMERIC(18,8),
    daily_range_pct NUMERIC(18,8),
    sma_20 NUMERIC(18,4),
    sma_50 NUMERIC(18,4),
    rolling_volatility_20d NUMERIC(18,8),
    drawdown NUMERIC(18,8),
    PRIMARY KEY (date_id, company_id),
    CHECK (high >= low),
    CHECK (volume >= 0)
);

CREATE TABLE IF NOT EXISTS fact_financials (
    company_id INT NOT NULL REFERENCES dim_company(company_id),
    report_date DATE NOT NULL,
    revenue NUMERIC(20,2),
    ebitda NUMERIC(20,2),
    net_income NUMERIC(20,2),
    eps NUMERIC(18,6),
    total_assets NUMERIC(20,2),
    total_debt NUMERIC(20,2),
    market_cap NUMERIC(20,2),
    enterprise_value NUMERIC(20,2),
    PRIMARY KEY (company_id, report_date)
);

CREATE INDEX IF NOT EXISTS idx_market_company_date ON fact_market_daily(company_id, date_id);
CREATE INDEX IF NOT EXISTS idx_market_close ON fact_market_daily(close);
CREATE INDEX IF NOT EXISTS idx_financial_company_report ON fact_financials(company_id, report_date);
CREATE INDEX IF NOT EXISTS idx_company_sector ON dim_company(sector);
