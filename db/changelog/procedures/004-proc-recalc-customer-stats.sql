--changeset vdatuin:proc-recalc-customer-stats labels:procedures
CREATE TABLE IF NOT EXISTS customer_stats (
  customer_id  BIGINT PRIMARY KEY REFERENCES customers(customer_id),
  total_orders INTEGER NOT NULL,
  total_spend  NUMERIC(14,2) NOT NULL,
  last_order   DATE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE PROCEDURE recalc_customer_stats()
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO customer_stats (customer_id, total_orders, total_spend, last_order, updated_at)
  SELECT c.customer_id,
         COUNT(o.order_id),
         COALESCE(SUM(o.quantity * o.unit_price), 0)::NUMERIC(14,2),
         MAX(o.order_date),
         NOW()
  FROM customers c
  LEFT JOIN orders o ON o.customer_id = c.customer_id
  GROUP BY c.customer_id
  ON CONFLICT (customer_id) DO UPDATE
    SET total_orders = EXCLUDED.total_orders,
        total_spend  = EXCLUDED.total_spend,
        last_order   = EXCLUDED.last_order,
        updated_at   = NOW();
END;
$$;
--rollback DROP PROCEDURE IF EXISTS recalc_customer_stats(); DROP TABLE IF EXISTS customer_stats;
