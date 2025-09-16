--changeset vdatuin:ux-orders-customer-date-sku labels:orders
ALTER TABLE public.orders
  ADD CONSTRAINT ux_orders_customer_date_sku
  UNIQUE (customer_id, order_date, product_sku);

--rollback ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS ux_orders_customer_date_sku;
