# CI/CD Overview

This project uses **GitHub Actions** to implement Continuous Integration (CI) and Continuous Delivery or Deployment (CD) for both **Python application code** and **Database schema migrations with Liquibase**.

- **CI for Python and DB** runs on pull requests to `develop` to validate code quality and database changes safely.
- **CD for Python** packages and publishes build artifacts to S3 on branch pushes.
- **CD for Database** applies Liquibase migrations to AWS RDS on branch pushes.  
  - `develop` → Dev DB  
  - `main` / `prod-*` → Prod DB

---

## Python Pipeline

### Triggers
- **CI**: pull request to `develop` from feature branches  
- **CD**: push to `develop`, `main`, or tags that match `prod-*`

### Flow

**CI (Python):**
- PR from `feature/*` to `develop`
- Checkout repository
- Setup Python 3.12
- Install dependencies
- Run flake8 lint
- Run pytest with coverage
- Run SonarCloud scan
- Upload artifacts

**CD (Python):**
- Push to `develop`, `main`, or `prod-*` tag
- Determine environment (dev or prod)
- Build Python wheel
- Run demo script
- Assume AWS role (OIDC)
- Upload to S3 bucket


---

## Outputs

- PR decoration for bugs, smells, and coverage via SonarCloud  
- Build artifacts in S3:  
  `s3://dxc-cicd-artifacts-bucket/{dev|prod}/{run_id-run_attempt}/`

---
## AWS Postgres Database Pipeline with Liquibase

### CI (validate migrations locally on PR)

- **Trigger**: pull request to `develop` from feature branches
- **Steps**:
  - Start Postgres 14 service in the job
  - Create `cicddemodb`, ensure `app_readonly` role
  - Run `liquibase validate` on `db/changelog/master.yaml`
  - Run `liquibase update` to apply to local Postgres
  - Run optional post-deploy SQL and smoke queries

---

### CD (apply to AWS RDS on branch push)

- **Trigger**: push to `develop`, `main`, or `prod-*` tags
- **Mapping**:
  - `develop` → `appdb` (Dev)
  - `main` or `prod-*` → `appdb_prod` (Prod)
- **Steps**:
  - Convert PPK to PEM (from secret), open SSH tunnel to bastion
  - Run connectivity checks (`nc`, `pg_isready`)
  - Ensure target DB exists and `app_readonly` role exists
  - Run `liquibase validate`
  - Run `liquibase update` (via tunnel)
  - Run optional post-deploy SQL
  - Close SSH tunnel

---

## Branch and Environment Matrix

| Source | Pipeline | Target |
|--------|----------|--------|
| feature → develop (PR) | Python CI, DB CI | Tests, lint, unit tests, coverage, Sonar; Liquibase validate/update on local Postgres |
| develop (push) | Python CD, DB CD | Upload Python artifacts to S3 (dev prefix); apply DB migrations to Dev RDS (`appdb`) |
| main (push) / prod-* (tag) | Python CD, DB CD | Upload Python artifacts to S3 (prod prefix); apply DB migrations to Prod RDS (`appdb_prod`) |

---

## Secrets and Inputs Summary

### Python CD
- `AWS OIDC` roles (Dev/Prod)
- `AWS_REGION`
- `BUCKET_NAME`

### DB CD
- `BASTION_PPK` (private key for bastion SSH tunnel)
- `RDS_PASSWORD` (Postgres password, injected via secret)

### SonarCloud (Python CI)
- `SONAR_TOKEN`
