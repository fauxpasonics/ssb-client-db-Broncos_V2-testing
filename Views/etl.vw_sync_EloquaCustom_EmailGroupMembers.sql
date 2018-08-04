SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_sync_EloquaCustom_EmailGroupMembers] AS (

	SELECT * FROM ods.EloquaCustom_EmailGroupMembers (NOLOCK)
)

GO
