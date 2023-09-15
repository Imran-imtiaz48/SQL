/*Kyle D. Murach SQL Stored Procedure Assignment 
Create a stored procedure named spDateRange that accepts two 
parameters, @DateMin and @DateMax, with data type varchar and default value 
null. If called with no parameters or with null values, raise an error that
describes the problem. If called with non-null values, validate the parameters. 
Test that the literal strings are valid dates and test that @DateMin is earlier
than @ DateMax. If the parameters are valid, return a result set that includes 
the InvoiceNumber, InvoiceDate, InvoiceTotal, and Balance for each invoice for
hich the InvoiceDate is within the date range, sorted with earliest invoice 
first.*/

CREATE PROC spDateRange
@DateMin VARCHAR(20)=NULL,
@DateMax VARCHAR(20)=NULL
AS
IF @DateMin IS NULL
THROW 50001,'Minimum Date Left Blank',1;
IF @DateMax IS NULL
THROW 50002,'Maximum Date Left Blank',1;
IF ISDATE(@DateMin)=0
THROW 50003,'Minimum is not a valid date',1;
IF ISDATE(@datemax)=0
THROW 50004,'Maximum is not a valid date',1;
IF (SELECT CONVERT(DATETIME,@DateMin))>(SELECT CONVERT(DATETIME,@datemax))
THROW 50005,'Min date is greater than max date',1;
SELECT InvoiceNumber,InvoiceDate,InvoiceTotal,(InvoiceTotal -CreditTotal -PaymentTotal) AS Balance
FROM Invoices
WHERE InvoiceDate >CONVERT(DATETIME,@DateMin)
AND InvoiceDate <CONVERT(DATETIME,@DateMax)
ORDER BY InvoiceDate DESC;

/*Kyle D. Murach SQL Stored Procedure Assignment 
Code a call to the stored procedure created in exercise 3 that returns invoiceswith and InvoiceDate
between october 10 and october 20, 2019. This call should also catch any errors that are raised by 
the procedure and print the error number and description.*/

USE AP;

BEGIN TRY
	EXEC spDateRange '2019-10-10', '2019-10-20';
END TRY
BEGIN CATCH
	PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
	PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;