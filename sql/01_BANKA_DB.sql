IF DB_ID('BANKA_DB') IS NULL
    CREATE DATABASE BANKA_DB;
GO

USE BANKA_DB;
GO

IF OBJECT_ID('dbo.CUSTOMERS','U') IS NULL
BEGIN
    CREATE TABLE dbo.CUSTOMERS
    (
        customer_id   INT NOT NULL PRIMARY KEY,
        customer_name NVARCHAR(100) NOT NULL,
        status        VARCHAR(20) NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.ACCOUNTS','U') IS NULL
BEGIN
    CREATE TABLE dbo.ACCOUNTS
    (
        account_id  VARCHAR(20) NOT NULL PRIMARY KEY,
        customer_id INT NOT NULL,
        balance     DECIMAL(18,2) NOT NULL,
        currency    CHAR(3) NOT NULL,
        status      VARCHAR(20) NOT NULL,
        CONSTRAINT FK_BANKA_ACCOUNTS_CUSTOMERS
            FOREIGN KEY (customer_id) REFERENCES dbo.CUSTOMERS(customer_id)
    );
END;
GO

IF OBJECT_ID('dbo.PAYMENT_TRANSACTIONS','U') IS NULL
BEGIN
    CREATE TABLE dbo.PAYMENT_TRANSACTIONS
    (
        transaction_id      VARCHAR(50) NOT NULL PRIMARY KEY,
        idempotency_key     VARCHAR(100) NOT NULL,
        source_account      VARCHAR(20) NOT NULL,
        destination_bank    VARCHAR(20) NOT NULL,
        destination_account VARCHAR(20) NOT NULL,
        amount              DECIMAL(18,2) NOT NULL,
        currency            CHAR(3) NOT NULL,
        status              VARCHAR(30) NOT NULL,
        created_at          DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        updated_at          DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        request_hash        VARCHAR(64) NULL,
        CONSTRAINT UQ_PAYMENT_IDEMPOTENCY UNIQUE (idempotency_key)
    );
END;
GO
