CREATE TABLE [ods].[EloquaCustom_SkiData]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__EloquaCus__ETL_C__19EAC663] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__EloquaCus__ETL_U__1ADEEA9C] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__EloquaCus__ETL_I__1BD30ED5] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Points_Available1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rank1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total_Points_Earned1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Activity_Date1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ticket_Account_ID1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Address1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Username1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID1] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[EloquaCustom_SkiData] ADD CONSTRAINT [PK__EloquaCu__3214EC27A5E5065E] PRIMARY KEY CLUSTERED  ([ID])
GO
