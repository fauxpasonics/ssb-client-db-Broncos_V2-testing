CREATE TABLE [segmentation].[SegmentationFlatDatab16c2c61-abf1-4715-9c9f-09847f275ca4]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PV_CreatedAt] [datetime] NULL,
[PV_Type] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_ContactId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_IPAddress] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_Url] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_CampaignId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_ReferrerUrl] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_VisitorId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_VisitorExternalId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_WebVisitId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PV_IsWebTrackingOptedIn] [bit] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDatab16c2c61-abf1-4715-9c9f-09847f275ca4] ON [segmentation].[SegmentationFlatDatab16c2c61-abf1-4715-9c9f-09847f275ca4]
GO
