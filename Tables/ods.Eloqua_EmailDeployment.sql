CREATE TABLE [ods].[Eloqua_EmailDeployment]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[Name] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduledFor] [datetime] NULL,
[SourceTemplatedId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedAt] [datetime] NULL,
[CreatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccessedAt] [datetime] NULL,
[CurrentStatus] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SuccessfulSendCount] [int] NULL,
[FailedSendCount] [int] NULL,
[SentContent] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SentSubject] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndAt] [datetime] NULL,
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[Eloqua_EmailDeployment] ADD CONSTRAINT [PK__Eloqua_E__7EF6BFCDA311721D] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
