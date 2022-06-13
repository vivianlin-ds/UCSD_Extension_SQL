
SELECT 
	--Get rid of the minutes, seconds, ms in the FACILITY_STATUS_DATE column.
	CAST(FACILITY_STATUS_DATE AS date) FSD
	--Get rid of the commas that exist in the TOTAL_NUMBER_BEDS column
	,CAST(REPLACE(TOTAL_NUMBER_BEDS, ',', '') AS int) BEDS
	,*
	--Save into new table
	INTO HospitalFacilities
FROM oshpd
