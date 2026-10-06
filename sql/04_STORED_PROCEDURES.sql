USE BANKA_DB;
GO

CREATE OR ALTER PROCEDURE dbo.SP_CREATE_AND_DEBIT_PAYMENT
    @transaction_id      VARCHAR(50),
    @idempotency_key     VARCHAR(100),
    @source_account      VARCHAR(20),
    @destination_bank    VARCHAR(20),
    @destination_account VARCHAR(20),
    @amount              DECIMAL(18,2),
    @currency            CHAR(3)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (
        SELECT 1 FROM dbo.PAYMENT_TRANSACTIONS
        WHERE idempotency_key = @idempotency_key
    )
    BEGIN
        THROW 50010, 'Duplicate idempotency key blocked before debit', 1;
    END;

    UPDATE dbo.ACCOUNTS
    SET balance = balance - @amount
    WHERE account_id = @source_account
      AND status = 'ACTIVE'
      AND currency = @currency
      AND balance >= @amount;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Debit failed', 1;

    INSERT INTO dbo.PAYMENT_TRANSACTIONS
    (
        transaction_id, idempotency_key, source_account,
        destination_bank, destination_account, amount, currency, status
    )
    VALUES
    (
        @transaction_id, @idempotency_key, @source_account,
        @destination_bank, @destination_account, @amount, @currency, 'DEBITED'
    );
END;
GO

USE BANKB_DB;
GO

CREATE OR ALTER PROCEDURE dbo.SP_CREDIT_BANKB_PAYMENT
    @transaction_id      VARCHAR(50),
    @idempotency_key     VARCHAR(100),
    @source_bank         VARCHAR(20),
    @source_account      VARCHAR(20),
    @destination_bank    VARCHAR(20),
    @destination_account VARCHAR(20),
    @amount              DECIMAL(18,2),
    @currency            CHAR(3)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (
        SELECT 1 FROM dbo.PAYMENT_TRANSACTIONS
        WHERE idempotency_key = @idempotency_key
    )
    BEGIN
        RETURN;
    END;

    UPDATE dbo.ACCOUNTS
    SET balance = balance + @amount
    WHERE account_id = @destination_account
      AND status = 'ACTIVE'
      AND currency = @currency;

    IF @@ROWCOUNT = 0
        THROW 51001, 'Bank B credit failed: destination account invalid', 1;

    INSERT INTO dbo.PAYMENT_TRANSACTIONS
    (
        transaction_id, idempotency_key, source_bank, source_account,
        destination_bank, destination_account, amount, currency, status
    )
    VALUES
    (
        @transaction_id, @idempotency_key, @source_bank, @source_account,
        @destination_bank, @destination_account, @amount, @currency, 'CREDITED'
    );
END;
GO
