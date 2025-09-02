--changeset vdatuin:idx-orders-customer-date labels:orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_date ON orders(customer_id, order_date);
--rollback DROP INDEX IF EXISTS idx_orders_customer_date;
