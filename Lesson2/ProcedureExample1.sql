/* Create a stored procedure.
Different from view in method of execution.
In Programmability > Stored Procedure. */
CREATE PROC Customer_p AS
SELECT
	FirstName
	,LastName
	,Country
FROM Customer
WHERE Country = 'Canada'
GO

/* Execute the stored procedure instead of using SELECT statements.
Can be used in INSERT, UPDATE, etc.*/
EXEC Customer_p
GO

/* Alter the procedure -> Add another SELECT statement. */
ALTER PROC [dbo].[Customer_p] AS
SELECT
	FirstName
	,LastName
	,Country
FROM Customer
WHERE Country = 'Canada'

SELECT
	EmployeeId
	,FirstName
	,LastName
FROM Employee
GO