SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [rpt].[Cust_DQI_Eloqua_BK] (@ReportType VARCHAR(10) = 'All')
AS
DECLARE @DateOffset int = (SELECT UTCOffset FROM dbo.DimDate WHERE CalDate = CAST(GETDATE() AS DATE))

create TABLE #seasons (AcctId VARCHAR(200))

IF (@ReportType = 'Season')
begin
INSERT #seasons
SELECT dc.AccountId
FROM rpt.vw_FactTicketSales f
INNER JOIN dbo.DimCustomer dc ON f.DimCustomerId = dc.DimCustomerId
INNER JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId
INNER JOIN rpt.vw_DimPlan dpl ON f.DimPlanId = dpl.DimPlanId 
WHERE f.DimSeasonId = 4
AND dpl.PlanClass = 'FS'
GROUP BY dc.AccountId
end



SELECT 
'Broncos KPI' ReportName
,'1' ClientID
, 'Contacts' KPIDisplayName
--, KPIID
, DATEADD(DAY,-1,GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
, 0 KPIExportEnable
,1 AS displayrownumber
,1 AS displaycolnumber
,'Past 7 Days' KpiPrevLabel
, ISNULL(SUM(CASE WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 7 AS DATE)
	AND CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END),0) AS KpiPrev
,'Past 14 Days' KpiLabel2
, ISNULL(SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 14 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END),0) AS Kpi2
,'Past 30 Days' KpiLabel3
, ISNULL(SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 30 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END),0) AS Kpi3
,'To Date' KpiLabel4
, ISNULL(COUNT(*),0) AS Kpi4
,NULL KpiPrevThirty
, 'Box' WidgetType
FROM ods.Eloqua_Contact o WITH (NOLOCK)  
LEFT JOIN #seasons s ON o.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
UNION
SELECT 
'Broncos KPI' ReportName
,'1' ClientID
, 'Opens' KPIDisplayName
--, KPIID
, DATEADD(DAY,-1,GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
, 0 KPIExportEnable
,1 AS displayrownumber
,2 AS displaycolnumber
,'Past 7 Days' KpiPrevLabel
, ISNULL(SUM(CASE WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 7 AS DATE)
	AND CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END),0) AS KpiPrev
,'Past 14 Days' KpiLabel2
, ISNULL(SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 14 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END),0) AS Kpi2
,'Past 30 Days' KpiLabel3
, ISNULL(SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 30 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END),0) AS Kpi3
,'To Date' KpiLabel4
, ISNULL(COUNT(*),0) AS Kpi4
,NULL KpiPrevThirty
, 'Box' WidgetType
FROM [ods].[Eloqua_ActivityEmailOpen] o WITH (NOLOCK)
JOIN ods.Eloqua_Contact b  ON o.ContactId = b.Id 
LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
UNION
SELECT 
'Broncos KPI' ReportName
,'1' ClientID
, 'Click Through' KPIDisplayName
--, KPIID
, DATEADD(DAY,-1,GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
, 0 KPIExportEnable
,1 AS displayrownumber
,3 AS displaycolnumber
,'Past 7 Days' KpiPrevLabel
, SUM(CASE WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 7 AS DATE)
	AND CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END) AS KpiPrev
,'Past 14 Days' KpiLabel2
, SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 14 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END) AS Kpi2
,'Past 30 Days' KpiLabel3
, SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 30 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END) AS Kpi3
,'To Date' KpiLabel4
, COUNT(*) AS Kpi4
,NULL KpiPrevThirty
, 'Box' WidgetType
FROM [ods].[eloqua_ActivityEmailClickThrough] o WITH (NOLOCK)
JOIN ods.Eloqua_Contact b  ON o.ContactId = b.Id
LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
UNION
SELECT 
'Broncos KPI' ReportName
,'1' ClientID
, 'Page Views' KPIDisplayName
--, KPIID
, DATEADD(DAY,-1,GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
, 0 KPIExportEnable
,2 AS displayrownumber
,1 AS displaycolnumber
,'Past 7 Days' KpiPrevLabel
, SUM(CASE WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 7 AS DATE)
	AND CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END) AS KpiPrev
,'Past 14 Days' KpiLabel2
, SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 14 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END) AS Kpi2
,'Past 30 Days' KpiLabel3
, SUM(CASE
	WHEN CAST(o.createdat AS DATE) BETWEEN CAST(DATEADD(HOUR, @DateOffset, GETDATE()) - 30 AS DATE)
	AND  CAST(DATEADD(HOUR, @DateOffset, GETDATE()) AS DATE)
	THEN 1
	ELSE 0
	END) AS Kpi3
,'To Date' KpiLabel4
, COUNT(*) AS Kpi4
,NULL KpiPrevThirty
, 'Box' WidgetType
FROM [ods].[Eloqua_ActivityPageView] o WITH (NOLOCK)
JOIN ods.Eloqua_Contact b  ON o.ContactId = b.Id
LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')



GO
