CREATE TABLE [stg].[Sync_temp_ods_TurnkeySurveyOutput]
(
[ETL__multi_query_value_for_audit] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SurveyName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubQuestion] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Heading] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeyId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartedDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompletedDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPageNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [stg].[Sync_temp_ods_TurnkeySurveyOutput] ADD CONSTRAINT [PK__Sync_tem__19364FD2625FE517] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
