from pathlib import Path
import json
import numpy as np
import pandas as pd
from sklearn.metrics import mean_absolute_error, mean_squared_error
from xgboost import XGBRegressor

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'data' / 'processed' / 'tsla_daily_features.csv'
REPORTS = ROOT / 'reports'
FEATURES = ['open','high','low','volume','daily_return','daily_range_pct','sma_20','sma_50','ema_20','rolling_volatility_20d','rolling_high_20d','rolling_low_20d','drawdown','lag_1','lag_5','lag_10','lag_20','rolling_mean_7','rolling_mean_20']


def build_model_data(df):
    df = df.copy().sort_values('date')
    for lag in [1, 5, 10, 20]:
        df[f'lag_{lag}'] = df['close'].shift(lag)
    df['rolling_mean_7'] = df['close'].shift(1).rolling(7).mean()
    df['rolling_mean_20'] = df['close'].shift(1).rolling(20).mean()
    df['target_next_close'] = df['close'].shift(-1)
    return df.dropna(subset=FEATURES + ['target_next_close'])


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    df = pd.read_csv(DATA, parse_dates=['date'])
    model_df = build_model_data(df)
    split = int(len(model_df) * 0.8)
    train, test = model_df.iloc[:split], model_df.iloc[split:]
    model = XGBRegressor(n_estimators=500, max_depth=5, learning_rate=0.03, subsample=0.8, colsample_bytree=0.8, objective='reg:squarederror', random_state=42, n_jobs=2)
    model.fit(train[FEATURES], train['target_next_close'])
    pred = model.predict(test[FEATURES])
    metrics = {'train_rows': len(train), 'test_rows': len(test), 'test_start': str(test['date'].min().date()), 'test_end': str(test['date'].max().date()), 'MAE': float(mean_absolute_error(test['target_next_close'], pred)), 'RMSE': float(np.sqrt(mean_squared_error(test['target_next_close'], pred)))}
    out = test[['date','close']].copy()
    out['actual_next_close'] = test['target_next_close'].values
    out['predicted_next_close'] = pred
    out.to_csv(REPORTS / 'forecast_test_results.csv', index=False)
    (REPORTS / 'forecast_metrics.json').write_text(json.dumps(metrics, indent=2))
    print(json.dumps(metrics, indent=2))

if __name__ == '__main__':
    main()
