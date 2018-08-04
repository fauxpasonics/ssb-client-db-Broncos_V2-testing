SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







create PROC [rpt].[Cust_EloquaTopClick_dev] (@ReportType VARCHAR(10) = 'All')
with recompile
AS

--DROP TABLE #seasons

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



SELECT TOP 10 * FROM
(
SELECT 'Season' AS ReportType,subjectline, COUNT(*) subjectcount
FROM ods.Eloqua_ActivityEmailClickThrough o (NOLOCK)
JOIN ods.Eloqua_Contact b  (NOLOCK) ON o.ContactId = b.Id 
LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE o.createdat > CAST(GETDATE()-30 AS DATE)
--AND (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
AND ISNULL(s.AcctId,'')<>'' 
GROUP BY subjectline
) e --ORDER BY e.subjectcount DESC

UNION ALL

SELECT TOP 10 * FROM
(
SELECT 'All' AS ReportType, subjectline, COUNT(*) subjectcount
FROM ods.Eloqua_ActivityEmailClickThrough o (NOLOCK)
JOIN ods.Eloqua_Contact b  (NOLOCK) ON o.ContactId = b.Id 
LEFT JOIN #seasons s ON b.C_Season_Ticket_Account_Number1 = s.AcctId
WHERE o.createdat > CAST(GETDATE()-30 AS DATE)
--AND (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')
GROUP BY subjectline
) e ORDER BY e.subjectcount DESC
GO
