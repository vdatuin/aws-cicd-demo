--liquibase formatted sql
--changeset vdatuin:vw-order-summary runOnChange:true labels:customer
CREATE OR REPLACE VIEW public.vw_order_summary AS
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
FROM public.orders o
JOIN public.customers c ON c.customer_id = o.customer_id;

-- Make GRANTs run only if the role exists (clear error otherwise)
--changeset vdatuin:customer-grants runOnChange:true labels:customer
--preconditions onFail:HALT
--precondition-sql-check expectedResult:1
SELECT 1 FROM pg_roles WHERE rolname = 'app_readonly';

-- Optional but usually needed for read-only roles to access objects in public schema
GRANT USAGE ON SCHEMA public TO app_readonly;

-- Be explicit about schema & object types
GRANT SELECT ON TABLE public.customers        TO app_readonly;
GRANT SELECT ON TABLE public.orders           TO app_readonly;
GRANT SELECT ON public.vw_order_summary       TO app_readonly;
