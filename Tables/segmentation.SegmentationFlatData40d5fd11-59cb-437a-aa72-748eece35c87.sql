CREATE TABLE [segmentation].[SegmentationFlatData40d5fd11-59cb-437a-aa72-748eece35c87]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_ETL_IsDeleted] [bit] NOT NULL,
[C_ETL_DeletedDate] [datetime] NULL,
[C_ID] [int] NOT NULL,
[C_Name] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_AccountName] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_BouncebackDate] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_IsBounceback] [bit] NULL,
[C_IsSubscribed] [bit] NULL,
[C_PostalCode] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_Province] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_SubscriptionDate] [datetime] NULL,
[C_UnsubscriptionDate] [datetime] NULL,
[C_CreatedAt] [datetime] NULL,
[C_CreatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_AccessedAt] [datetime] NULL,
[C_CurrentStatus] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_Depth] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_UpdatedAt] [datetime] NULL,
[C_UpdatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_FirstName] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_LastName] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData40d5fd11-59cb-437a-aa72-748eece35c87] ON [segmentation].[SegmentationFlatData40d5fd11-59cb-437a-aa72-748eece35c87]
GO
