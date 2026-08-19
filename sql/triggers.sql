CREATE TABLE IF NOT EXISTS market_audit (
    audit_id BIGSERIAL PRIMARY KEY,
    event_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    operation VARCHAR(20),
    date_id DATE,
    asset_id INT
);

CREATE OR REPLACE FUNCTION audit_market_change() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO market_audit(operation, date_id, asset_id)
    VALUES (TG_OP, COALESCE(NEW.date_id, OLD.date_id), COALESCE(NEW.asset_id, OLD.asset_id));
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_market_audit ON fact_market_daily;
CREATE TRIGGER trg_market_audit
AFTER INSERT OR UPDATE OR DELETE ON fact_market_daily
FOR EACH ROW EXECUTE FUNCTION audit_market_change();
