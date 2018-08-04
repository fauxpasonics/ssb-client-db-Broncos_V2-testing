CREATE TABLE [src].[EloquaCustom_SourceDetail]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [src].[EloquaCustom_SourceDetail] ADD CONSTRAINT [PK__EloquaCu__7EF6BFCD43668DED] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
