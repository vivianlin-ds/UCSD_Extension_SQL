/* Cannot use ALTER TABLE to rename a table on Microsoft SQL Server.
Will get warning since other code has originally referenced this table by its old name. */
EXEC sp_rename 'Person', 'Users'

/* Renaming specific columns in similar way.
Need to identify the table in which the column resides.
Need to also specify what is being renamed in the third parameter. */ 
EXEC sp_rename 'Address.zip', 'ZipCode', 'COLUMN'

/* Need to drop Address table first. */
DROP TABLE Address
/* Red line under Users because IntelliSense is not updated by the rename executed.
Ctrl+Shift+R to update IntelliSense. 
However, cannot drop the table that has a primary key being referenced by another table. */
DROP TABLE Users

/* Drop the database itself.
Need to make sure there is no connection to the database to be dropped.
Left upper corner, drop down menu from Example to master. */
DROP DATABASE Example