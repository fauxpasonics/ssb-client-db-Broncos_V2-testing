SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [segmentation].[vw__Eloqua_Click_Throughs]
AS
    SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
          , eclick.ID AS CTR_ID
          , eclick.CreatedAt AS CTR_CreatedAt
          , eclick.Type AS CTR_Type
          , eclick.AssetId AS CTR_AssetId
          , eclick.AssetName AS CTR_AssetName
          , eclick.AssetType AS CTR_AssetType
          , eclick.ContactId AS CTR_ContactId
          , eclick.EmailClickedThruLink AS CTR_EmailClickedThruLink
          , eclick.SubjectLine AS CTR_SubjectLine
          , eclick.EmailAddress AS CTR_EmailAddress
          , eclick.CampaignId AS CTR_CampaignId
    FROM    ods.Eloqua_ActivityEmailClickThrough eclick WITH ( NOLOCK )
            INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.SSID = eclick.ID
    WHERE   ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
	AND eclick.CreatedAt > (GETDATE()-180)



GO
