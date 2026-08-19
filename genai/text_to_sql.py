"""Basic safe natural-language-to-SQL proof of concept.

This is intentionally rule-based. It demonstrates the GenAI workflow and read-only SQL safety
boundary without pretending an external LLM/API is configured.
"""

ALLOWED = {
    'latest price': "SELECT date_id, close FROM fact_market_daily ORDER BY date_id DESC LIMIT 1;",
    'highest volatility': "SELECT date_id, rolling_volatility_20d FROM fact_market_daily ORDER BY rolling_volatility_20d DESC NULLS LAST LIMIT 10;",
    'largest drawdown': "SELECT date_id, drawdown FROM fact_market_daily ORDER BY drawdown ASC LIMIT 10;",
}


def generate_sql(question: str) -> str:
    q = question.lower().strip()
    for intent, sql in ALLOWED.items():
        if intent in q:
            return sql
    raise ValueError('Question is outside the supported read-only analytics intents.')


if __name__ == '__main__':
    print(generate_sql('show latest price'))
