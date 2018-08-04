CREATE TABLE [rpt].[Contacts_And_Email_Waterfall_History]
(
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemSortOrder] [bigint] NULL,
[TotalRecords] [int] NULL,
[SourceUnique] [int] NULL,
[UniqueToSource] [int] NULL,
[TotalValidEmails] [int] NULL,
[SourceUniqueValidEmails] [int] NULL,
[UniqueToSourceValidEmails] [int] NULL,
[ETL_Date] [datetime] NOT NULL
)
GO
