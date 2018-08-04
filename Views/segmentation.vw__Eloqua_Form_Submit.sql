SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [segmentation].[vw__Eloqua_Form_Submit]
AS
    WITH    ContactID_FIX
              AS (
                   SELECT   ETL_ID
                          , ETL_CreatedDate
                          , ETL_UpdatedDate
                          , ETL_IsDeleted
                          , ETL_DeletedDate
                          , ETL_DeltaHashKey
                          , ID
                          , Name
                          , CreatedAt
                          , Type
                          , AssetName
                          , AssetId
                          , AssetType
                          , CAST(ContactId AS NVARCHAR(255)) AS ContactID
                          , Collection
                          , FormName
                          , FormData
                          , RawData
                          , CampaignId
                   FROM     ods.Eloqua_ActivityFormSubmit
                 )
    SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID 
          , ContactID_FIX.ID AS F_ID
          , ContactID_FIX.Name AS F_Name
          , ContactID_FIX.CreatedAt AS F_CreatedAt
          , ContactID_FIX.Type AS F_Type
          , ContactID_FIX.AssetName AS F_AssetName
          , ContactID_FIX.AssetId AS F_AssetId
          , ContactID_FIX.AssetType AS F_AssetType
          , ContactID_FIX.ContactID AS F_ContactID
          , ContactID_FIX.Collection AS F_Collection
          , ContactID_FIX.FormName AS F_FormName
          , ContactID_FIX.FormData AS F_FormData
          , ContactID_FIX.RawData AS F_RawData
          , ContactID_FIX.CampaignId AS F_CampaignId
    FROM    dbo.dimcustomerssbid ssbid WITH (NOLOCK)
    INNER JOIN ContactID_FIX WITH (NOLOCK) ON ContactID_FIX.ContactID = ssbid.SSID
  WHERE   ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG = 1;






GO
