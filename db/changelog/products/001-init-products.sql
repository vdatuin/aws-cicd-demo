--changeset vdatuin:init-products labels:products
CREATE TABLE IF NOT EXISTS products (
  product_id   BIGSERIAL PRIMARY KEY,
  product_sku  TEXT        NOT NULL UNIQUE,
  product_name TEXT        NOT NULL,
  unit_price   NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
  is_active    BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
--rollback DROP TABLE IF EXISTS products;
