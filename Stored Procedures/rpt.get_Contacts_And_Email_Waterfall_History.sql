SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[get_Contacts_And_Email_Waterfall_History]
AS
WITH CTE_Data 
AS (
		SELECT 
			h.SourceSystem, 
			h.SourceSystemSortOrder, 
			h.TotalRecords, 
			h.SourceUnique, 
			h.UniqueToSource, 
			h.TotalValidEmails, 
			h.SourceUniqueValidEmails, 
			h.UniqueToSourceValidEmails, 
			h.ETL_Date,
			etl.Max_ETL_DateTime,
			etl.Max_ETL_Date
		FROM rpt.Contacts_And_Email_Waterfall_History h WITH (NOLOCK)
		CROSS JOIN (
				SELECT 
					MAX(ETL_Date) AS Max_ETL_DateTime,
					CAST(MAX(ETL_Date) AS DATE) AS Max_ETL_Date
				FROM rpt.Contacts_And_Email_Waterfall_History h WITH (NOLOCK)
			) etl
	),
CTE_POP 
AS (
		SELECT
			'Current' AS RecordType, 
			SourceSystem, 
			SourceSystemSortOrder, 
			AVG(TotalRecords) AS TotalRecords, 
			AVG(SourceUnique) AS SourceUnique, 
			AVG(UniqueToSource) AS UniqueToSource, 
			AVG(TotalValidEmails) AS TotalValidEmails, 
			AVG(SourceUniqueValidEmails) AS SourceUniqueValidEmails, 
			AVG(UniqueToSourceValidEmails) AS UniqueToSourceValidEmails,
			ETL_Date
		FROM CTE_Data
		WHERE ETL_Date = Max_ETL_DateTime
		GROUP BY
			SourceSystem, 
			SourceSystemSortOrder,
			ETL_Date
		UNION
		SELECT 
			RecordType,
			SourceSystem, 
			SourceSystemSortOrder, 
			AVG(TotalRecords) AS TotalRecords, 
			AVG(SourceUnique) AS SourceUnique, 
			AVG(UniqueToSource) AS UniqueToSource, 
			AVG(TotalValidEmails) AS TotalValidEmails, 
			AVG(SourceUniqueValidEmails) AS SourceUniqueValidEmails, 
			AVG(UniqueToSourceValidEmails) AS UniqueToSourceValidEmails,
			ETL_Date
		FROM (
				SELECT 'Month over Month' AS RecordType, *, RANK() OVER (ORDER BY ETL_Date ASC) AS RowNumber
				FROM CTE_Data
				WHERE CAST(ETL_date AS DATE) >= DATEADD(mm, -1, Max_ETL_Date)
			) h
		WHERE RowNumber = 1 
		GROUP BY
			RecordType,
			SourceSystem, 
			SourceSystemSortOrder,
			ETL_Date
		UNION
		SELECT 
			RecordType,
			SourceSystem, 
			SourceSystemSortOrder, 
			AVG(TotalRecords) AS TotalRecords, 
			AVG(SourceUnique) AS SourceUnique, 
			AVG(UniqueToSource) AS UniqueToSource, 
			AVG(TotalValidEmails) AS TotalValidEmails, 
			AVG(SourceUniqueValidEmails) AS SourceUniqueValidEmails, 
			AVG(UniqueToSourceValidEmails) AS UniqueToSourceValidEmails,
			ETL_Date
		FROM (
				SELECT 'Year over Year' AS RecordType, *, RANK() OVER (ORDER BY ETL_Date ASC) AS RowNumber
				FROM CTE_Data
				WHERE CAST(ETL_date AS DATE) >= DATEADD(YYYY, -1, Max_ETL_Date)
			) h
		WHERE RowNumber = 1 
		GROUP BY
			RecordType,
			SourceSystem, 
			SourceSystemSortOrder,
			ETL_Date
	)
SELECT 
	c.SourceSystem,
	c.SourceSystemSortOrder AS SortOrder,
	c.TotalRecords,
	(c.TotalRecords - m.TotalRecords) AS TotalRecords_Monthly_Growth,
	CAST((c.TotalRecords - m.TotalRecords) / (c.TotalRecords * 1.) AS DECIMAL(19,6)) AS [TotalRecords_Monthly_Growth%],
	(c.TotalRecords - y.TotalRecords) AS TotalRecords_Yearly_Growth,
	CAST((c.TotalRecords - y.TotalRecords) / (c.TotalRecords * 1.) AS DECIMAL(19,6)) AS [TotalRecords_Yearly_Growth%],
	c.SourceUnique,
	(c.SourceUnique - m.SourceUnique) AS SourceUnique_Monthly_Growth,
	CAST((c.SourceUnique - m.SourceUnique) / (c.SourceUnique * 1.) AS DECIMAL(19,6)) AS [SourceUnique_Monthly_Growth%],
	(c.SourceUnique - y.SourceUnique) AS SourceUnique_Yearly_Growth,
	CAST((c.SourceUnique - y.SourceUnique) / (c.SourceUnique * 1.) AS DECIMAL(19,6)) AS [SourceUnique_Yearly_Growth%],
	c.UniqueToSource AS [UniqueCount],
	(c.UniqueToSource - m.UniqueToSource) AS UniqueCount_Monthly_Growth,
	CAST((c.UniqueToSource - m.UniqueToSource) / (c.UniqueToSource * 1.) AS DECIMAL(19,6)) AS [UniqueCount_Monthly_Growth%],
	(c.UniqueToSource - y.UniqueToSource) AS UniqueCount_Yearly_Growth,
	CAST((c.UniqueToSource - y.UniqueToSource) / (c.UniqueToSource * 1.) AS DECIMAL(19,6)) AS [UniqueCount_Yearly_Growth%],
	c.TotalValidEmails,
	(c.TotalValidEmails - m.TotalValidEmails) AS TotalValidEmails_Monthly_Growth,
	CAST((c.TotalValidEmails - m.TotalValidEmails) / (c.TotalValidEmails * 1.) AS DECIMAL(19,6)) AS [TotalValidEmails_Monthly_Growth%],
	(c.TotalValidEmails - y.TotalValidEmails) AS TotalValidEmails_Yearly_Growth,
	CAST((c.TotalValidEmails - y.TotalValidEmails) / (c.TotalValidEmails * 1.) AS DECIMAL(19,6)) AS [TotalValidEmails_Yearly_Growth%],
	c.SourceUniqueValidEmails,
	(c.SourceUniqueValidEmails - m.SourceUniqueValidEmails) AS SourceUniqueValidEmails_Monthly_Growth,
	CAST((c.SourceUniqueValidEmails - m.SourceUniqueValidEmails) / (c.SourceUniqueValidEmails * 1.) AS DECIMAL(19,6)) AS [SourceUniqueValidEmails_Monthly_Growth%],
	(c.SourceUniqueValidEmails - y.SourceUniqueValidEmails) AS SourceUniqueValidEmails_Yearly_Growth,
	CAST((c.SourceUniqueValidEmails - y.SourceUniqueValidEmails) / (c.SourceUniqueValidEmails * 1.) AS DECIMAL(19,6)) AS [SourceUniqueValidEmails_Yearly_Growth%],
	c.UniqueToSourceValidEmails,
	(c.UniqueToSourceValidEmails - m.UniqueToSourceValidEmails) AS UniqueToSourceValidEmails_Monthly_Growth,
	CAST((c.UniqueToSourceValidEmails - m.UniqueToSourceValidEmails) / (c.UniqueToSourceValidEmails * 1.) AS DECIMAL(19,6)) AS [UniqueToSourceValidEmails_Monthly_Growth%],
	(c.UniqueToSourceValidEmails - y.UniqueToSourceValidEmails) AS UniqueToSourceValidEmails_Yearly_Growth,
	CAST((c.UniqueToSourceValidEmails - y.UniqueToSourceValidEmails) / (c.UniqueToSourceValidEmails * 1.) AS DECIMAL(19,6)) AS [UniqueToSourceValidEmails_Yearly_Growth%],
	c.ETL_Date AS [EtlDate]
FROM CTE_POP c
LEFT OUTER JOIN CTE_POP m
	ON  m.RecordType = 'Month over Month'
	AND c.SourceSystem = m.SourceSystem
LEFT OUTER JOIN CTE_POP y
	ON  y.RecordType = 'Year over Year'
	AND c.SourceSystem = y.SourceSystem
WHERE c.RecordType = 'Current'
ORDER BY c.SourceSystemSortOrder
GO
