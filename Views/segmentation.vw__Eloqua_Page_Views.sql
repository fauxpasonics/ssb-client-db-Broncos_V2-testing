SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [segmentation].[vw__Eloqua_Page_Views]
AS
    SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
          , eactivity.ID AS PV_ID
          , eactivity.CreatedAt AS PV_CreatedAt
          , eactivity.Type AS PV_Type
          , eactivity.ContactId AS PV_ContactId
          , eactivity.IPAddress AS PV_IPAddress
          , eactivity.Url AS PV_Url
          , eactivity.CampaignId AS PV_CampaignId
          , eactivity.ReferrerUrl AS PV_ReferrerUrl
          , eactivity.VisitorId AS PV_VisitorId
          , eactivity.VisitorExternalId AS PV_VisitorExternalId
          , eactivity.WebVisitId AS PV_WebVisitId
          , eactivity.IsWebTrackingOptedIn AS PV_IsWebTrackingOptedIn
    FROM    ods.Eloqua_ActivityPageView eactivity WITH ( NOLOCK )
    INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.SSID = eactivity.ID
    WHERE   ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
	AND eactivity.CreatedAt > (GETDATE() - 180)




GO
