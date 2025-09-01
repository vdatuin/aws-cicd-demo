--changeset vdatuin:init-customers labels:customer
CREATE TABLE IF NOT EXISTS customers (
  customer_id   BIGSERIAL PRIMARY KEY,
  customer_code TEXT UNIQUE NOT NULL,
  customer_name TEXT NOT NULL,
  email         TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
--rollback DROP TABLE IF EXISTS customers;
