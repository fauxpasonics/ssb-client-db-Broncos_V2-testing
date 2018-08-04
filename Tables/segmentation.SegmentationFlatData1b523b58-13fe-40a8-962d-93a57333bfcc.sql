CREATE TABLE [segmentation].[SegmentationFlatData1b523b58-13fe-40a8-962d-93a57333bfcc]
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
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData1b523b58-13fe-40a8-962d-93a57333bfcc] ON [segmentation].[SegmentationFlatData1b523b58-13fe-40a8-962d-93a57333bfcc]
GO
