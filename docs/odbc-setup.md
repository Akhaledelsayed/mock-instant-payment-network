# ODBC Setup

Use 64-bit System DSNs:

```text
C:\Windows\System32\odbcad32.exe
```

## Bank A

DSN: `BANKA_DSN`

- ODBC Driver 18 for SQL Server
- Integrated Windows authentication
- default DB: `BANKA_DB`

## Bank B

Verified DSN: `BANKB_DSN_NOENC`

- ODBC Driver 18 for SQL Server
- Integrated Windows authentication
- default DB: `BANKB_DB`
- `Encrypt=Optional`
- `TrustServerCertificate=Yes`

Example PowerShell:

```powershell
Add-OdbcDsn -Name "BANKB_DSN_NOENC" `
  -DriverName "ODBC Driver 18 for SQL Server" `
  -DsnType System `
  -SetPropertyValue @(
    "Server=$SqlServer",
    "Database=BANKB_DB",
    "Trusted_Connection=Yes",
    "Encrypt=Optional",
    "TrustServerCertificate=Yes"
  )
```

For a real environment, use a properly trusted SQL Server certificate and an appropriate encryption policy.
