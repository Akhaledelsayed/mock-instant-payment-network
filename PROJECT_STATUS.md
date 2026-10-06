# Final Project Status

## Verified final transaction

- `transactionId`: `TXN-c90d282f-bc19-49e8-bf66-170972462b86`
- `idempotencyKey`: `IDEMP-FINAL-001`
- amount: `1.00 EGP`
- Bank A status: `DEBITED`
- Bank B status: `CREDITED`
- integration-log final status: `ACCEPTED`
- Bank A transaction count for key: `1`
- Bank B transaction count for key: `1`

## Backout verification

An invalid Bank B destination account (`B999`) was submitted directly to `BANKB.PAYMENT.REQUEST`.

Observed:
- no Bank B transaction row was created
- valid Bank B account balance stayed unchanged
- request queue returned to depth `0`
- failing message moved to `BANKB.PAYMENT.BACKOUT`

After evidence capture, the backout queue was cleared so the final MQ baseline is clean.
