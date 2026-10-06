DECLARE @transaction_id VARCHAR(50) =
    'TXN-c90d282f-bc19-49e8-bf66-170972462b86';
DECLARE @idempotency_key VARCHAR(100) =
    'IDEMP-FINAL-001';

USE BANKA_DB;

SELECT account_id,balance,currency,status
FROM dbo.ACCOUNTS WHERE account_id='A001';

SELECT transaction_id,idempotency_key,amount,currency,status,created_at
FROM dbo.PAYMENT_TRANSACTIONS
WHERE idempotency_key=@idempotency_key;

SELECT COUNT(*) AS banka_transaction_count
FROM dbo.PAYMENT_TRANSACTIONS
WHERE idempotency_key=@idempotency_key;

SELECT *
FROM dbo.PAYMENT_INTEGRATION_LOG
WHERE transaction_id=@transaction_id;

USE BANKB_DB;

SELECT account_id,balance,currency,status
FROM dbo.ACCOUNTS WHERE account_id='B001';

SELECT transaction_id,idempotency_key,amount,currency,status,created_at
FROM dbo.PAYMENT_TRANSACTIONS
WHERE idempotency_key=@idempotency_key;

SELECT COUNT(*) AS bankb_transaction_count
FROM dbo.PAYMENT_TRANSACTIONS
WHERE idempotency_key=@idempotency_key;

SELECT *
FROM dbo.PAYMENT_TRANSACTIONS
WHERE idempotency_key='IDEMP-BACKOUT-TEST-001';
