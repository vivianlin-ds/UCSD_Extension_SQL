/* Inserting manually. */
INSERT INTO Customer_Copy (CustomerId, FirstName, LastName, Email)
VALUES (100, 'Jane', 'Doe', 'janedoe@gmail.com')
,(101, 'John', 'Doe', 'johndoe@gmail.com')

SELECT *
FROM Customer_Copy

/* Inserting by querying another table. */
INSERT INTO Customer_Copy(CustomerId, FirstName, LastName, Email, Country)
SELECT
	CustomerId
	,FirstName
	,LastName
	,Email
	,Country
FROM Customer
WHERE Country = 'USA'

/* Inserting the rest of the Customer table into the copy table 
without propagating duplicates.
Using aliases for each table. */
INSERT INTO Customer_Copy
SELECT *
FROM Customer C
WHERE NOT EXISTS(
	SELECT *
	FROM Customer_Copy CC
	WHERE CC.CustomerId = C.CustomerId)
