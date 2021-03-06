CREATE TABLE [dbo].[FanFactors]
(
[DimCustomerId] [int] NOT NULL,
[SourceDB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birthday] [date] NULL,
[CD_Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WaitListFlag] [int] NOT NULL,
[WaitListNum] [int] NULL,
[UpdatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[CrushMember] [int] NOT NULL,
[BunchMember] [int] NOT NULL,
[OJ] [int] NOT NULL,
[ICYMI] [int] NOT NULL,
[Last_TicketPurchase_Date] [datetime] NULL,
[DaysSince_LastTicketPurchase] [int] NULL,
[Tickets_TotalPaid] [decimal] (38, 6) NULL,
[Tickets_Totalqty] [int] NULL,
[AttendedThreeYears] [int] NULL,
[AttendedOneYear] [int] NULL,
[MaxAttended] [datetime] NULL,
[Fanatics_MaxOrderDate] [datetime] NULL,
[Fanatics_TotalSpent_30Days] [decimal] (38, 6) NULL,
[Fanatics_TotalSpent_90Days] [decimal] (38, 6) NULL,
[Fanatics_TotalSpent_Year] [decimal] (38, 6) NULL,
[Fanatics_TotalSpent_LifeTime] [decimal] (38, 6) NULL,
[EmailOpened] [int] NOT NULL,
[MostRecentOpen] [datetime] NULL,
[NumberEmailOpens] [int] NULL,
[FormSubmit] [int] NOT NULL,
[NumberFormsSubmitted] [int] NULL
)
GO
