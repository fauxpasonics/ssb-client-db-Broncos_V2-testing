SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[Cust_EloquaLocations_dev] (@ReportType VARCHAR(10) = 'All')
WITH RECOMPILE
AS


/*
DROP TABLE #seasons
DROP TABLE #scseason
DROP TABLE #scall
DECLARE @ReportType VARCHAR(10)='Season'
*/
CREATE TABLE #seasons (AcctId VARCHAR(200))


--IF (@ReportType = 'Season')
--BEGIN
INSERT #seasons
SELECT dc.AccountId
FROM rpt.vw_FactTicketSales f (NOLOCK)
INNER JOIN dbo.DimCustomer dc (NOLOCK) ON f.DimCustomerId = dc.DimCustomerId
INNER JOIN dbo.dimcustomerssbid ssbid (NOLOCK) ON dc.DimCustomerId = ssbid.DimCustomerId
INNER JOIN rpt.vw_DimPlan dpl (NOLOCK) ON f.DimPlanId = dpl.DimPlanId 
WHERE f.DimSeasonId = 22
AND dpl.PlanClass = 'FS'
GROUP BY dc.AccountId
--END


SELECT Province, City
INTO #SCSeason  
FROM ods.Eloqua_Contact b (NOLOCK)
LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
--WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
WHERE ISNULL(s.AcctId,'')<>''
AND Province IS NOT NULL

UPDATE a
SET  a.Province = b.StateCode
FROM  #SCSeason a 
JOIN rpt.USStates b ON a.Province = b.StateName

SELECT Province, City
INTO #SCAll
FROM ods.Eloqua_Contact b (NOLOCK)
--LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
--WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
WHERE Province IS NOT NULL
--AND @ReportType = 'All'

UPDATE a
SET  a.Province = b.StateCode
FROM  #SCAll a 
JOIN rpt.USStates b ON a.Province = b.StateName

SELECT 

CASE grouping_id(City)
WHEN 0 THEN 'Detail' ELSE 'State' END AS RowType,
'Season' AS ReportType,
StateCode, 
StateName, 
ISNULL(City,'None Given') AS City, COUNT(*) RecordCount 
FROM #SCSeason a 
JOIN rpt.USStates b (NOLOCK) ON a.Province = b.StateCode 
GROUP BY GROUPING SETS((StateCode, StateName, City),(StateCode,b.StateName))
--ORDER BY RecordCount DESC

UNION ALL

SELECT 

CASE grouping_id(City)
WHEN 0 THEN 'Detail' ELSE 'State' END AS RowType,
'All' AS ReporType,
StateCode, 
StateName, 
ISNULL(City,'None Given') AS City, COUNT(*) RecordCount 
FROM #SCSeason a 
JOIN rpt.USStates b (NOLOCK) ON a.Province = b.StateCode 
GROUP BY GROUPING SETS((StateCode, StateName, City),(StateCode,b.StateName))

ORDER BY ReportType, RecordCount DESC

GO
