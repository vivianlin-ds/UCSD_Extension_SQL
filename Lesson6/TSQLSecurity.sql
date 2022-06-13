USE Chinook

--T-SQL Security Example

--Create server login name and password
CREATE LOGIN MySQLLoginEx WITH PASSWORD = 'test';
--Create database login in Chinook using the same name
CREATE USER MySQLLoginEx FOR LOGIN MySQLLoginEx;

--Assign reader and writer role/permission to the user
ALTER ROLE db_datareader ADD MEMBER MySQLLoginEx;
ALTER ROLE db_datawriter ADD MEMBER MySQLLoginEx;

--Grant specific permissions to the user
GRANT ALTER ON SCHEMA::dbo TO MySQLLoginEx;
GRANT CREATE TABLE TO MySQLLoginEx;
GRANT CREATE VIEW TO MySQLLoginEx;
DENY CREATE PROC TO MySQLLoginEx;
--Revoke granted permission on create table
REVOKE CREATE TABLE FROM MySQLLoginEx;

--Drop user for cleanup
--Drops database login for Chinook
DROP USER MySQLLoginEx;
--Drops server login
DROP LOGIN MySQLLoginEx;