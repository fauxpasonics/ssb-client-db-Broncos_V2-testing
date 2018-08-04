CREATE TABLE [src].[EloquaCustom_SkiData]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [src].[EloquaCustom_SkiData] ADD CONSTRAINT [PK__EloquaCu__7EF6BFCD948FDACC] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
