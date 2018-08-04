CREATE TABLE [dbo].[FanFactors_StandardizedScoresOutput]
(
[DimCustomerID] [int] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressPrimary_Colorado_Flag] [int] NULL,
[Tickets_DaysSince_LastPurchase] [float] NULL,
[Tickets_TotalPaid] [float] NULL,
[Merch_TotalSpent_LifeTime] [float] NULL,
[Merch_TotalSpent_Year] [float] NULL,
[WaitList_Flag] [int] NULL,
[CrushMember_Flag] [int] NULL,
[BunchMember_Flag] [int] NOT NULL,
[Fantasy] [int] NULL,
[Sunday_ticket] [int] NULL,
[Pickem] [int] NULL,
[ICYMI] [int] NULL,
[Promos] [int] NULL,
[OJ] [int] NULL,
[Email_Open_Qty] [float] NULL,
[Form_Submit_Qty] [float] NULL,
[NonGameEvents_Total] [float] NULL,
[ContestsEntered_Total] [float] NULL,
[EmailGroup_Membeerships_total] [float] NULL,
[Tickets_Attendance_One_Year] [float] NULL,
[EmailGroup_OrangeHerd] [int] NULL
)
GO
