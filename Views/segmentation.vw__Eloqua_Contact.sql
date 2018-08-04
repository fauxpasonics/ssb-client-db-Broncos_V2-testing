SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [segmentation].[vw__Eloqua_Contact]
AS
    SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
          , econtact.ETL_IsDeleted AS C_ETL_IsDeleted
          , econtact.ETL_DeletedDate AS C_ETL_DeletedDate
          , econtact.ID AS C_ID
          , econtact.Name AS C_Name
          , econtact.AccountName AS C_AccountName
          , econtact.BouncebackDate AS C_BouncebackDate
          , econtact.IsBounceback AS C_IsBounceback
          , econtact.IsSubscribed AS C_IsSubscribed
          , econtact.PostalCode AS C_PostalCode
          , econtact.Province AS C_Province
          , econtact.SubscriptionDate AS C_SubscriptionDate
          , econtact.UnsubscriptionDate AS C_UnsubscriptionDate
          , econtact.CreatedAt AS C_CreatedAt
          , econtact.CreatedBy AS C_CreatedBy
          , econtact.AccessedAt AS C_AccessedAt
          , econtact.CurrentStatus AS C_CurrentStatus
          , econtact.Depth AS C_Depth
          , econtact.UpdatedAt AS C_UpdatedAt
          , econtact.UpdatedBy AS C_UpdatedBy
          , econtact.EmailAddress AS C_EmailAddress
          , econtact.FirstName AS C_FirstName
          , econtact.LastName AS C_LastName
    FROM    ods.Eloqua_Contact econtact WITH ( NOLOCK )
    INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.SSID = CAST(econtact.ID AS VARCHAR(200))
    WHERE   ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
	--AND createdat> (GETDATE()-180)




GO
