--changeset vdatuin:add-order-status labels:orders
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'NEW'
  CHECK (status IN ('NEW','PAID','CANCELLED','SHIPPED'));

UPDATE orders
SET status = 'PAID'
WHERE order_date <= (CURRENT_DATE - INTERVAL '30 days')
  AND status = 'NEW';
--rollback ALTER TABLE orders DROP COLUMN IF EXISTS status;
