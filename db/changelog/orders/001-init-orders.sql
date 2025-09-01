--changeset vdatuin:init-orders labels:orders
CREATE TABLE IF NOT EXISTS orders (
  order_id    BIGSERIAL PRIMARY KEY,
  customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
  order_date  DATE NOT NULL,
  product_sku TEXT NOT NULL,
  quantity    INTEGER NOT NULL CHECK (quantity > 0),
  unit_price  NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
--rollback DROP INDEX IF EXISTS idx_orders_customer_id; DROP TABLE IF EXISTS orders;
