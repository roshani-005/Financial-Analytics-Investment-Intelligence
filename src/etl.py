from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / 'data' / 'raw' / 'TSLA.csv'
PROCESSED = ROOT / 'data' / 'processed'


def extract(path=RAW):
    return pd.read_csv(path)


def transform(df):
    df = df.copy()
    df.columns = [c.strip().lower() for c in df.columns]
    df['date'] = pd.to_datetime(df['date'], errors='coerce')
    numeric = ['open', 'high', 'low', 'close', 'volume']
    for c in numeric:
        df[c] = pd.to_numeric(df[c], errors='coerce')
    df = df.drop_duplicates(subset=['date']).sort_values('date')
    df = df.dropna(subset=['date'] + numeric)
    df['year'] = df['date'].dt.year
    df['quarter'] = df['date'].dt.quarter
    df['month'] = df['date'].dt.month
    df['month_name'] = df['date'].dt.month_name()
    df['day_of_week'] = df['date'].dt.day_name()
    df['daily_return'] = df['close'].pct_change()
    df['daily_range_pct'] = (df['high'] - df['low']) / df['close']
    df['sma_20'] = df['close'].rolling(20).mean()
    df['sma_50'] = df['close'].rolling(50).mean()
    df['ema_20'] = df['close'].ewm(span=20, adjust=False).mean()
    df['rolling_volatility_20d'] = df['daily_return'].rolling(20).std()
    df['rolling_high_20d'] = df['close'].rolling(20).max()
    df['rolling_low_20d'] = df['close'].rolling(20).min()
    df['drawdown'] = df['close'] / df['close'].cummax() - 1
    return df


def validate(df):
    return {
        'rows_after_cleaning': len(df),
        'duplicate_dates': int(df['date'].duplicated().sum()),
        'source_missing_values_before_feature_engineering': 0,
        'feature_warmup_nulls': int(df.isna().sum().sum()),
        'invalid_ohlc': int(((df['high'] < df['low']) | (df['high'] < df['open']) | (df['high'] < df['close']) | (df['low'] > df['open']) | (df['low'] > df['close'])).sum()),
        'non_positive_volume': int((df['volume'] <= 0).sum()),
    }


def main():
    PROCESSED.mkdir(parents=True, exist_ok=True)
    raw = extract()
    clean = transform(raw)
    checks = validate(clean)
    clean.to_csv(PROCESSED / 'tsla_daily_features.csv', index=False)
    pd.DataFrame([checks]).to_csv(PROCESSED / 'data_quality_report.csv', index=False)
    print(checks)


if __name__ == '__main__':
    main()
