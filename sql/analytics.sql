-- Daily returns with a window function.
WITH returns AS (
    SELECT date_id, close,
           LAG(close) OVER (ORDER BY date_id) AS previous_close
    FROM fact_market_daily
)
SELECT date_id, close,
       ROUND(((close - previous_close) / NULLIF(previous_close, 0) * 100)::numeric, 2) AS return_pct
FROM returns
ORDER BY date_id;

-- Monthly performance using a CTE and LAG.
WITH monthly AS (
    SELECT DATE_TRUNC('month', date_id)::date AS month,
           MAX(close) AS month_high,
           MIN(close) AS month_low,
           (ARRAY_AGG(close ORDER BY date_id DESC))[1] AS month_close
    FROM fact_market_daily
    GROUP BY 1
), growth AS (
    SELECT *, LAG(month_close) OVER (ORDER BY month) AS previous_month_close
    FROM monthly
)
SELECT month, month_high, month_low, month_close,
       ROUND(((month_close - previous_month_close) / NULLIF(previous_month_close, 0) * 100)::numeric, 2) AS mom_return_pct
FROM growth
ORDER BY month;

-- Highest-volatility trading days.
SELECT date_id, close, daily_return, rolling_volatility_20d
FROM fact_market_daily
ORDER BY ABS(daily_return) DESC NULLS LAST
LIMIT 20;

-- Largest drawdowns.
SELECT date_id, close, drawdown
FROM fact_market_daily
ORDER BY drawdown ASC
LIMIT 20;

-- Reusable analytical view.
CREATE OR REPLACE VIEW vw_market_trend AS
SELECT date_id, close, sma_20, sma_50, rolling_volatility_20d, drawdown
FROM fact_market_daily;
