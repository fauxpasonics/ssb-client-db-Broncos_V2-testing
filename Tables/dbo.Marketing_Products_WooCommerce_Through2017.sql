CREATE TABLE [dbo].[Marketing_Products_WooCommerce_Through2017]
(
[Order_ID] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order_Date] [datetime] NULL,
[FULLName] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order_Total] [real] NULL,
[Shipping] [real] NULL,
[Shipping_Tax] [smallint] NULL,
[Address_Line1] [varchar] (44) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Line2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Product_Name] [varchar] (90) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qty_Purchased] [smallint] NULL,
[Price_EXCL_Tax] [smallint] NULL,
[Item_Tax] [real] NULL,
[Price_INCL_Tax] [real] NULL,
[Distinct_In_Order] [int] NULL
)
GO
