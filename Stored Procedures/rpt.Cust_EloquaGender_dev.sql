SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[Cust_EloquaGender_dev]
WITH RECOMPIle
AS


--DROP TABLE #BaseSet
--DROP TABLE #Seasons
--DROP TABLE #stage
--DECLARE @ReportType VARCHAR(10) = 'All'

select 
	emailaddress, createdat,Id, C_Season_Ticket_Account_Number1
INTO   #BaseSet_a
FROM    ods.Eloqua_Contact WITH ( NOLOCK )

select  
	EmailAddress
	, MAX(CreatedAt) AS CreatedAt
	, MAX(ID) AS ID
	, MAX(C_Season_Ticket_Account_Number1) AS AcctId
INTO   #BaseSet
FROM    #BaseSet_a WITH ( NOLOCK )
GROUP BY EmailAddress;

drop table #baseset_a


CREATE TABLE #seasons ( AcctId VARCHAR(200), Gender VARCHAR(5) );

/*IF ( @ReportType = 'Season' )
BEGIN*/
INSERT #seasons
SELECT  dc.AccountId AcctId, dc.CD_Gender Gender 
FROM    rpt.vw_FactTicketSales f (NOLOCK)
INNER JOIN dbo.DimCustomer dc (NOLOCK) ON f.DimCustomerId = dc.DimCustomerId
--INNER JOIN dbo.dimcustomerssbid ssbid (NOLOCK) ON dc.DimCustomerId = ssbid.DimCustomerId
INNER JOIN rpt.vw_DimPlan dpl (NOLOCK) ON f.DimPlanId = dpl.DimPlanId
WHERE   f.DimSeasonId IN ( 22 )
        AND dpl.PlanClass = 'FS'
GROUP BY dc.AccountId, dc.CD_Gender 
--END
		
		
SELECT b.*, dc.CD_Gender Gender, s.AcctId SAcctId
INTO #Stage
FROM #BaseSet b WITH ( NOLOCK )
LEFT JOIN #seasons s WITH ( NOLOCK ) ON b.AcctId = s.AcctId
LEFT JOIN 
(
	SELECT ssid, dc.CD_Gender
	FROM [rpt].[vw_DimCustomer] dc (nolock) --ON b.EmailAddress = dc.EmailPrimary
	
	WHERE  dc.SourceSystem = 'Eloqua Broncos'
	AND dc.CD_Gender <> 'u'
)dc ON b.ID = dc.SSID
/*WHERE   (
        ISNULL(s.AcctId, '') <> ''
        OR @ReportType = 'All'
    )*/

--SELECT count(*), gender FROM #stage GROUP BY gender

SELECT  
	SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) Males
	, SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) Females
	, SUM(CASE WHEN Gender NOT IN ( 'M', 'F' ) OR gender IS null THEN 1 ELSE 0 END) Unk
	, SUM(CASE WHEN s.SAcctId IS NOT NULL AND Gender = 'M' THEN 1	ELSE 0	END) SeasonMales 
	, SUM(CASE WHEN s.SAcctId IS NOT NULL AND Gender = 'F' THEN 1	ELSE 0	END) SeasonFemales 
	, SUM(CASE WHEN (s.SAcctId IS NOT NULL AND Gender NOT IN ( 'M', 'F' )) OR (s.SAcctId IS NOT NULL AND gender IS NULL) THEN 1	ELSE 0	END) SeasonUnk
FROM #stage s
/*FROM    dbo.DimCustomer AS dc (NOLOCK)
JOIN #stage bs ON bs.EmailAddress = dc.EmailPrimary
INNER JOIN #BaseSet AS bs (NOLOCK) ON bs.EmailAddress = dc.EmailPrimary
LEFT JOIN #seasons s (NOLOCK) ON s.AcctId = bs.AcctId
WHERE   dc.SourceSystem = 'Eloqua Broncos'
        AND dc.CD_Gender <> 'u'
        AND (
                ISNULL(s.AcctId, '') <> ''
                OR @ReportType = 'All'
            );*/

	
	


GO
