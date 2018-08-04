CREATE TABLE [ods].[EloquaCustom_StorePurchaseHistory]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total_Spend1] [numeric] (38, 6) NULL,
[Product_Sub_Category1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Product_Category1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[EloquaCustom_StorePurchaseHistory] ADD CONSTRAINT [PK__EloquaCu__7EF6BFCD585CB452] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
