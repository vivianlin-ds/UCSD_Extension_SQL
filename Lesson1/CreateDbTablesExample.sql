-- Create database.
-- CREATE DATABASE Chinook_Example

-- Use brand new database created.
USE Chinook_Example
-- See if tables already existed already, to avoid errors while modifying.
IF OBJECT_ID('Address') IS NOT NULL DROP TABLE Address
IF OBJECT_ID('Person') IS NOT NULL DROP TABLE Person

-- Create table named Person
CREATE TABLE Person(
	-- Mandatory to assign datatype to each column
	/* Want PersonID to be unique and become the primary key.
	One table can only have one primary key.
	Propogate the PersonID with IDENTITY(#toStartWith, #toIncrement)*/
	PersonID int IDENTITY(10000,2) PRIMARY KEY
	-- First and Last names cannot have NULL values
	,FirstName varchar(50) NOT NULL
	,LastName varchar(50) NOT NULL
	-- Doesn't need to enter NULL, but indicating it here is good coding habit.
	,BirthDate date NULL
	-- Check constraint on Gender column to limit input => Condition statement like WHERE statement
	,Gender char(1) NULL CHECK (GENDER IN ('F', 'M'))
	/* UserID has to be unique. 
	UNIQUE can be used multiple times in a table and can allow NULL values. */
	,UserID varchar(25) NOT NULL UNIQUE 
	-- Call function GETDATE().
	,DateCreated datetime2 NOT NULL DEFAULT GETDATE()
	-- Alternatrive way to declare PersonID column to be a primary key.
	--,CONSTRAINT pk_Person PRIMARY KEY (PersonID)
	-- Can also define composite primary key with mulitple columns with Constraint.
	--,CONSTRAINT pk_Person PRIMARY KEY (FirstName,LastName)
	)

-- Create second table.
CREATE TABLE Address (
	AddressId int IDENTITY(1, 1) PRIMARY KEY
	,AddressType varchar(10) NOT NULL
	,AddressLine1 varchar(50) NOT NULL
	,AddressLine2 varchar(50) NULL
	,City varchar(50) NULL
	,State char(2) NULL
	,Zip varchar(10) NOT NULL
	-- Alternative way to define PersonID as the FOREIGN KEY
	,PersonID int --FOREIGN KEY REFERENCES Person(PersonID)
	,DateCreated datetime2 NOT NULL DEFAULT GETDATE()
	/* Unique constraint. Can have two PersonID that are 
	the same as long as AddressType is different, or vice versa.
	Will not allow the same PersonID AND same AddressType.*/
	,CONSTRAINT uc_AddressType UNIQUE (AddressType, PersonID)
	/* FOREIGN KEY is REFRENCE from the first table Person.
	Main advantage of using Constraint is that multiple columns can be referred to. */
	,CONSTRAINT fk_PersonAddress FOREIGN KEY (PersonID)
		REFERENCES Person(PersonID)
	)

/* Once the PersonID column is set to use IDENTITY, can no longer use following code to insert.
-- Insert data into the specified columns using INSERT INTO() VALUES()
INSERT INTO Person(PersonID, FirstName, LastName)
VALUES (1, 'John', 'Doe')
-- Attempt to insert the same PersonID to two different records will result in error..
--,(1, 'Jane', 'Doe')
,(2, 'Harold', 'Smith')
,(3, 'Jane', 'Doe') */

INSERT INTO Person(FirstName, LastName, Gender, UserID)
VALUES ('John', 'Doe', 'M', 'jdoe')
,('Harold', 'Smith', NULL, 'hsmith')
,('Jane', 'Doe', 'F', 'jadoe')

INSERT INTO Address(AddressType, AddressLine1, Zip, PersonID)
/* PersonID will have to match the ones created in table Person 
since creation of records in Foreign primary key is not allowed. */
VALUES ('Work', '111 Elm', '92112', 10000)
,('Home', '555 Maple', '92101',  10000)
,('Home', '123 Hickory', '92101', 10002)
,('Work', '456 Palm', '92103', 10002)

SELECT *
FROM Person

SELECT *
FROM Address