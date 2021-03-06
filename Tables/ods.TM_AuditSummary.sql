CREATE TABLE [ods].[TM_AuditSummary]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAN] [int] NULL,
[event] [int] NULL,
[groups] [int] NULL,
[comp] [int] NULL,
[held] [int] NULL,
[avail] [int] NULL,
[kill] [int] NULL,
[revenue] [decimal] (18, 6) NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[audithostsold] [int] NULL,
[auditarchticssold] [int] NULL,
[ticketarchticssold] [int] NULL,
[tickethostsold] [int] NULL,
[ticketavailsold] [int] NULL,
[diffhostsold] [int] NULL,
[diffarchticssold] [int] NULL,
[event_id] [int] NULL,
[export_datetime] [datetime] NULL,
[pc_ticket] [decimal] (18, 6) NULL,
[pc_tax] [decimal] (18, 6) NULL,
[pc_licfee] [decimal] (18, 6) NULL,
[pc_other1] [decimal] (18, 6) NULL,
[pc_other2] [decimal] (18, 6) NULL,
[pc_other3] [decimal] (18, 6) NULL,
[pc_other4] [decimal] (18, 6) NULL,
[pc_other5] [decimal] (18, 6) NULL,
[pc_other6] [decimal] (18, 6) NULL,
[pc_other7] [decimal] (18, 6) NULL,
[pc_other8] [decimal] (18, 6) NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_AuditSummary] ON [ods].[TM_AuditSummary]
GO
