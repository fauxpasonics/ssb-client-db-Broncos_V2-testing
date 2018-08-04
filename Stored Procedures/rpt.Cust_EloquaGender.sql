SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROC [rpt].[Cust_EloquaGender]
WITH RECOMPILE
AS
	
SELECT  
	 SUM(CASE WHEN dc.Gender = 'M' THEN 1
			ELSE 0
			END) Males
	,SUM(CASE WHEN dc.Gender = 'F' THEN 1
			ELSE 0
			END) Females
	,SUM(CASE WHEN dc.Gender NOT IN ( 'M', 'F' )
				OR dc.Gender IS NULL THEN 1
			ELSE 0
			END) Unk
	,SUM(CASE WHEN s.AcctId IS NOT NULL
				AND dc.Gender = 'M' THEN 1
			ELSE 0
			END) SeasonMales
	,SUM(CASE WHEN s.AcctId IS NOT NULL
				AND dc.Gender = 'F' THEN 1
			ELSE 0
			END) SeasonFemales
	,SUM(CASE WHEN (
					s.AcctId IS NOT NULL AND dc.Gender NOT IN ( 'M', 'F' )
				)
				OR (
					s.AcctId IS NOT NULL AND dc.Gender IS NULL
				)
			THEN 1
			ELSE 0
			END) SeasonUnk
FROM (
		SELECT
			EmailAddress,
			MAX(CreatedAt) AS CreatedAt,
			MAX(ID) AS ID,
			MAX(C_Season_Ticket_Account_Number1) AS AcctId
		FROM ods.Eloqua_Contact WITH (NOLOCK)
		GROUP BY EmailAddress
	) b
LEFT JOIN (
		SELECT 
			CAST(dc.AccountId AS VARCHAR(200)) AS AcctId, 
			CAST(dc.CD_Gender AS VARCHAR(5)) AS Gender 
		FROM rpt.vw_FactTicketSales f (NOLOCK)
		INNER JOIN dbo.DimCustomer dc (NOLOCK) 
			ON  f.DimCustomerId = dc.DimCustomerId
		INNER JOIN rpt.vw_DimPlan dpl (NOLOCK) 
			ON  f.DimPlanId = dpl.DimPlanId
		WHERE f.DimSeasonId IN ( 22 )
			AND dpl.PlanClass = 'FS'
		GROUP BY dc.AccountId, dc.CD_Gender 
	) s
	ON  b.AcctId = s.AcctId
LEFT JOIN (
		SELECT  
			dc.SSID,
			dc.CD_Gender AS Gender
		FROM rpt.vw_DimCustomer dc ( NOLOCK ) --ON b.EmailAddress = dc.EmailPrimary
		WHERE dc.SourceSystem = 'Eloqua Broncos'
			AND dc.CD_Gender <> 'u'
    ) dc 
	ON  b.ID = dc.SSID;
GO
