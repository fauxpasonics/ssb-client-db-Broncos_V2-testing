SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[Cust_EloquaGender_Backup] (@ReportType VARCHAR(10) = 'All')
AS

CREATE TABLE #seasons (AcctId VARCHAR(200))

IF (@ReportType = 'Season')
BEGIN
INSERT #seasons
SELECT dc.AccountId
FROM rpt.vw_FactTicketSales f
INNER JOIN dbo.DimCustomer dc ON f.DimCustomerId = dc.DimCustomerId
INNER JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId
INNER JOIN rpt.vw_DimPlan dpl ON f.DimPlanId = dpl.DimPlanId 
WHERE f.DimSeasonId = 4
AND dpl.PlanClass = 'FS'
GROUP BY dc.AccountId
END


SELECT SUM(CASE WHEN C_Lead_Rating___Implicit1 = 'Male' THEN 1 ELSE 0 END) Males,   
SUM(CASE WHEN C_Lead_Rating___Implicit1 = 'Female' THEN 1 ELSE 0 END) Females,
SUM(CASE WHEN C_Lead_Rating___Implicit1 NOT IN ('Male','Female') THEN 1 ELSE 0 END) Unk
FROM ods.Eloqua_Contact c
LEFT JOIN #seasons s ON s.AcctId = c.C_Season_Ticket_Account_Number1
WHERE (ISNULL(s.AcctId,'')<>'' OR @ReportType = 'All')

GO
