CREATE TABLE [dbo].[DimCustomerRank]
(
[SourceSystemSortOrder] [bigint] NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustomerId] [int] NOT NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidEmail] [int] NOT NULL,
[CustomerRowNumber] [bigint] NULL,
[CustomerSourceRank] [bigint] NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NULL,
[IsDeleted] [bit] NOT NULL,
[MaxSourceSystemRank] [int] NULL
)
GO
