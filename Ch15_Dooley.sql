/* Kyle Dooley 05/23/2023
   SQL: Drop stored procedure if it already exists */
IF OBJECT_ID(N'dbo.spBalanceRange', N'P') IS NOT NULL
    DROP PROCEDURE dbo.spBalanceRange;
GO

/* Create the stored procedure */
CREATE PROCEDURE dbo.spBalanceRange
    @VendorVar  VARCHAR(40) = '%', 
    @BalanceMin DECIMAL(10, 2) = NULL,
    @BalanceMax DECIMAL(10, 2) = NULL
AS
BEGIN
    -- Set default values for @BalanceMin and @BalanceMax if they are NULL
    IF @BalanceMin IS NULL
        SELECT @BalanceMin = MIN(InvoiceTotal) FROM AP.dbo.Invoices;
    
    IF @BalanceMax IS NULL    
        SELECT @BalanceMax = MAX(InvoiceTotal) FROM AP.dbo.Invoices;

    -- Select invoices based on specified criteria
    SELECT 
        [InvoiceID],
        [Invoices].[VendorID],
        [InvoiceNumber],
        [InvoiceDate],
        [InvoiceTotal],
        [PaymentTotal],
        [CreditTotal],
        [TermsID],
        [InvoiceDueDate],
        [PaymentDate]
    FROM 
        [AP].[dbo].[Invoices]
    INNER JOIN 
        Vendors ON Vendors.VendorID = Invoices.VendorID
    WHERE 
        PaymentDate IS NULL
        AND Vendors.VendorName LIKE @VendorVar
        AND InvoiceTotal BETWEEN @BalanceMin AND @BalanceMax;
END;
GO

/* Test Cases */
USE AP;

-- Test 1
EXECUTE dbo.spBalanceRange @BalanceMin = 100, @BalanceMax = 2000;
GO

-- Test 2a
EXECUTE dbo.spBalanceRange 'M%';
GO

-- Test 2b
EXECUTE dbo.spBalanceRange @BalanceMin = 200, @BalanceMax = 1000;
GO

-- Test 2c
EXECUTE dbo.spBalanceRange '[C,F]%', 0, 200;
GO
