/* Define a scalar function that returns the day of the week a date falls on.
Programmability -> Functions -> Scalar-valued Functions
---keyword------name of func-(parameter datatype)*/
CREATE FUNCTION DayOfBirth_fn (@date date)
--Define what the return datatype will be.
RETURNS varchar(10)
AS
--Any code for the function needs to be in between BEGIN and END.
BEGIN
--Whatever is placed after the RETURN will be the fucntion return.
RETURN DATENAME(WEEKDAY, @date)
END

GO

/* Query using function defined.*/
SELECT
	BirthDate
	-- Call the scalar function, need to include the schema.
	,dbo.DayOfBirth_fn(BirthDate) AS DayOfBirth
FROM Employee