/*Kyle Dooley 05/23/2023
SQL
Drop stored procedure if it already exists*/
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo.spBalanceRange'
     AND SPECIFIC_NAME = N'dbo.spBalanceRange' 
)
   DROP PROCEDURE dbo.spBalanceRange
GO

CREATE PROCEDURE dbo.spBalanceRange
	@VendorVar  varchar(40) = '%', 
	@BalanceMin decimal(10,2) = NULL,
	@BalanceMax decimal(10,2) = NULL
AS
	
IF @BalanceMin IS NULL
	SELECT @BalanceMin = MIN(InvoiceTotal) FROM Invoices
	
IF @BalanceMax IS NULL	
	SELECT @BalanceMax = MAX(InvoiceTotal) FROM Invoices

SELECT [InvoiceID]
      ,[Invoices].[VendorID]
      ,[InvoiceNumber]
      ,[InvoiceDate]
      ,[InvoiceTotal]
      ,[PaymentTotal]
      ,[CreditTotal]
      ,[TermsID]
      ,[InvoiceDueDate]
      ,[PaymentDate]
FROM [AP].[dbo].[Invoices]
  	INNER JOIN Vendors ON Vendors.VendorID = Invoices.VendorID
WHERE PaymentDate IS NULL
	AND Vendors.VendorName LIKE @VendorVar
	AND InvoiceTotal BETWEEN @BalanceMin AND @BalanceMax
GO
--Test
EXECUTE dbo.spBalanceRange @BalanceMin = 100, @BalanceMax = 2000
GO

--Kyle Dooley 05/23/2023
USE AP;

EXEC spBalanceRange 'M%';


/*Kyle Dooley 05/23/2023
Step 2b*/
USE AP;

EXEC spBalanceRange @BalanceMin = 200, @BalanceMax = 1000;


/*Kyle Dooley 05/23/2023
Step 2c*/
USE AP;

EXEC spBalanceRange '[C,F]%', 0, 200;