CREATE TABLE [mdm].[CompositeExclusions]
(
[ElementID] [int] NOT NULL,
[ExclusionID] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Composite__DateC__538D5813] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Composite__DateU__54817C4C] DEFAULT (getdate())
)
GO
