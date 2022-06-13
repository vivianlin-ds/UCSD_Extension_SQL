--Question1: Create View that shows number of times each course has been offered in history.
CREATE VIEW CourseRevenue_v AS
WITH SectClass AS
(
SELECT CL.SectionID, S.CourseID, S.SectionStatus, SUM(TuitionAmount) AS SectionRevenue
FROM ClassList CL
JOIN Sections S ON S.SectionID = CL.SectionID
GROUP BY CL.SectionID, S.SectionStatus, S.CourseID
HAVING SectionStatus != 'CN'
)
, CO AS
(
SELECT 
	C.CourseCode
	,C.CourseTitle
	,COUNT(SC.SectionID) AS SectionCount
	,SUM(SC.SectionRevenue)  AS TotalGrossRevenue
	,CAST((SUM(SC.SectionRevenue) / COUNT(SC.SectionID)) AS DECIMAL(18,2)) AS AvgPerSection
FROM Course C
JOIN SectClass SC ON SC.CourseID = C.CourseID
GROUP BY C.CourseCode, C.CourseTitle
)
SELECT *
FROM CO

SELECT * FROM CourseRevenue_v ORDER BY CourseCode