CREATE TABLE [dbo].[DimEmployee]
(
[DimEmployeeId] [int] NOT NULL IDENTITY(1, 1),
[EmployeeNumber] [int] NULL,
[EmployeeFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployeeLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimEmployee_CreateDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimEmployee_UpdateDate] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_DimEmployee_DeleteFlag] DEFAULT ((0)),
[DeleteDate] [datetime] NULL,
[SSID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[odsEmployeeId] [bigint] NULL,
[loadControlId] [bigint] NULL,
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [dbo].[DimEmployee] ADD CONSTRAINT [PK_DimEmployee] PRIMARY KEY CLUSTERED  ([DimEmployeeId])
GO
