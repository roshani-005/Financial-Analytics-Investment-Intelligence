# Power BI — Financial Data Intelligence Dashboard

Connect Power BI to PostgreSQL and use the curated analytical views, especially `vw_financial_latest` and the market trend view.

## Page 1 — Executive Financial Overview

KPI cards:
- Revenue
- EBITDA
- Net Income
- Revenue Growth %
- EBITDA Margin %
- Net Margin %
- Market Capitalization (when available)

Visuals:
- Revenue / EBITDA / Net Income trend
- Company and sector slicers
- Latest-period company comparison

## Page 2 — Company Performance

- Revenue trend by reporting period
- EBITDA trend
- EPS trend
- Profitability margin trend
- Latest-period company ranking

Suggested DAX measures:

```DAX
Total Revenue = SUM(financials[revenue])
Total EBITDA = SUM(financials[ebitda])
Total Net Income = SUM(financials[net_income])
EBITDA Margin % = DIVIDE([Total EBITDA], [Total Revenue])
Net Margin % = DIVIDE([Total Net Income], [Total Revenue])
```

## Page 3 — Market Performance & Risk

- Daily close trend
- Daily return
- 20-day rolling volatility
- 20/50-day moving averages
- Drawdown
- Volume trend

## Page 4 — Valuation & Screening

Only display valuation metrics when their required real inputs exist:

- P/E = Market Cap / Net Income
- EV/EBITDA = Enterprise Value / EBITDA
- Revenue Growth %
- EBITDA Margin %
- Net Margin %

Screening examples:
- High revenue growth
- Positive profitability
- Margin improvement
- Configurable valuation threshold

The dashboard is an analytical screening tool and does not make personalized investment recommendations.
