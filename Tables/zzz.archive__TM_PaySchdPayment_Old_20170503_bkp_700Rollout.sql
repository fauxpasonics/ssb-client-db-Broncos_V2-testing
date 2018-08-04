CREATE TABLE [zzz].[archive__TM_PaySchdPayment_Old_20170503_bkp_700Rollout]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[payment_Schedule_id] [int] NULL,
[payment_number] [int] NULL,
[due_date] [datetime] NULL,
[percent_due] [decimal] (18, 6) NULL,
[payment_description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[archive__TM_PaySchdPayment_Old_20170503_bkp_700Rollout] ADD CONSTRAINT [PK__TM_PaySc__3213E83F120627C6] PRIMARY KEY CLUSTERED  ([id])
GO
