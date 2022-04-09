/* Create a brand new table from existing table.
All columns and their datatypes will be copied over. */
SELECT *
INTO Customer_Copy
FROM Customer

SELECT 
	FirstName
	,LastName
	,Country
	,SupportRepId
FROM Customer_Copy
ORDER BY Country

/* Delete only specific row with country as 'Austria' from the table. */
DELETE Customer_Copy
WHERE Country = 'Austria'

/* Delete with alias CC in place of the table Customer_Copy.
Alias must be declared at the top.
Delete all records that have association with last name 'Peacock' (SupportRepID = 3). */
DELETE CC
FROM Customer_Copy CC
JOIN Employee E
	ON E.EmployeeId = CC.SupportRepId
WHERE E.LastName = 'Peacock'

/* Delete entire table. 
However, the table is still there - can have records inserted.*/
DELETE Customer_Copy