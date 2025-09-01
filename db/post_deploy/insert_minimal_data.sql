-- Insert a sample customer
INSERT INTO customers (customer_code, customer_name, email)
VALUES 
  ('CUST-001','Acme Trading','acme@example.com')
ON CONFLICT (customer_code) DO NOTHING;

-- Insert sample products
INSERT INTO products (product_sku, product_name, unit_price, is_active)
VALUES
  ('SKU-001','Standard Widget',100.00,TRUE),
  ('SKU-002','Deluxe Widget', 250.00,TRUE)
ON CONFLICT (product_sku) DO NOTHING;

-- Insert sample orders for the customer and products
INSERT INTO orders (customer_id, order_date, product_sku, quantity, unit_price, status)
SELECT c.customer_id, CURRENT_DATE - 5, 'SKU-001', 3, 100.00, 'PAID'
FROM customers c
WHERE c.customer_code = 'CUST-001'
ON CONFLICT DO NOTHING;

INSERT INTO orders (customer_id, order_date, product_sku, quantity, unit_price, status)
SELECT c.customer_id, CURRENT_DATE - 2, 'SKU-002', 1, 250.00, 'PAID'
FROM customers c
WHERE c.customer_code = 'CUST-001'
ON CONFLICT DO NOTHING;

-- Refresh aggregate stats
CALL recalc_customer_stats();
