SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [rpt].[Cust_EloquaTopClick] --(@ReportType VARCHAR(10) = 'All')
WITH RECOMPILE
AS
--Altered on 4/25/2017.  Client asked about accuracy and I agreed that the query didn't make a whole lot of sense. 
--It was only showing the top 10, but it wasn't sorting based on clicks.  "Just hey, give me the top 10 records."

IF OBJECT_ID('tempdb..#tmpEmail') IS NOT NULL
	DROP TABLE #tmpEmail

SELECT
	subjectLine, 
	COUNT(DISTINCT s.AcctId) AS UniqueClicks,
	COUNT(o.ContactId) AS Clicks,
	CASE WHEN s.AcctId IS NULL THEN 'Season' ELSE 'All' END AS ReportType
INTO #tmpEmail
FROM ods.Eloqua_ActivityEmailClickThrough o (NOLOCK)
INNER JOIN ods.Eloqua_Contact b (NOLOCK) 
	ON  o.ContactId = b.Id 
LEFT JOIN (
		SELECT
			CAST(f.SSID_acct_id AS VARCHAR(200)) AcctId
		FROM rpt.vw_FactTicketSales f (NOLOCK)
		INNER JOIN rpt.vw_DimPlan dpl (NOLOCK) 
			ON  f.DimPlanId = dpl.DimPlanId 
		WHERE f.DimSeasonId = 22
			AND dpl.PlanClass = 'FS'
		GROUP BY f.SSID_acct_id
	)s 
	ON  b.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE o.createdat > CAST(GETDATE()-30 AS DATE)
GROUP BY 
	subjectline,
	CASE WHEN s.AcctId IS NULL THEN 'Season' ELSE 'All' END

SELECT 
	ReportType,
	subjectline,
	Clicks AS subjectcount
FROM (
		SELECT 
			subjectLine,
			ReportType,
			SUM(UniqueClicks) AS UniqueClicks,
			SUM(Clicks) AS Clicks,
			ROW_NUMBER() OVER (ORDER BY SUM(UniqueClicks) DESC) AS xRow
		FROM #tmpEmail
		WHERE ReportType = 'Season'
		GROUP BY
			subjectLine,
			ReportType
	) e
WHERE xRow <= 10
UNION
SELECT 
	ReportType,
	subjectline,
	Clicks AS subjectcount
FROM (
		SELECT 
			subjectLine,
			'All' AS ReportType,
			SUM(UniqueClicks) AS UniqueClicks,
			SUM(Clicks) AS Clicks,
			ROW_NUMBER() OVER (ORDER BY SUM(UniqueClicks) DESC) AS xRow
		FROM #tmpEmail
		GROUP BY
			subjectLine
	) e
WHERE xRow <= 10
ORDER BY ReportType DESC, Clicks DESC

--Code prior to 4/25/2017
--DROP TABLE #tmpEmail
--SELECT 
--	subjectline, 
--	COUNT(1) subjectcount,
--	s.AcctId
--INTO #tmpEmail
--FROM ods.Eloqua_ActivityEmailClickThrough o (NOLOCK)
--INNER JOIN ods.Eloqua_Contact b (NOLOCK) 
--	ON  o.ContactId = b.Id 
--LEFT JOIN (
--		SELECT 
--			CAST(dc.AccountId AS VARCHAR(200)) AcctId
--		FROM rpt.vw_FactTicketSales f (NOLOCK)
--		INNER JOIN dbo.DimCustomer dc (NOLOCK) 
--			ON  f.DimCustomerId = dc.DimCustomerId
--		INNER JOIN rpt.vw_DimPlan dpl (NOLOCK) 
--			ON  f.DimPlanId = dpl.DimPlanId 
--		WHERE f.DimSeasonId = 22
--			AND dpl.PlanClass = 'FS'
--		GROUP BY dc.AccountId
--	)s 
--	ON  b.C_Season_Ticket_Account_Number1 = s.AcctId
--WHERE o.createdat > CAST(GETDATE()-30 AS DATE)
--GROUP BY subjectline,s.AcctId

--SELECT TOP 10 'Season' AS ReportType, subjectline, COUNT(1) subjectcount
--FROM #tmpEmail 
--WHERE ISNULL(AcctId,'')<>'' 
--GROUP BY subjectline
--UNION ALL 
--SELECT top 10 'All' AS ReportType, subjectline, COUNT(1) subjectcount
--FROM #tmpEmail
--GROUP BY subjectline
GO
