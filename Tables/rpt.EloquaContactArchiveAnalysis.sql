CREATE TABLE [rpt].[EloquaContactArchiveAnalysis]
(
[Email] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STH] [numeric] (18, 0) NULL,
[OJSub] [numeric] (18, 0) NULL,
[ICYMISub] [numeric] (18, 0) NULL,
[BroncosPromosSub] [numeric] (18, 0) NULL,
[SurveyPanelSub] [numeric] (18, 0) NULL,
[BroncosBunchSub] [numeric] (18, 0) NULL,
[CrushMembersSub] [numeric] (18, 0) NULL,
[OpenedEmailIn2015] [numeric] (18, 0) NULL,
[HaveNotOpenedEmail24Months] [numeric] (18, 0) NULL,
[SentEmailInLast12Months] [numeric] (18, 0) NULL,
[SkiData] [numeric] (18, 0) NULL,
[HasStorePurchaseHistory] [numeric] (18, 0) NULL,
[HardBouceBackinContact] [numeric] (18, 0) NULL,
[GlobalUnsubscribe] [numeric] (18, 0) NULL,
[OrangeHerdSub] [numeric] (18, 0) NULL,
[OpenedEmailWithin1Month] [numeric] (18, 0) NULL
)
GO
