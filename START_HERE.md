# Start Here

This ZIP is the complete handoff package for the educational Mock Instant Payment Network project.

## If you only want to understand the project

Read in this order:

1. `README.md`
2. `docs/architecture.md`
3. `docs/flow-description.md`
4. `docs/database-schema.md`
5. `docs/reliability-and-error-handling.md`
6. `docs/testing-evidence.md`

## If you want to run it on another machine

Follow:

```text
RUNBOOK.md
```

The actual ACE source projects are already included under `ace/`.

## If you want the original development artifacts

See:

```text
source-archives/
sql/archive/original-development/
postman/archive/
```

## Final verified local endpoint

```text
POST http://localhost:7801/api/v1/payments
```

## Final implementation status

The core implementation was verified for:

- Bank A debit
- MQ routing
- mock IPN call
- Bank B credit
- asynchronous audit logging
- duplicate replay protection
- idempotency conflict handling
- database duplicate protection
- clean API response
- backout queues
- dead-letter queue configuration
- poison-message protection
