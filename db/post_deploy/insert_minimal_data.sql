-- Customers: upsert (keeps data fresh if you change name/email)
INSERT INTO customers (customer_code, customer_name, email)
VALUES 
  ('CUST-001','Acme Trading','acme@example.com')
ON CONFLICT (customer_code) DO UPDATE
SET customer_name = EXCLUDED.customer_name,
    email         = EXCLUDED.email;

-- Products: upsert and refresh created_at every run
INSERT INTO products (product_sku, product_name, unit_price, is_active, created_at)
VALUES
  ('SKU-001','Standard Widget',100.00,TRUE, NOW()),
  ('SKU-002','Deluxe Widget', 250.00,TRUE, NOW())
ON CONFLICT (product_sku) DO UPDATE
SET product_name = EXCLUDED.product_name,
    unit_price   = EXCLUDED.unit_price,
    is_active    = EXCLUDED.is_active,
    created_at   = NOW();  -- refresh timestamp on every run

-- Orders: upsert by (customer_id, order_date, product_sku)
-- Requires UNIQUE(customer_id, order_date, product_sku)
-- (created earlier as ux_orders_customer_date_sku)
INSERT INTO orders (customer_id, order_date, product_sku, quantity, unit_price, status)
SELECT c.customer_id, CURRENT_DATE - 5, 'SKU-001', 3, 100.00, 'PAID'
FROM customers c
WHERE c.customer_code = 'CUST-001'
ON CONFLICT (customer_id, order_date, product_sku) DO UPDATE
SET quantity   = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    status     = EXCLUDED.status;

INSERT INTO orders (customer_id, order_date, product_sku, quantity, unit_price, status)
SELECT c.customer_id, CURRENT_DATE - 2, 'SKU-002', 1, 250.00, 'PAID'
FROM customers c
WHERE c.customer_code = 'CUST-001'
ON CONFLICT (customer_id, order_date, product_sku) DO UPDATE
SET quantity   = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    status     = EXCLUDED.status;

-- Refresh aggregate stats
CALL recalc_customer_stats();
