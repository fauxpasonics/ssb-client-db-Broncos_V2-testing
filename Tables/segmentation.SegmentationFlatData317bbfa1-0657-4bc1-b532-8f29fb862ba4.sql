CREATE TABLE [segmentation].[SegmentationFlatData317bbfa1-0657-4bc1-b532-8f29fb862ba4]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SD_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SD_Source1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SD_Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData317bbfa1-0657-4bc1-b532-8f29fb862ba4] ON [segmentation].[SegmentationFlatData317bbfa1-0657-4bc1-b532-8f29fb862ba4]
GO
