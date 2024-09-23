/* Kyle Dooley 05/08/2023
   Murach's SQL Scripts Assignment 1-3 */

USE AP;

-- Drop the temporary table if it exists
IF OBJECT_ID('tempdb..VendorDet', 'U') IS NOT NULL
    DROP TABLE VendorDet;

-- Create a temporary table to store the first invoice date for each vendor
SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
INTO VendorDet
FROM Invoices
GROUP BY VendorID;

-- Select vendor names, first invoice dates, and invoice totals
SELECT 
    Vendors.VendorName, 
    VendorDet.FirstInvoiceDate, 
    Invoices.InvoiceTotal
FROM 
    Invoices
JOIN 
    VendorDet ON Invoices.VendorID = VendorDet.VendorID
             AND Invoices.InvoiceDate = VendorDet.FirstInvoiceDate
JOIN 
    Vendors ON Invoices.VendorID = Vendors.VendorID
ORDER BY 
    Vendors.VendorName, VendorDet.FirstInvoiceDate;

-- Drop the view if it exists
IF OBJECT_ID('FirstInvoice_V', 'V') IS NOT NULL
    DROP VIEW FirstInvoice_V;
GO

-- Create a view to store the first invoice date for each vendor
CREATE VIEW FirstInvoice_V
AS
SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
FROM Invoices
GROUP BY VendorID;
GO

-- Select vendor names, first invoice dates, and invoice totals using the view
SELECT 
    Vendors.VendorName, 
    FirstInvoice_V.FirstInvoiceDate, 
    Invoices.InvoiceTotal
FROM 
    Invoices
JOIN 
    FirstInvoice_V ON Invoices.VendorID = FirstInvoice_V.VendorID
                 AND Invoices.InvoiceDate = FirstInvoice_V.FirstInvoiceDate
JOIN 
    Vendors ON Invoices.VendorID = Vendors.VendorID
ORDER BY 
    Vendors.VendorName, FirstInvoice_V.FirstInvoiceDate;
