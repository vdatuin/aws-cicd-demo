--changeset vdatuin:insert-products labels:products
INSERT INTO products (product_sku, product_name, unit_price, is_active)
VALUES
  ('SKU-001', 'Standard Widget', 100.00, TRUE),
  ('SKU-002', 'Deluxe Widget',   250.00, TRUE)
ON CONFLICT (product_sku) DO NOTHING;

--rollback 
DELETE FROM products 
WHERE product_sku IN ('SKU-001','SKU-002');
