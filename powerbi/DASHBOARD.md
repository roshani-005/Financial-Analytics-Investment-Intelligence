# Power BI Dashboard Specification

## Page 1 — Executive Market Overview
- Latest Close
- YTD Return
- 20-day Volatility
- Maximum Drawdown
- Trading Volume
- Close-price line chart

## Page 2 — Performance & Risk
- Daily return distribution
- Rolling 20-day volatility
- Drawdown curve
- Monthly return matrix

## Page 3 — Trend Analytics
- Close vs SMA 20 vs SMA 50
- Close vs EMA 20
- Volume trend
- 20-day high/low band

## Page 4 — Forecasting
- Actual vs predicted next-day close
- MAE and RMSE cards
- Forecast error trend

## Suggested DAX
```DAX
Latest Close = MAX(fact_market_daily[close])

Average Volume = AVERAGE(fact_market_daily[volume])

Max Drawdown = MIN(fact_market_daily[drawdown])
```

Connect Power BI to PostgreSQL or the processed CSV. Do not claim a published `.pbix` report unless one has actually been created and published.
