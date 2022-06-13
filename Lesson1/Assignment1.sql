/* Name: Vivian Lin
ID: U09320143
Date: April 8, 2022
*/

USE master
IF DB_ID('MyDB_VivianLin') IS NOT NULL
BEGIN
	ALTER DATABASE MyDB_VivianLin SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE MyDB_VivianLin SET ONLINE;
	DROP DATABASE MyDB_VivianLin;
END

--Question 1: Create new database called MyDB_VivianLin.
CREATE DATABASE MyDB_VivianLin
GO
USE MyDB_VivianLin

--Question 2: Copy all records and columns from existing table to new table.
SELECT *
INTO Users
FROM Chinook.dbo.Customer
USE MyDB_VivianLin

--Question 3: Delete recrods that have odd CustomerId.
DELETE Users
WHERE CustomerId % 2 = 1

--Question 4: Update Company column.
UPDATE Users
SET Company = CASE 
	WHEN Email like '%gmail%' THEN 'Google'
	WHEN Email like '%yahoo%' THEN 'Yahoo!'
	ELSE Company
	END

--Question 5: Rename CustomerId to UserId.
EXEC sp_rename 'Users.CustomerId', 'UserId', 'COLUMN'

--Question 6: Add Primary Key.
ALTER TABLE Users
ADD CONSTRAINT pk_Users PRIMARY KEY (UserId)

--Question 7: Create Address table.
CREATE TABLE Address (
	AddressId int IDENTITY (1, 1) PRIMARY KEY 
	,AddressType varchar(10) NOT NULL
	,AddressLine1 varchar(50) NOT NULL
	,City varchar(50) NOT NULL
	,State varchar(2) NOT NULL
	,UserId int NOT NULL
	,CreateDate datetime NOT NULL DEFAULT GETDATE()
	)

--Question 8: Add unique constraint.
ALTER TABLE Address
ADD CONSTRAINT uc_AddressType UNIQUE (UserId, AddressType)

--Question 9: Add foreign key.
ALTER TABLE Address
ADD CONSTRAINT fk_UserAddress FOREIGN KEY (UserId)
	REFERENCES Users(UserId)

--Question 10: Insert 3 records.
INSERT INTO Address(AddressType, AddressLine1, City, State, UserId)
VALUES ('home', '111 Elm St.', 'Los Angeles', 'CA', '2')
,('home', '222 Palm Ave.', 'San Diego', 'CA', '4')
,('work', '333 Oak Ln.', 'La Jolla', 'CA', '4')

--Question 11: Select everything from both tables.
SELECT *
FROM Users

SELECT *
FROM Address