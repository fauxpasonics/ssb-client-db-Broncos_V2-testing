CREATE TABLE [zzz].[ods__TM_ListCode_bkp_700Rollout]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[acct_id] [int] NULL,
[code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [int] NULL,
[sort_seq] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [zzz].[ods__TM_ListCode_bkp_700Rollout] ADD CONSTRAINT [PK__TM_ListC__3213E83F6CD3BF63] PRIMARY KEY CLUSTERED  ([id])
GO
