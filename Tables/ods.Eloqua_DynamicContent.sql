CREATE TABLE [ods].[Eloqua_DynamicContent]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduledFor] [datetime] NULL,
[SourceTemplatedId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Permissions] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedAt] [datetime] NULL,
[CreatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccessedAt] [datetime] NULL,
[CurrentStatus] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedAt] [datetime] NULL,
[UpdatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[Eloqua_DynamicContent] ADD CONSTRAINT [PK__Eloqua_D__7EF6BFCDDDBCBE87] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
