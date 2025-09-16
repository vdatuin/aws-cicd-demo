-- db/changelog/shared/001-roles.sql

--changeset bootstrap:ensure-app-readonly runInTransaction:true
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_readonly') THEN
    CREATE ROLE app_readonly NOLOGIN;
  END IF;
END
$$;

-- (optional but usually useful)
--changeset bootstrap:readonly-schema-usage
GRANT USAGE ON SCHEMA public TO app_readonly;

-- (optional defaults so new tables are readable without per-table GRANTs)
-- Note: default privileges are per-OWNER. This applies to objects created by the current user (postgres).
--changeset bootstrap:readonly-default-privs
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO app_readonly;
