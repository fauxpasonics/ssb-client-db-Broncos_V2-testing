CREATE TABLE [ods].[TurnkeySurveyOutput]
(
[ETL__multi_query_value_for_audit] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SurveyName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubQuestion] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Heading] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeyId] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartedDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompletedDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPageNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
