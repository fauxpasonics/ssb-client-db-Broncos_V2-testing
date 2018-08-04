SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[MDM_PostProcessing]
AS
BEGIN


EXEC dbo.sp_FanFactors_LoadTable;


EXEC dbo.sp_FanFactors_StandardizedRank


END


GO
