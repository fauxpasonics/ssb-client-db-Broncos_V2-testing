CREATE TABLE [rpt].[Cust_DQI_EloquaCounts]
(
[ReportName] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClientID] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[KPIDisplayName] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NULL,
[KPIExportEnable] [int] NOT NULL,
[displayrownumber] [int] NOT NULL,
[displaycolnumber] [int] NOT NULL,
[KpiPrevLabel] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[KpiPrev] [int] NULL,
[KpiLabel2] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Kpi2] [int] NULL,
[KpiLabel3] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Kpi3] [int] NULL,
[KpiLabel4] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Kpi4] [int] NULL,
[SeasonKpiPrevLabel] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SeasonKpiPrev] [int] NULL,
[SeasonKpiLabel2] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SeasonKpi2] [int] NULL,
[SeasonKpiLabel3] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SeasonKpi3] [int] NULL,
[SeasonKpiLabel4] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SeasonKpi4] [int] NULL,
[KpiPrevThirty] [int] NULL,
[WidgetType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
