CREATE TABLE [src].[SkiData_UsersReport]
(
[UserID] [int] NULL,
[Username] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (76) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketAccountID] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastActivityDate] [datetime] NULL,
[TotalPointsEarned] [int] NULL,
[Rank] [int] NULL,
[PointsAvailable] [int] NULL
)
GO
