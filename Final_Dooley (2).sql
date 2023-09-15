/*Kyle Dooley 50/50 06/11/2023
Final Project DB Coding and Implementation
Add a VIEW to your DB, document and explain the purpose of your VIEW 
in your code - each VIEW should display between 3-10 fields and return 
between 5-7 records - 25 pts.*/
CREATE VIEW BeadsStock5AndUnder AS
SELECT BeadColors, BeadInventory
FROM Beads
WHERE BeadInventory <= 5;--To ensure stock does not get to low.

/*Kyle Dooley 50/50 06/11/2023
Final Project DB Coding and Implementation
Create a couple STORED PROCEDURES - one sproc with scalar parms, 2nd 
sproc with table parms, document and explain the purpose of each SPROC 
50 pts*/
CREATE PROCEDURE SelectAllBeads
AS
SELECT * FROM Beads
GO;
EXEC SelectAllBeads;

CREATE PROCEDURE SelectAllCustomers @Fname nvarchar(10)
AS
SELECT * FROM Customers WHERE Fname = @Fname
GO
EXEC SelectAllCustomers @Fname = 'Zharelle'

CREATE PROCEDURE SelectAllEmployees @EmployeeID nvarchar(10), @JobNum nvarchar(10)
AS
SELECT * FROM Employees WHERE EmployeeID = @EmployeeID AND JobNum = @JobNum
GO
EXEC SelectAllEmployees @EmployeeID = '5', @JobNum = '55';

/*Kyle Dooley 50/50 06/11/2023
Final Project DB Coding and Implementation
Include Error checking in your sproc using the TRY, CATCH or THROW 
statements - 25 pts*/

THROW [ { 585858 | EmployeeId },
{ 'No record found' | @EmployeeID },
{5 | @EmployeeId}]
;
THROW 585858, 'No record found', 1;

Select *
From Employees
Where EmployeeID = '5'

/*Kyle Dooley 50/50 06/11/2023
Final Project DB Coding and Implementation
Create a couple FUNCTIONS - one function with scalar params, 2nd 
function with table params, document and explain the purpose of each function - 50 pts
This sproc checks the total amount of capital the business has in beads.*/

USE Beads;
GO

CREATE FUNCTION fnTotalCapitalInventory()
RETURNS float
BEGIN
	RETURN
	(SELECT SUM(BeadPrice)
	FROM Beads
	WHERE BeadPrice * BeadInventory > 0 AND
	BeadInventory =
	(SELECT MIN(BeadInventory)
	FROM Beads
	WHERE BeadInventory > 0));
END

/*Kyle Dooley 50/50 06/11/2023
Final Project DB Coding and Implementation
2nd function with table params, document and explain the purpose 
of each function - 50 pts This sproc checks who was the person that put
in the order.*/

USE Beads
GO

CREATE FUNCTION fnCustomerName
	(@CustOrderNumMin int, @CustOrderNumMax int)
RETURNS table

RETURN
(SELECT CustOrderNum, Fname, Lname AS OrderName
FROM Customers
WHERE CustOrderNum BETWEEN @CustOrderNumMin AND @CustOrderNumMax);

/*Kyle Dooley 50/50 06/11/2023
Final Project DB Coding and Implementation
Research links*/

https://www.w3schools.com/sql/sql_stored_procedures.asp

https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/create-a-stored-procedure?view=sql-server-ver16