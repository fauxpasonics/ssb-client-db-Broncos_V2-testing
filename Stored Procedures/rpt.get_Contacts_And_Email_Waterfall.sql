SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[get_Contacts_And_Email_Waterfall]
AS
--Data is loaded in: rpt.Contacts_And_Email_Waterfall_Load
SELECT 
	 [SourceSystem]
	,SourceSystemSortOrder AS SortOrder
	,[TotalRecords]
	,[SourceUnique]
	,UniqueToSource AS [UniqueCount]
	,[TotalValidEmails]
	,[SourceUniqueValidEmails]
	,ETL_Date AS [EtlDate]
FROM rpt.Contacts_And_Email_Waterfall

ORDER BY SourceSystemSortOrder
GO
