/*Kyle Dooley 05/08/2023
Murach's SQL Scripts Assignment 1-3*/

USE AP;

IF OBJECT_ID('tempdb..VenderDet') IS NOT NULL

DROP TABLE VendorDet;

SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
INTO VendorDet
FROM Invoices
GROUP BY VendorID;

SELECT VendorName, FirstInvoiceDate, InvoiceTotal
FROM Invoices
JOIN VendorDet
ON (Invoices.VendorID = VendorDet.VendorID
AND Invoices.InvoiceDate = VendorDet.FirstInvoiceDate)
JOIN Vendors ON Invoices.VendorID = Vendors.VendorID
ORDER BY VendorName, FirstInvoiceDate;


/*Kyle Dooley 05/08/2023
Murach's SQL Scripts Assignment 1-3*/

USE AP;

IF OBJECT_ID('FirstInvoice_V') IS NOT NULL
    DROP VIEW FirstInvoice_V;
GO

CREATE VIEW FirstInvoice_V
AS
SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
FROM Invoices
GROUP BY VendorID;

/*Kyle Dooley 05/08/2023
Murach's SQL Scripts Assignment 1-3*/

USE AP;

SELECT VendorName, FirstInvoiceDate, InvoiceTotal
FROM Invoices JOIN FirstInvoice_V
  ON (Invoices.VendorID = FirstInvoice_V.VendorID AND
      Invoices.InvoiceDate = FirstInvoice_V.FirstInvoiceDate)
JOIN Vendors
  ON Invoices.VendorID = Vendors.VendorID
ORDER BY VendorName, FirstInvoiceDate;
