USE BANKA_DB;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.CUSTOMERS WHERE customer_id = 1)
    INSERT INTO dbo.CUSTOMERS VALUES (1, N'Ahmed', 'ACTIVE');

IF NOT EXISTS (SELECT 1 FROM dbo.ACCOUNTS WHERE account_id = 'A001')
    INSERT INTO dbo.ACCOUNTS(account_id,customer_id,balance,currency,status)
    VALUES ('A001',1,10000.00,'EGP','ACTIVE');
GO

USE BANKB_DB;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.CUSTOMERS WHERE customer_id = 1)
    INSERT INTO dbo.CUSTOMERS VALUES (1, N'Sara', 'ACTIVE');

IF NOT EXISTS (SELECT 1 FROM dbo.ACCOUNTS WHERE account_id = 'B001')
    INSERT INTO dbo.ACCOUNTS(account_id,customer_id,balance,currency,status)
    VALUES ('B001',1,5000.00,'EGP','ACTIVE');
GO
