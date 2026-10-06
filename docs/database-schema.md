# Database Schema

## BANKA_DB

`CUSTOMERS`: customer_id, customer_name, status

`ACCOUNTS`: account_id, customer_id, balance, currency, status

`PAYMENT_TRANSACTIONS`:
- transaction_id
- idempotency_key
- source_account
- destination_bank
- destination_account
- amount
- currency
- status
- created_at
- updated_at
- request_hash

`PAYMENT_INTEGRATION_LOG`:
- transaction_id
- inbound_request / time
- bank_response / time
- mock_request / time
- mock_response / time
- final_response / time
- status
- error_code
- error_message
- error_time
- created_at
- updated_at

## BANKB_DB

`CUSTOMERS`: customer_id, customer_name, status

`ACCOUNTS`: account_id, customer_id, balance, currency, status

`PAYMENT_TRANSACTIONS`:
- transaction_id
- idempotency_key
- source_bank
- source_account
- destination_bank
- destination_account
- amount
- currency
- status
- created_at
- updated_at
