CREATE TABLE [etl].[TM_Cust_AdvancedProcessingQueue]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_ProcessedDate] [datetime] NULL,
[acct_id] [int] NULL,
[Orig_CustNameId] [int] NULL,
[Orig_SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New_CustNameId] [int] NULL,
[New_SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Orig_NameCurrentPrimaryCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Orig_NameNewPrimaryCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [etl].[TM_Cust_AdvancedProcessingQueue] ADD CONSTRAINT [PK__TM_Cust___7EF6BFCDF45EAE33] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
