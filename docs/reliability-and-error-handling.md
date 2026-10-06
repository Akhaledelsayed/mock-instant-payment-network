# Reliability and Error Handling

## Idempotency

Bank A supports:
1. New key → continue processing.
2. Same key + same payment → return existing transaction; no second debit.
3. Same key + different payment → return `IDEMPOTENCY_CONFLICT`.

The SQL stored procedure independently checks for a duplicate key before debit.

## Backout strategy

Request/log queues use `BOTHRESH(3)` with dedicated backout queues.

This prevents a poison message from continuously blocking the input queue.

## Dead-letter queue

`QM_IPN_LAB` uses:

```text
IPN.DEAD.LETTER.QUEUE
```

## Verified Bank B failure test

An invalid destination account (`B999`) was sent directly to `BANKB.PAYMENT.REQUEST`.

Observed:
- no Bank B transaction created
- valid account balance unchanged
- request queue returned to depth 0
- failed message moved to `BANKB.PAYMENT.BACKOUT`
