SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROC [rpt].[Cust_Waterfall_load] AS

CREATE TABLE #SourceRank (
SourceSystem VARCHAR(50)
,SortOrder INT
)

INSERT INTO #SourceRank

--SELECT dc.Sourcesystem
--	  ,RANK() OVER(ORDER BY ISNULL(ss.SortOrder,99), dc.SourceSystem) SortOrder
--FROM (  SELECT DISTINCT sourcesystem
--		FROM dimcustomerssbid
--		WHERE SourceSystem IS NOT NULL
--	 )dc
--	 LEFT JOIN rpt.SystemSort ss ON ss.SourceSystem = dc.Sourcesystem

SELECT SourceSystem, 
ROW_NUMBER() OVER (ORDER BY ss.SourceSystemPriority DESC) AS SortOrder
FROM mdm.SourceSystems WITH (NOLOCK)
JOIN (
SELECT DISTINCT SourceSystemID, SourceSystemPriority 
FROM mdm.SourceSystemPriority WITH (NOLOCK) ) ss ON ss.SourceSystemID = SourceSystems.SourceSystemID


SELECT z.SourceSystem
		, SortOrder
		, COUNT(z.DimCustomerId) TotalRecords
		, COUNT(DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID) SourceUnique
		, SUM(CASE WHEN PersonRowNumber = 1 THEN 1 ELSE 0 END)  AS UniqueCount
		, COUNT(CASE WHEN z.EmailPrimary IS NOT NULL THEN z.EmailPrimary end) AS TotalValidEmails
		, COUNT(DISTINCT CASE WHEN z.EmailPrimary IS NOT NULL AND z.PersonRowNumber = 1 THEN z.EmailPrimary end) AS SourceUniqueValidEmails
		--, SUM(CASE WHEN z.PersonRowNumber = 1 AND z.EmailPrimary IS NOT NULL THEN 1 ELSE 0 end) AS UniqueValidEmails
		, GETDATE() AS EtlDate
		, COUNT(DISTINCT CASE WHEN MaxSourceRank = 1 THEN z.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS UniqueToSource
		, 1 AS IsCurrentDay
		, GETDATE() AS dimdateid
FROM ( SELECT  SortOrder 
			  ,SourceSystem 
			  ,SSB_CRMSYSTEM_CONTACT_ID 
			  ,dimcustomerid
			  ,EmailPrimary 
			  ,personrownumber
			  ,MAX(sourceRank) AS MaxSourceRank
	   FROM (  SELECT ss.SortOrder 
					 ,ssbid.SourceSystem 
					 ,ssbid.SSB_CRMSYSTEM_CONTACT_ID 
					 ,ssbid.dimcustomerid
					 , dc.EmailPrimary
					 ,ROW_NUMBER() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ISNULL(SortOrder, 10000000)) AS PersonRowNumber
					 ,DENSE_RANK() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ss.SortOrder) AS sourceRank		
			   FROM [dbo].[dimcustomerssbid] ssbid (NOLOCK)
			    LEFT JOIN dbo.DimCustomer dc (NOLOCK) ON dc.DimCustomerId = ssbid.DimCustomerId AND dc.EmailPrimaryIsCleanStatus = 'Valid' -- New
				JOIN #SourceRank ss (NOLOCK) ON ssbid.SourceSystem = ss.SourceSystem
			where ssbid.IsDeleted = 0 and dc.IsDeleted = 0
			)a
	  GROUP BY SortOrder 
	  		  ,SourceSystem 
	  		  ,SSB_CRMSYSTEM_CONTACT_ID 
	  		  ,dimcustomerid
			  ,EmailPrimary
	  		  ,personrownumber
	 )z
GROUP BY z.SourceSystem, SortOrder



DROP TABLE #SourceRank

GO
