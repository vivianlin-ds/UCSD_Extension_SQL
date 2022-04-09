/* Insert content of the Playlist table into a temp local table Playlist_Local.
Single hastag # represent a temp table, which will be removed once tab is closed. */
SELECT *
INTO #Playlist_Local
FROM Playlist

SELECT *
FROM #Playlist_Local

/* Global temp table.
As long the tab that created the table is open, any other tabs can use this temp table. */
SELECT *
INTO ##Artist_Global
FROM Artist

SELECT *
FROM ##Artist_Global