# Basic Generative AI Concept

A future LLM layer can translate a user's natural-language financial question into SQL, execute only allow-listed read-only statements, and turn the result back into a concise explanation.

Example:

`What was the latest price? → SQL → PostgreSQL → result → natural-language response`

The included `text_to_sql.py` is a safe rule-based proof of concept. It does not claim to contain a trained LLM or external API.
