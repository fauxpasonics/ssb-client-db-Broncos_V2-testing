CREATE TABLE [src].[EloquaCustom_StorePurchaseHistory]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total_Spend1] [numeric] (38, 6) NULL,
[Product_Sub_Category1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Product_Category1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [src].[EloquaCustom_StorePurchaseHistory] ADD CONSTRAINT [PK__EloquaCu__7EF6BFCDBE6C5A6C] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
