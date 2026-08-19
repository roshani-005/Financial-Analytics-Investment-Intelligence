from pathlib import Path
import os
import pandas as pd
from sqlalchemy import create_engine

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'data' / 'processed' / 'tsla_daily_features.csv'


def load():
    url = os.getenv('DATABASE_URL')
    if not url:
        raise RuntimeError('Set DATABASE_URL, e.g. postgresql+psycopg2://user:password@localhost:5432/financial_analytics')
    df = pd.read_csv(DATA, parse_dates=['date'])
    engine = create_engine(url)
    columns = ['date','open','high','low','close','volume','daily_return','daily_range_pct','sma_20','sma_50','rolling_volatility_20d','drawdown']
    df[columns].to_sql('staging_market_daily', engine, if_exists='replace', index=False)
    print(f'Loaded {len(df):,} rows into staging_market_daily')

if __name__ == '__main__':
    load()
