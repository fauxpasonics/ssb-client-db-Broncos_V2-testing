CREATE TABLE [ods].[EloquaCustom_CustomerDataSportsAuthorityField]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_ACT1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_MAJOR_CAT_NAME1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[EloquaCustom_CustomerDataSportsAuthorityField] ADD CONSTRAINT [PK__EloquaCu__7EF6BFCDAD6FEBB9] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
