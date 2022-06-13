--Question4: Create procedure that adds a new person to the database.

CREATE PROC InsertPerson_p
	@LastName varchar(13)
	,@FirstName varchar(11)
	,@AddressType char(4)
	,@AddressLine varchar(34)
	,@City varchar(25)
AS
INSERT INTO Person (LastName, FirstName)
	VALUES(@LastName, @FirstName)
INSERT INTO Address (PersonID, AddressType, AddressLine, City)
	VALUES(
		(SELECT PersonID FROM Person WHERE FirstName = @FirstName AND LastName = @LastName),
		@AddressType, @AddressLine, @City)

BEGIN TRANSACTION
EXEC InsertPerson_p 'Vivian', 'Lin', 'work', '500 Elm St.', 'North Pole'
SELECT TOP 1 * FROM Person ORDER BY PersonID DESC
SELECT TOP 1 * FROM Address ORDER BY AddressID DESC

COMMIT TRANSACTION
ROLLBACK TRANSACTION