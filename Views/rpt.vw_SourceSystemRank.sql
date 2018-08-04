SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw_SourceSystemRank]
AS

SELECT 
	SourceSystem, 
	ROW_NUMBER() OVER (ORDER BY ss.SourceSystemPriority DESC) AS SortOrder
FROM mdm.SourceSystems WITH (NOLOCK)
JOIN (
	SELECT 
		DISTINCT SourceSystemID, 
		SourceSystemPriority 
	FROM mdm.SourceSystemPriority WITH (NOLOCK) 
) ss 
	ON ss.SourceSystemID = SourceSystems.SourceSystemID
GO
