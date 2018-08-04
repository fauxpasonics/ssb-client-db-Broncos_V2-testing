CREATE TABLE [mdm].[SourceSystemPriority]
(
[ElementID] [int] NOT NULL,
[SourceSystemID] [int] NOT NULL,
[SourceSystemPriority] [int] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__SourceSys__DateC__3B75D760] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__SourceSys__DateU__3C69FB99] DEFAULT (getdate())
)
GO
