# ACE Source Audit

The `ace/` directory contains the exact final ACE application projects exported from the working Toolkit workspace.

## Included applications

- `BANKA_APP`
- `BANKB_APP`
- `IPN_GATEWAY_APP`
- `LOGGING_APP`

## Static checks performed

- All ESQL modules referenced by the four `.msgflow` files are present in the exported projects.
- `BANKA_APP` database nodes use `BANKA_DSN`.
- `BANKB_APP` uses the verified `BANKB_DSN_NOENC` data source.
- MQ queue names in the flows match the release MQ setup:
  - `BANKA.PAYMENT.REQUEST`
  - `BANKB.PAYMENT.REQUEST`
  - `PAYMENT.LOG.EVENTS`
- Bank B MQ input uses JSON message domain.
- The final Bank A flow includes the clean-response node.
- The final Bank A flow includes idempotency check/filter logic.

## Important runtime-specific value

`IPN_GATEWAY_APP/IPNGateway_Flow.msgflow` contains the Postman Mock Server URL used during the verified local test.

That URL is not a credential, but it is environment-specific and may expire or be deleted. On another machine, create a Postman Mock Server that returns the response in:

```text
postman/mock-ipn-success-response.json
```

Then update the `CallMockIPN` HTTP Request node URL before deploying.

## Legacy source remnants preserved intentionally

The working Bank A project contains two files that are not referenced by the final message flow:

- `BankA_GenerateRequestId.esql`
- `BankA_Payment_In_BuildInboundLog.esql` (empty/legacy stub)

They are preserved because this package includes the exact working project export rather than silently rewriting the tested source.

The active `BankA_CheckSourceAccount.esql` also contains older `requestId` response assignments. The verified successful payment path and end-to-end tracking use the single `transactionId`; these older response fields were left untouched to preserve the tested project state.

For a later cleanup release, these legacy remnants can be removed and regression-tested separately.
