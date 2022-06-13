--Create a large table (21879738 rows)
SELECT
	ROW_NUMBER() OVER (ORDER BY AL.AlbumId, T.TrackId, P.PlaylistId) AS RowNumber
	,AL.AlbumId, AL.Title
	,T.TrackId, T.Name AS TrackName
	,P.PlaylistId, P.Name AS PlaylistName
	,NEWID() AS ID --Unique ID for each row
INTO IndexTest
FROM Track T
--Cross join creates Cartesian product, generate paried combo of each row of the two tables
CROSS JOIN Album AL
CROSS JOIN Playlist P

--Reports -> Standard Reports -> Disk Usage by Top Tables
--Storage cannot exceed 10 GB per table

--Since there are many records in the table, simple queries takes several seconds to execute.
SELECT *
FROM IndexTest
WHERE RowNumber = 100
--Run the query by 'Include Actual Execution Plan', shows what the SQL server was doing to generate the result set.
--In this case, query is using Table Scan (scanning entire table in the table).
--Estimated subtree cost (aka query cost) for this query is 336.028. Gives an idea of how much effort server needs to give to return result.

--Add primary indexing to minimize the cost.
ALTER TABLE IndexTest
--Make sure the column is not null since primary key cannot be null.
ALTER COLUMN RowNumber int NOT NULL

--Creates a clustered index, ordering all of the rows in the table by the RowNumber.
--Query that searches for a specific row number now will stop once the record is found and will not continue until the end of the table.
ALTER TABLE IndexTest
ADD CONSTRAINT pk_IndexTest PRIMARY KEY (RowNumber)

--Running this query now will be Clustered Index Seek instead of Table Scan.
--Estimated Subtree cost for the query deceased to 0.0032831.
SELECT *
FROM IndexTest
WHERE RowNumber = 100
--However if the filtered search is based on another column, the time of execution will be slow like before since no index was added for the column.
SELECT *
FROM IndexTest
WHERE ID = '390D1E2C-5208-41D4-882A-F4A88DF41C39'

--To create another index, needs to be non-clustered index since one table can only have one clustered index.
--Non clustered index will still increase query performance, the result set just wouldn't be automatically sorted.
--However, non-clustered index increase the memory storage of the table. Be careful not to exceed the 10GB limit.
CREATE UNIQUE NONCLUSTERED INDEX ix_IndexTest ON IndexTest(ID)
--Running this query now will be fast, but will be slower than the query searching with clustered index.
-- Index seek first then Key lookup to get the rest of the columns for the row.
SELECT *
FROM IndexTest
WHERE ID = '390D1E2C-5208-41D4-882A-F4A88DF41C39'

--To increase performance of non-clustered index, use INCLUDE statement.
--This takes up a lot of storage as well, so be careful.
CREATE UNIQUE NONCLUSTERED INDEX ix_IndexTest_inc ON IndexTest(ID)
INCLUDE (PlaylistName, TrackName)
--Running a query with columns included in the index, execution will be fast since it's already included with the index.
--Adding a column not included in the index will force the SQL Server to read the entire table again.
SELECT TrackName, PlaylistName
FROM IndexTest
WHERE ID = '390D1E2C-5208-41D4-882A-F4A88DF41C39'

--Drop an index in T-SQL.
DROP INDEX ix_IndexTest_inc ON IndexTest
