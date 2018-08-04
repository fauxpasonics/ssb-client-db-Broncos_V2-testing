SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC  [rpt].[Contacts_And_Email_Waterfall_load]
AS

IF OBJECT_ID('rpt.Contacts_And_Email_Waterfall', 'U') IS NOT NULL
    DROP TABLE rpt.Contacts_And_Email_Waterfall


SELECT *
INTO rpt.Contacts_And_Email_Waterfall
FROM (
SELECT
    sb.SourceSystem,
    SourceSystemSortOrder,
    COUNT(sb.DimCustomerId) AS TotalRecords,
    COUNT(DISTINCT sb.SSB_CRMSYSTEM_CONTACT_ID) AS SourceUnique,
    COUNT(CASE WHEN sb.PersonRowNumber = 1 THEN sb.SSB_CRMSYSTEM_CONTACT_ID END) AS UniqueToSource,
    COUNT(sb.EmailPrimary) AS TotalValidEmails,
    COUNT(DISTINCT sb.emailprimary) AS SourceUniqueValidEmails,
    COUNT(CASE WHEN isnull(sb.EmailPrimary,'') <> '' AND sb.EmailRowNumber = 1 THEN EmailPrimary END) AS UniqueToSourceValidEmails,
	GETDATE() AS ETL_Date
FROM (
			SELECT DISTINCT
				ssbid.SourceSystem,
				CASE WHEN ss.SourceSystemSortOrder IS NULL THEN 100000 ELSE ss.SourceSystemSortOrder END AS SourceSystemSortOrder,
				ssbid.SSB_CRMSYSTEM_CONTACT_ID,
				ssbid.DimCustomerId, 
				ROW_NUMBER() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ISNULL(SourceSystemSortOrder, 10000000)) AS PersonRowNumber, 
				ROW_NUMBER() OVER (PARTITION BY CASE WHEN ssbid.EmailPrimaryIsCleanStatus = 'Valid' THEN emailprimary ELSE NULL END
					 ORDER BY ISNULL(SourceSystemSortOrder, 10000000)) AS EmailRowNumber
				,CASE WHEN ssbid.EmailPrimaryIsCleanStatus = 'Valid' THEN emailprimary ELSE NULL END AS emailprimary
			FROM dbo.vwDimCustomer_ModAcctId ssbid (NOLOCK)
			LEFT JOIN (
					SELECT
						SourceSystem,
						ROW_NUMBER() OVER (ORDER BY ss.SourceSystemPriority DESC) AS SourceSystemSortOrder
					FROM mdm.SourceSystems WITH (NOLOCK)
					INNER JOIN (
							SELECT DISTINCT
								SourceSystemID,
								SourceSystemPriority
							FROM mdm.SourceSystemPriority (NOLOCK)
						) ss
						ON  ss.SourceSystemID = SourceSystems.SourceSystemID
				) ss
				ON  ssbid.SourceSystem = ss.SourceSystem
	) sb
GROUP BY
    sb.SourceSystemSortOrder,
    sb.SourceSystem
) x 
WHERE x.SourceSystem <> 'CI Model'

IF (SELECT MAX(CAST(etl_date AS date)) FROM [rpt].[Contacts_And_Email_Waterfall_History]) <> (SELECT CAST(GETDATE() AS date))
Insert into [rpt].[Contacts_And_Email_Waterfall_History]
Select 
    SourceSystem, 
    SourceSystemSortOrder, 
    TotalRecords, 
    SourceUnique, 
    UniqueToSource, 
    TotalValidEmails, 
    SourceUniqueValidEmails, 
    UniqueToSourceValidEmails, 
    ETL_Date
From rpt.Contacts_And_Email_Waterfall;

/*
SELECT * FROM rpt.Contacts_And_Email_Waterfall
SELECT * FROM rpt.Contacts_And_Email_Waterfall_History
*/
GO
