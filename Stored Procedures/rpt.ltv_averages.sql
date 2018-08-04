SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[ltv_averages]
AS
	
SELECT  AVG(NULLIF(vlb.Fanatics_LTV, 0)) AS Avg_Fanatics
      , AVG(NULLIF(vlb.TM_LTV, 0)) AS Avg_TM
      , AVG(NULLIF(vlb.TEX_LTV, 0)) AS Avg_Tex
FROM    rpt.vw_ltv_base AS vlb;
GO
