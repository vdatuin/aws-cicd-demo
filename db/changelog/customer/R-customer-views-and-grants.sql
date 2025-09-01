--changeset vdatuin:vw-order-summary runOnChange:true labels:customer
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
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id;

--changeset vdatuin:customer-grants runOnChange:true labels:customer
-- Example:
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;
