CREATE TABLE [src].[Eloqua_CampaignField]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataType] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayType] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayIndex] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsReadOnly] [bit] NULL,
[IsRequired] [bit] NULL,
[CreatedAt] [datetime] NULL,
[CreatedBy] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Depth] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [datetime] NULL CONSTRAINT [DF__Eloqua_Ca__ETL_C__76EBA2E9] DEFAULT (getdate())
)
GO
ALTER TABLE [src].[Eloqua_CampaignField] ADD CONSTRAINT [PK__Eloqua_C__7EF6BFCDC9E85A8C] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
