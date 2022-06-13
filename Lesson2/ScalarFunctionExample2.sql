/* Define a function that returns the name of the supervisor.. */
CREATE FUNCTION Supervisor_fn (@ReportTo int)
RETURNS varchar(50)
AS
BEGIN
--Create a variable within the function, need to declare datatype as well.
DECLARE @Supervisor varchar(50)
--Need to use select statement to get the info about supervisor.
SELECT
	@Supervisor = CONCAT(FirstName, ' ', LastName)
FROM Employee
WHERE EmployeeId = @ReportTo
--Scalar function need to returna single value.
RETURN @Supervisor 
END

GO

/* Check if function is successful. */
SELECT
	EmployeeId
	,FirstName
	,LastName
	,ReportsTo
	--Remeber to include schema dbo at beginning of function.
	,dbo.Supervisor_fn(ReportsTo) AS SupervisorName
FROM Employee

GO

/* Alter function. */
ALTER FUNCTION Supervisor_fn (@ReportTo int)
RETURNS varchar(50)
AS
BEGIN
--Create a variable within the function, need to declare datatype as well.
DECLARE @Supervisor varchar(50)
--Need to use select statement to get the info about supervisor.
SELECT
	--Concat EmployeeID as well.
	@Supervisor = CONCAT(FirstName, ' ', LastName, ', #', EmployeeId)
FROM Employee
WHERE EmployeeId = @ReportTo
--Scalar function need to returna single value.
RETURN @Supervisor 
END

GO

/* Get all info on the function.
Remeber to change to text view for easier view of output. */
EXEC sp_helptext Supervisor_fn

/* Drop function, remember to include schema.*/
DROP FUNCTION dbo.DayOfBirth_fn