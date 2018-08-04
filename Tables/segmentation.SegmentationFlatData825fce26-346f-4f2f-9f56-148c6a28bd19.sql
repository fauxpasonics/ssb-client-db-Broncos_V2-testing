CREATE TABLE [segmentation].[SegmentationFlatData825fce26-346f-4f2f-9f56-148c6a28bd19]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[G_EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[G_IsBounceback] [bit] NULL,
[G_IsSubscribed] [bit] NULL,
[BroncosPromos] [int] NULL,
[ICYMI] [int] NULL,
[OrangeHerd] [int] NULL,
[OrangeJuice] [int] NULL,
[Outlaws] [int] NULL,
[Stadium] [int] NULL,
[SurveyPanel] [int] NULL,
[CrushMember] [int] NOT NULL,
[SAField] [int] NOT NULL,
[Fanatics] [int] NOT NULL,
[Bunch] [int] NOT NULL,
[PRIMARY_ACT1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_MAJOR_CAT_NAME1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData825fce26-346f-4f2f-9f56-148c6a28bd19] ON [segmentation].[SegmentationFlatData825fce26-346f-4f2f-9f56-148c6a28bd19]
GO
