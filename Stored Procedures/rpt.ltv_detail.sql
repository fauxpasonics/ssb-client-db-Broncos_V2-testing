SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rpt].[ltv_detail]
AS
	
SELECT  vlb.SSB_CRMSYSTEM_CONTACT_ID
      , vlb.EmailPrimary
      , vlb.IsSubscribed
      , vlb.IsBounceback
      , vlb.Fanatics_LTV
      , vlb.TM_LTV
      , vlb.TEX_LTV
FROM    rpt.vw_ltv_base AS vlb;
GO
