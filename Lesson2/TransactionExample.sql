/* Set out the environment with a temp table. */
IF OBJECT_ID('Customer Temp') IS NOT NULL DROP TABLE Customer_Temp

SELECT *
INTO Customer_Temp
FROM Customer

/* Use transactions to safeguard against unwanted changes.
However, puts a lock on all tables associated to the code.
Following code will allow access to the table associated, BUT may get outdated records:
SELECT *
FROM Customer_Temp WITH (NOLOCK)
Manually determine when to commit or rollback.*/
BEGIN TRANSACTION
DELETE Customer_Temp
WHERE COUNTRY NOT IN('India', 'Denmark')

SELECT *
FROM Customer_Temp

DELETE Customer_Temp
WHERE Country = 'India'

SELECT *
FROM Customer_Temp

/*
--Commit everything between here and BEGIN statement.
COMMIT TRANSACTION
--Discard evrything between here and BEGIN statement.
ROLLBACK TRANSACTION
*/