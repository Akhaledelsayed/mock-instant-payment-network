# Testing Evidence

## Final transaction

```text
transactionId: TXN-c90d282f-bc19-49e8-bf66-170972462b86
idempotencyKey: IDEMP-FINAL-001
amount: 1.00 EGP
```

Verified:
- Bank A status: `DEBITED`
- Bank B status: `CREDITED`
- Bank A count for key: `1`
- Bank B count for key: `1`
- integration log final status: `ACCEPTED`
- error fields: `NULL`

## Duplicate replay

The exact same payment was submitted again.

Verified:
- `duplicate = true`
- same transaction ID returned
- no second debit
- no second credit

## Conflict

Same idempotency key, different amount.

Verified:
- HTTP 200
- `success = false`
- `duplicate = false`
- `error.code = IDEMPOTENCY_CONFLICT`

## Backout

Invalid Bank B account `B999`.

Verified:
- no Bank B payment row
- valid balance unchanged
- failed message moved to Bank B backout queue
