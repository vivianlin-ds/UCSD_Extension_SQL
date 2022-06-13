--Question 1: How many zip codes in CA have population > 50,000?
SELECT
	ZipCode
	,State
	,Population
FROM ZipCode
WHERE State = 'CA' AND Population >50000;

--Question 2: Which zip code has largest population?
SELECT
	ZipCode
	,State
	,Country
	,Population
FROM ZipCode
ORDER BY Population DESC

--Prep oshpdFacilityRaw
SELECT
	CAST(FACILITY_STATUS_DATE AS date) FSD
	,CAST(REPLACE(TOTAL_NUMBER_BEDS, ',', '') AS int) BEDS
	,*
	INTO oshpdFacility
FROM oshpdFacilityRaw

--Question 3: How many "general acute care hospital" are located in SD county that have status of 'Open'?
SELECT
	LICENSE_CATEGORY_DESC
	,COUNTY_NAME
	,FACILITY_STATUS_DESC
FROM oshpdFacility
WHERE LICENSE_CATEGORY_DESC like '%Acute Care%' AND COUNTY_NAME = 'SAN DIEGO' AND FACILITY_STATUS_DESC = 'Open';

--Question 4: How many facilities have ER Service LEvel of 'Emergency - Comprehensive' or have more than 500 total beds?
SELECT
	ER_SERVICE_LEVEL_DESC
	,BEDS
	,COUNTY_NAME
FROM oshpdFacility
WHERE ER_SERVICE_LEVEL_DESC = 'Emegerncy - Comprehensive' OR BEDS > 500
ORDER BY BEDS DESC;

--Question 5: How many first names start with 'S' and were given more than 7,500 times?
SELECT
	FirstName
	,Total
FROM yob1968
WHERE FirstName like 'S%' AND Total > 7500;
