CREATE TABLE [src].[EloquaCustom_CustomerDataSportsAuthorityField]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_ACT1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_MAJOR_CAT_NAME1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [src].[EloquaCustom_CustomerDataSportsAuthorityField] ADD CONSTRAINT [PK__EloquaCu__7EF6BFCD709B5415] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
