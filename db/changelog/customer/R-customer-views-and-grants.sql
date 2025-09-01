--changeset vdatuin:vw-order-summary runOnChange:true labels:customer
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:1 SELECT 1 WHERE EXISTS (
  SELECT 1 FROM information_schema.tables 
  WHERE table_schema='public' AND table_name='customers'
);
--precondition-sql-check expectedResult:1 SELECT 1 WHERE EXISTS (
  SELECT 1 FROM information_schema.tables 
  WHERE table_schema='public' AND table_name='orders'
);

CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
  o.order_id,
  c.customer_code,
  c.customer_name,
  o.order_date,
  o.product_sku,
  o.quantity,
  o.unit_price,
  (o.quantity * o.unit_price) AS line_total,
  o.status
FROM public.orders  o
JOIN public.customers c ON c.customer_id = o.customer_id;

--changeset vdatuin:customer-grants runOnChange:true labels:customer
-- Example grants (adapt to your role/user setup):
GRANT SELECT ON customers TO app_readonly;
GRANT SELECT ON orders TO app_readonly;
GRANT SELECT ON vw_order_summary TO app_readonly;
