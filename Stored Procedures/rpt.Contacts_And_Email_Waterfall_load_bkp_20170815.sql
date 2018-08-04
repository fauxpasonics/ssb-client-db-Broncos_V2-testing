SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROC  [rpt].[Contacts_And_Email_Waterfall_load_bkp_20170815]
AS

IF OBJECT_ID('rpt.Contacts_And_Email_Waterfall', 'U') IS NOT NULL
    DROP TABLE rpt.Contacts_And_Email_Waterfall


IF OBJECT_ID('tempdb..#ssbid') IS NOT NULL
    DROP TABLE #ssbid
SELECT DISTINCT
    ssbid.SourceSystem,
    ss.SourceSystemSortOrder,
    ssbid.SSB_CRMSYSTEM_CONTACT_ID,
    ssbid.DimCustomerId,
    ROW_NUMBER() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ISNULL(SourceSystemSortOrder, 10000000)) AS PersonRowNumber,
    CASE WHEN other.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END AS UniqueToSource,
    dc.EmailPrimary
INTO #ssbid
FROM dbo.DimCustomerSSBID ssbid (NOLOCK) 
LEFT OUTER JOIN (
        SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, SourceSystem
        FROM dbo.DimCustomerSSBID (NOLOCK)
        WHERE IsDeleted = 0
    ) other
    ON  ssbid.SSB_CRMSYSTEM_CONTACT_ID = other.SSB_CRMSYSTEM_CONTACT_ID
    AND ssbid.SourceSystem <> other.SourceSystem
LEFT OUTER JOIN dbo.DimCustomer dc (NOLOCK)
    ON  dc.DimCustomerId = ssbid.DimCustomerId
    AND dc.EmailPrimaryIsCleanStatus = 'Valid'
INNER JOIN (
        SELECT
            SourceSystem,
            ROW_NUMBER() OVER (ORDER BY ss.SourceSystemPriority DESC) AS SourceSystemSortOrder
        FROM mdm.SourceSystems
        INNER JOIN (
                SELECT DISTINCT
                    SourceSystemID,
                    SourceSystemPriority
                FROM mdm.SourceSystemPriority (NOLOCK)
            ) ss
            ON  ss.SourceSystemID = SourceSystems.SourceSystemID
    ) ss
    ON  ssbid.SourceSystem = ss.SourceSystem
WHERE ssbid.IsDeleted = 0
--    AND dc.IsDeleted = 0

SELECT
    SourceSystem,
    SourceSystemSortOrder,
    COUNT(DISTINCT DimCustomerId) AS TotalRecords,
    COUNT(DISTINCT SSB_CRMSYSTEM_CONTACT_ID) AS SourceUnique,
    COUNT(DISTINCT CASE WHEN PersonRowNumber = 1 THEN SSB_CRMSYSTEM_CONTACT_ID END) AS UniqueToSource,
  --  COUNT(DISTINCT UniqueToSource) AS UniqueToSource,
    COUNT(CASE WHEN EmailPrimary IS NOT NULL THEN EmailPrimary END) AS TotalValidEmails,
    COUNT(DISTINCT CASE WHEN EmailPrimary IS NOT NULL THEN EmailPrimary END) AS SourceUniqueValidEmails,
    COUNT(DISTINCT CASE WHEN EmailPrimary IS NOT NULL AND UniqueToSource IS NOT NULL THEN EmailPrimary END) AS UniqueToSourceValidEmails,
    GETDATE() AS ETL_Date
INTO rpt.Contacts_And_Email_Waterfall
FROM #ssbid
GROUP BY
    SourceSystemSortOrder,
    SourceSystem
ORDER BY SourceSystemSortOrder

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
GO
