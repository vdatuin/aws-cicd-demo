--changeset vdatuin:fk-orders-product-sku labels:orders,products
ALTER TABLE orders
  ADD CONSTRAINT orders_product_sku_fk
  FOREIGN KEY (product_sku) REFERENCES products(product_sku);
--rollback ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_product_sku_fk;
