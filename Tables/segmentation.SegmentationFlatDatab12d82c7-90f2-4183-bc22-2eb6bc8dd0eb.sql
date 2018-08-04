CREATE TABLE [segmentation].[SegmentationFlatDatab12d82c7-90f2-4183-bc22-2eb6bc8dd0eb]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Archtics_Acct_Id] [int] NULL,
[R_Activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Activity_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Transaction_Date] [date] NULL,
[R_Season_Year] [int] NULL,
[R_Event_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Event_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Event_Time] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Event_Date] [datetime] NULL,
[R_Section_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Row_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_First_Seat] [int] NULL,
[R_Qty_Seat] [int] NULL,
[R_Orig_purchase_price] [numeric] (29, 2) NULL,
[R_TE_Purchase_Price] [numeric] (18, 0) NULL,
[R_TE_Price_Difference] [numeric] (30, 0) NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDatab12d82c7-90f2-4183-bc22-2eb6bc8dd0eb] ON [segmentation].[SegmentationFlatDatab12d82c7-90f2-4183-bc22-2eb6bc8dd0eb]
GO
