SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_DimClassTMId_FactKeyLookup] AS (
	SELECT DimClassTMId, ETL_SSID, ETL_SSID_class_id, ClassName
	FROM (
		SELECT DimClassTMId, ETL_SSID, ETL_SSID_class_id, ClassName
		, ROW_NUMBER() OVER (PARTITION BY ClassName ORDER BY upd_datetime DESC) RowRank
		FROM dbo.DimClassTM (NOLOCK)
	) a
	WHERE RowRank = 1
) 

GO
