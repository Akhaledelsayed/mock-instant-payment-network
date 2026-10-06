USE BANKA_DB;
GO

IF OBJECT_ID('dbo.PAYMENT_INTEGRATION_LOG','U') IS NULL
BEGIN
    CREATE TABLE dbo.PAYMENT_INTEGRATION_LOG
    (
        transaction_id       VARCHAR(50) NOT NULL PRIMARY KEY,
        inbound_request      NVARCHAR(MAX) NULL,
        inbound_request_time DATETIME2 NULL,
        bank_response        NVARCHAR(MAX) NULL,
        bank_response_time   DATETIME2 NULL,
        mock_request         NVARCHAR(MAX) NULL,
        mock_request_time    DATETIME2 NULL,
        mock_response        NVARCHAR(MAX) NULL,
        mock_response_time   DATETIME2 NULL,
        final_response       NVARCHAR(MAX) NULL,
        final_response_time  DATETIME2 NULL,
        status               VARCHAR(30) NULL,
        error_code           VARCHAR(50) NULL,
        error_message        NVARCHAR(500) NULL,
        error_time           DATETIME2 NULL,
        created_at           DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        updated_at           DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_UPSERT_PAYMENT_LOG_EVENT
    @transaction_id VARCHAR(50),
    @event_type     VARCHAR(30),
    @payload        NVARCHAR(MAX) = NULL,
    @event_time     DATETIME2 = NULL,
    @status         VARCHAR(30) = NULL,
    @error_code     VARCHAR(50) = NULL,
    @error_message  NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @event_time IS NULL SET @event_time = SYSDATETIME();

    IF NOT EXISTS (
        SELECT 1 FROM dbo.PAYMENT_INTEGRATION_LOG
        WHERE transaction_id = @transaction_id
    )
    BEGIN
        INSERT INTO dbo.PAYMENT_INTEGRATION_LOG(transaction_id, status)
        VALUES (@transaction_id, @status);
    END;

    IF @event_type = 'INBOUND_REQUEST'
        UPDATE dbo.PAYMENT_INTEGRATION_LOG
        SET inbound_request=@payload,
            inbound_request_time=@event_time,
            status=COALESCE(@status,status),
            updated_at=SYSDATETIME()
        WHERE transaction_id=@transaction_id;

    ELSE IF @event_type = 'BANK_RESPONSE'
        UPDATE dbo.PAYMENT_INTEGRATION_LOG
        SET bank_response=@payload,
            bank_response_time=@event_time,
            status=COALESCE(@status,status),
            updated_at=SYSDATETIME()
        WHERE transaction_id=@transaction_id;

    ELSE IF @event_type = 'MOCK_REQUEST'
        UPDATE dbo.PAYMENT_INTEGRATION_LOG
        SET mock_request=@payload,
            mock_request_time=@event_time,
            status=COALESCE(@status,status),
            updated_at=SYSDATETIME()
        WHERE transaction_id=@transaction_id;

    ELSE IF @event_type = 'MOCK_RESPONSE'
        UPDATE dbo.PAYMENT_INTEGRATION_LOG
        SET mock_response=@payload,
            mock_response_time=@event_time,
            status=COALESCE(@status,status),
            updated_at=SYSDATETIME()
        WHERE transaction_id=@transaction_id;

    ELSE IF @event_type = 'FINAL_RESPONSE'
        UPDATE dbo.PAYMENT_INTEGRATION_LOG
        SET final_response=@payload,
            final_response_time=@event_time,
            status=COALESCE(@status,status),
            updated_at=SYSDATETIME()
        WHERE transaction_id=@transaction_id;

    ELSE IF @event_type = 'ERROR'
        UPDATE dbo.PAYMENT_INTEGRATION_LOG
        SET error_code=@error_code,
            error_message=@error_message,
            error_time=@event_time,
            status=COALESCE(@status,'ERROR'),
            updated_at=SYSDATETIME()
        WHERE transaction_id=@transaction_id;
END;
GO
