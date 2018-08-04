CREATE TABLE [dbo].[source_load_audit]
(
[Client] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SS_Table] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [date] NULL,
[ETL_UpdatedDate] [date] NULL,
[MDM_CraetedDate] [date] NULL,
[MDM_UpdatedDate] [date] NULL
)
GO
