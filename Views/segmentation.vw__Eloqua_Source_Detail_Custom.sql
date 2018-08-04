SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [segmentation].[vw__Eloqua_Source_Detail_Custom]
AS
    SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
          , esource.ID AS SD_ID
          , esource.Source1 AS SD_Source1
          , esource.Email_Address1 AS SD_Email_Address1
    FROM    ods.EloquaCustom_SourceDetail esource WITH ( NOLOCK )
    INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.SSID = esource.ID
    WHERE   ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;


GO
