/* Dropping constraints from table. */
ALTER TABLE Address
DROP CONSTRAINT [fk_PersonAddress]

/* Dropping constraints from a certain table.
Need to specify the name of the constraints (Found in Keys and Constraints folder).
Since PersonID is referenced in another table as a foreign key, 
cannot modify this table without modifying the Address table first.
Also if primary key was defined inline, cannot use drop constraint like this. */
ALTER TABLE Person
DROP CONSTRAINT pk_Person

/* Add the constraint back in. 
Same syntax as first declaring the Constraint. */
ALTER TABLE Address
ADD CONSTRAINT [fk_PersonAddress] FOREIGN KEY (PersonID)
	REFERENCES Person(PersonID)

/* Execute the help function.
Returns all the information of the object being queried. */
--EXEC sp_help PERSON