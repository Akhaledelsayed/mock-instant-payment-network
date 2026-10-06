# Message Flow Description

## BANKA_APP

```text
HTTPInput
→ CaptureRequestTime
→ ValidatePayment
→ ValidationOK
→ CheckSourceAccount
→ AccountOK
→ CheckIdempotency
→ IdempotencyOK
→ GenerateTransactionId
→ LogAndProcess
    ├─ BuildInboundLog → PAYMENT.LOG.EVENTS
    └─ CreateTransactionAndDebit
       → BANKA.PAYMENT.REQUEST
       → LogBankResponseAndReply
          ├─ BuildBankResponseLog → PAYMENT.LOG.EVENTS
          └─ BuildCleanBankAResponse → HTTPReply
```

## IPN_GATEWAY_APP

```text
BANKA.PAYMENT.REQUEST
→ BuildMockIPNRequest
→ log mock request
→ call Mock IPN
→ log mock response/final response
→ build Bank B payment
→ BANKB.PAYMENT.REQUEST
```

## BANKB_APP

```text
BANKB.PAYMENT.REQUEST
→ CreditBankBAccount
→ SP_CREDIT_BANKB_PAYMENT
```

## LOGGING_APP

```text
PAYMENT.LOG.EVENTS
→ WritePaymentLog
→ SP_UPSERT_PAYMENT_LOG_EVENT
```
