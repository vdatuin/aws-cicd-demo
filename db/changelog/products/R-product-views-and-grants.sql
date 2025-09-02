--changeset vdatuin:vw-product-sales runOnChange:true labels:products
CREATE OR REPLACE VIEW vw_product_sales AS
SELECT 
  p.product_sku,
  p.product_name,
  p.unit_price,
  SUM(o.quantity)                    AS total_qty,
  SUM(o.quantity * o.unit_price)     AS total_sales,
  MIN(o.order_date)                  AS first_order_date,
  MAX(o.order_date)                  AS last_order_date
FROM products p
LEFT JOIN orders o ON o.product_sku = p.product_sku
GROUP BY p.product_sku, p.product_name, p.unit_price;

--changeset vdatuin:products-grants runOnChange:true labels:products
-- Example:
-- GRANT SELECT ON products TO app_readonly;
-- GRANT SELECT ON vw_product_sales TO app_readonly;
