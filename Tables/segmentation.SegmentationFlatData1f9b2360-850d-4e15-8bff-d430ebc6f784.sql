CREATE TABLE [segmentation].[SegmentationFlatData1f9b2360-850d-4e15-8bff-d430ebc6f784]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailOptIn] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Client_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderDate] [datetime] NULL,
[ProductCategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductSubCategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtySold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitPrice] [decimal] (18, 6) NULL,
[OrderDiscountTotal] [decimal] (18, 6) NULL,
[OrderGrossSubTotal] [decimal] (18, 6) NULL,
[OrderTaxableSubTotal] [decimal] (18, 6) NULL,
[OrderNonTaxableSubTotal] [decimal] (18, 6) NULL,
[OrderTaxTotal] [decimal] (18, 6) NULL,
[OrderNetTotal] [decimal] (18, 6) NULL,
[OrderShipTotal] [decimal] (18, 6) NULL,
[Total_Of_Sale_Paid_By_Account_Order] [decimal] (18, 6) NULL,
[OrderPromo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddress0] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddress1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddress2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddressCity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddressState] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddressCounty] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddressZip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddressTel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddressAttention] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillAddress0] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillAddress1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillAddress2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillAddressCity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillAddressState] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BilAddressCountry] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillAddressZip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsTeamShop] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData1f9b2360-850d-4e15-8bff-d430ebc6f784] ON [segmentation].[SegmentationFlatData1f9b2360-850d-4e15-8bff-d430ebc6f784]
GO
