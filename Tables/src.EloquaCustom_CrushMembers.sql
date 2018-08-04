CREATE TABLE [src].[EloquaCustom_CrushMembers]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__EloquaCus__ETL_C__50335F29] DEFAULT (getdate()),
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataCardExternalId] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataCardCreatedAt] [datetime] NULL,
[DataCardUpdatedAt] [datetime] NULL
)
GO
