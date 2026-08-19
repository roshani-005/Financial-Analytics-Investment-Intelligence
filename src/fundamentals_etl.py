"""ETL validation for a verified company-fundamentals CSV.

The module deliberately refuses to manufacture financial values. Missing optional
metrics remain null and are excluded from derived valuation calculations.
"""
from pathlib import Path
import pandas as pd

REQUIRED = ["Ticker", "Company", "Revenue", "EBITDA", "Net_Income", "EPS"]
OPTIONAL = [
    "Report_Date", "Year", "Total_Assets", "Total_Debt",
    "Market_Cap", "Enterprise_Value", "Sector", "Industry"
]


def clean_fundamentals(path: str | Path) -> pd.DataFrame:
    df = pd.read_csv(path)
    missing = [c for c in REQUIRED if c not in df.columns]
    if missing:
        raise ValueError(f"Fundamentals file is missing required columns: {missing}")

    df = df.copy()
    df.columns = [c.strip() for c in df.columns]
    df["Ticker"] = df["Ticker"].astype(str).str.strip().str.upper()
    df["Company"] = df["Company"].astype(str).str.strip()

    date_col = "Report_Date" if "Report_Date" in df.columns else "Year"
    if date_col == "Report_Date":
        df["Report_Date"] = pd.to_datetime(df["Report_Date"], errors="coerce")
        if df["Report_Date"].isna().any():
            raise ValueError("Invalid Report_Date values found")
    else:
        df["Report_Date"] = pd.to_datetime(df["Year"].astype(str) + "-12-31", errors="coerce")

    numeric_cols = [
        "Revenue", "EBITDA", "Net_Income", "EPS", "Total_Assets",
        "Total_Debt", "Market_Cap", "Enterprise_Value"
    ]
    for col in numeric_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    df = df.drop_duplicates(subset=["Ticker", "Report_Date"], keep="last")
    if (df["Revenue"] < 0).any():
        raise ValueError("Revenue contains negative values; review source data")

    return df


if __name__ == "__main__":
    source = Path("data/raw/company_fundamentals.csv")
    cleaned = clean_fundamentals(source)
    output = Path("data/processed/company_fundamentals_clean.csv")
    output.parent.mkdir(parents=True, exist_ok=True)
    cleaned.to_csv(output, index=False)
    print(f"Saved {len(cleaned):,} cleaned fundamentals rows to {output}")
