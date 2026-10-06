# SQL Installation

The files in this folder are the **release installation scripts**.

Run them in this order:

```text
00_CREATE_DATABASES.sql
01_BANKA_DB.sql
02_BANKB_DB.sql
03_LOGGING.sql
04_STORED_PROCEDURES.sql
05_SEED_DATA.sql
06_final_verification.sql   # verification only
```

## Important

The subfolder:

```text
archive/original-development/
```

contains the SQL files used during development.

They are preserved for traceability, but they are **not** the recommended clean-install sequence.

Why:

- the original Bank A seed script inserts fixed rows without checking whether they already exist;
- the original integration-log creation script starts with `DROP TABLE`, which is destructive;
- the original archived ID-removal script is a migration from an older schema and is not needed on a fresh installation;
- the final release stored procedure includes the tested duplicate-idempotency protection before debit.

Use the release scripts in the parent `sql/` folder for a new machine.
