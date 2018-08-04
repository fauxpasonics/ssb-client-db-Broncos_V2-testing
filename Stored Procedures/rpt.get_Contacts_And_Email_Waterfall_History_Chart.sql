SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[get_Contacts_And_Email_Waterfall_History_Chart]
	@SourceSystem VARCHAR(50) = 'Total'
AS
--EXEC rpt.get_Contacts_And_Email_Waterfall_History_Chart 'Eloqua Broncos'
--DECLARE @sourcesystem VARCHAR(50) = 'All';

DECLARE @MonthsCount INT
SELECT @MonthsCount = COUNT(DISTINCT CAST(DATEPART(mm, ETL_Date) AS VARCHAR(2)) + '.' + CAST(DATEPART(yy, ETL_Date) AS VARCHAR(4)))
FROM rpt.Contacts_And_Email_Waterfall_History;

WITH CTE_Daily
AS (
		SELECT 
			SourceSystem, 
			SourceSystemSortOrder, 
			AVG(TotalRecords) AS TotalRecords, 
			AVG(SourceUnique) AS SourceUnique, 
			AVG(UniqueToSource) AS UniqueToSource, 
			AVG(TotalValidEmails) AS TotalValidEmails, 
			AVG(SourceUniqueValidEmails) AS SourceUniqueValidEmails, 
			AVG(UniqueToSourceValidEmails) AS UniqueToSourceValidEmails, 
			CAST(ETL_Date AS DATE) AS ETL_Date,
			DENSE_RANK() OVER (PARTITION BY DATEPART(MM, ETL_Date), DATEPART(YYYY, ETL_Date) ORDER BY CAST(ETL_Date AS DATE)) AS xRowNum
		FROM [rpt].[Contacts_And_Email_Waterfall_History] WITH (NOLOCK)
		WHERE (SourceSystem = @SourceSystem OR @SourceSystem = 'Total' OR @SourceSystem = 'All')
		GROUP BY
			SourceSystem, 
			SourceSystemSortOrder, 
			ETL_Date 
	) 

SELECT 
	SourceSystem, 
	SourceSystemSortOrder, 
	--TotalRecords, 
	SourceUnique, 
	UniqueToSource, 
	--TotalValidEmails, 
	SourceUniqueValidEmails, 
	UniqueToSourceValidEmails, 
	ETL_Date
FROM (
		SELECT 
			SourceSystem, 
			SourceSystemSortOrder, 
			TotalRecords, 
			SourceUnique, 
			UniqueToSource, 
			TotalValidEmails, 
			SourceUniqueValidEmails, 
			UniqueToSourceValidEmails, 
			ETL_Date,
			xRowNum
		FROM CTE_Daily
		UNION
		SELECT
			'Total' AS SourceSystem, 
			0 AS SourceSystemSortOrder, 
			SUM(TotalRecords) AS TotalRecords, 
			SUM(SourceUnique) AS SourceUnique, 
			SUM(UniqueToSource) AS UniqueToSource, 
			SUM(TotalValidEmails) AS TotalValidEmails, 
			SUM(SourceUniqueValidEmails) AS SourceUniqueValidEmails, 
			SUM(UniqueToSourceValidEmails) AS UniqueToSourceValidEmails, 
			ETL_Date,
			xRowNum
		FROM CTE_Daily
		GROUP BY
			ETL_Date,
			xRowNum
	) A
WHERE (SourceSystem = @SourceSystem or @SourceSystem = 'All')
	AND ETL_DATE > GETDATE() - 367
	--If you wanted to limit it to first of month values instead of daily values.  Would limit the rows being returned to the report!
	--AND (@MonthsCount <= 6 OR xRowNum = 1)

ORDER BY SourceSystemSortOrder, ETL_Date
GO
