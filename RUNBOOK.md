# Reproducible Setup Runbook

This runbook is the intended path for someone cloning the repository onto another Windows development machine.

## 1. Prerequisites

Install:

- IBM App Connect Enterprise 13.x
- IBM MQ
- Microsoft SQL Server
- SQL Server Management Studio
- Microsoft ODBC Driver 18 for SQL Server
- Postman

The verified development environment used ACE 13.0.8.0.

## 2. Create/start the MQ queue manager

If `QM_IPN_LAB` does not exist, create it from an IBM MQ command prompt:

```cmd
crtmqm QM_IPN_LAB
strmqm QM_IPN_LAB
```

Then configure queues:

```cmd
"C:\Program Files\IBM\MQ\bin\runmqsc.exe" QM_IPN_LAB < mq\setup-queues.mqsc
```

## 3. Create SQL databases and objects

Open SSMS and run the release SQL files in this exact order:

```text
sql/00_CREATE_DATABASES.sql
sql/01_BANKA_DB.sql
sql/02_BANKB_DB.sql
sql/03_LOGGING.sql
sql/04_STORED_PROCEDURES.sql
sql/05_SEED_DATA.sql
```

Do not run `sql/archive/original-development/` as a fresh-install sequence.

## 4. Configure 64-bit ODBC

Open:

```text
C:\Windows\System32\odbcad32.exe
```

Create:

### BANKA_DSN

- System DSN
- ODBC Driver 18 for SQL Server
- local SQL Server instance
- Integrated Windows authentication
- default database: `BANKA_DB`

### BANKB_DSN_NOENC

- System DSN
- ODBC Driver 18 for SQL Server
- local SQL Server instance
- Integrated Windows authentication
- default database: `BANKB_DB`
- encryption: Optional
- trust server certificate: Yes

For a non-lab environment, use a properly trusted SQL Server certificate instead of copying the local trust setting blindly.

## 5. Import the ACE projects

Import these four projects into ACE Toolkit:

```text
BANKA_APP
BANKB_APP
IPN_GATEWAY_APP
LOGGING_APP
```

Do not import the local `GEMINI_SERVER` work directory.

Create a local Integration Server, then deploy the four applications.

Verified HTTP listener:

```text
http://localhost:7801
```

Verified payment endpoint:

```text
POST http://localhost:7801/api/v1/payments
```

## 6. Configure the Mock IPN endpoint

The IPN Gateway contains the outbound HTTPRequest node used to call the Postman Mock Server.

Set that node to a mock endpoint that returns:

```json
{
  "success": true,
  "networkStatus": "ACCEPTED",
  "message": "Payment accepted by Mock IPN"
}
```

Do not commit a private/temporary mock URL if it should remain private. Document it as a local runtime configuration instead.

## 7. Import Postman

Import:

```text
postman/IPN_MOCK_PROJECT.postman_collection.json
```

The Bank A base URL is:

```text
http://localhost:7801
```

## 8. Run the functional tests

### New payment

Use a new idempotency key.

Expected:

- Bank A: one `DEBITED` row
- Bank B: one `CREDITED` row
- integration log: `ACCEPTED`
- request/log queues return to depth `0`

### Duplicate replay

Submit the exact same payment with the exact same idempotency key.

Expected:

- `duplicate = true`
- same transaction ID returned
- no second debit
- no second credit

### Idempotency conflict

Reuse the same key but change the payment amount.

Expected response body includes:

```text
IDEMPOTENCY_CONFLICT
```

The project currently returns HTTP 200 for this business-level conflict by design.

### Backout test

Send an invalid Bank B destination account directly to `BANKB.PAYMENT.REQUEST`.

Expected after retry threshold:

```text
BANKB.PAYMENT.REQUEST = 0
BANKB.PAYMENT.BACKOUT = 1
```

No Bank B transaction row should be created.

Clear the backout test message after capturing evidence.

## 9. Final verification

Run:

```text
sql/06_final_verification.sql
```

Then confirm all MQ queue depths are `0`.
