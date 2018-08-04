CREATE TABLE [zzz].[archive__TM_SellLocation_Old_20170503_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[sell_location_id] [int] NULL,
[sell_location_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sell_location_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sell_location_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[outlet_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[org_id] [int] NULL,
[active] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[protected] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sort_order] [int] NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [datetime] NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_SellLo__Inser__0A688BB1] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_SellLo__Updat__0B5CAFEA] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[archive__TM_SellLocation_Old_20170503_bkp_700Rollout] ADD CONSTRAINT [PK__TM_SellL__3213E83FA98330A8] PRIMARY KEY CLUSTERED  ([id])
GO
