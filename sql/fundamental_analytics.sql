-- 1. Revenue growth with CTE + LAG.
WITH yearly AS (
    SELECT
        c.ticker,
        c.company_name,
        EXTRACT(YEAR FROM f.report_date)::int AS year,
        f.revenue,
        LAG(f.revenue) OVER (
            PARTITION BY f.company_id
            ORDER BY f.report_date
        ) AS previous_revenue
    FROM fact_financials f
    JOIN dim_company c ON c.company_id = f.company_id
)
SELECT
    ticker,
    company_name,
    year,
    revenue,
    ROUND(((revenue - previous_revenue) / NULLIF(previous_revenue, 0) * 100)::numeric, 2) AS revenue_growth_pct
FROM yearly
ORDER BY ticker, year;

-- 2. Profitability metrics when the underlying values exist.
SELECT
    c.ticker,
    c.company_name,
    f.report_date,
    f.revenue,
    f.ebitda,
    f.net_income,
    ROUND((f.ebitda / NULLIF(f.revenue, 0) * 100)::numeric, 2) AS ebitda_margin_pct,
    ROUND((f.net_income / NULLIF(f.revenue, 0) * 100)::numeric, 2) AS net_margin_pct
FROM fact_financials f
JOIN dim_company c ON c.company_id = f.company_id
ORDER BY c.ticker, f.report_date;

-- 3. Latest financial snapshot per company using ROW_NUMBER.
WITH ranked AS (
    SELECT
        f.*,
        ROW_NUMBER() OVER (
            PARTITION BY f.company_id
            ORDER BY f.report_date DESC
        ) AS rn
    FROM fact_financials f
)
SELECT c.ticker, c.company_name, r.report_date,
       r.revenue, r.ebitda, r.net_income, r.eps,
       r.market_cap, r.enterprise_value
FROM ranked r
JOIN dim_company c ON c.company_id = r.company_id
WHERE r.rn = 1;

-- 4. Optional valuation metrics. These are calculated only when inputs exist.
SELECT
    c.ticker,
    c.company_name,
    f.report_date,
    f.market_cap,
    f.enterprise_value,
    ROUND((f.market_cap / NULLIF(f.net_income, 0))::numeric, 2) AS pe_ratio,
    ROUND((f.enterprise_value / NULLIF(f.ebitda, 0))::numeric, 2) AS ev_to_ebitda
FROM fact_financials f
JOIN dim_company c ON c.company_id = f.company_id
WHERE f.market_cap IS NOT NULL
   OR f.enterprise_value IS NOT NULL;

-- 5. Sector comparison.
WITH latest AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY company_id ORDER BY report_date DESC
    ) AS rn
    FROM fact_financials
)
SELECT
    c.sector,
    COUNT(*) AS companies,
    ROUND(AVG(l.revenue)::numeric, 2) AS avg_revenue,
    ROUND(AVG(l.ebitda / NULLIF(l.revenue, 0) * 100)::numeric, 2) AS avg_ebitda_margin_pct
FROM latest l
JOIN dim_company c ON c.company_id = l.company_id
WHERE l.rn = 1
GROUP BY c.sector
ORDER BY avg_revenue DESC;

-- Reusable view for Power BI.
CREATE OR REPLACE VIEW vw_financial_latest AS
WITH ranked AS (
    SELECT f.*, ROW_NUMBER() OVER (
        PARTITION BY company_id ORDER BY report_date DESC
    ) AS rn
    FROM fact_financials f
)
SELECT c.ticker, c.company_name, c.sector, c.industry,
       r.report_date, r.revenue, r.ebitda, r.net_income, r.eps,
       r.total_assets, r.total_debt, r.market_cap, r.enterprise_value,
       (r.ebitda / NULLIF(r.revenue, 0) * 100) AS ebitda_margin_pct,
       (r.net_income / NULLIF(r.revenue, 0) * 100) AS net_margin_pct
FROM ranked r
JOIN dim_company c ON c.company_id = r.company_id
WHERE r.rn = 1;
