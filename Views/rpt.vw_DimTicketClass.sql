SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [rpt].[vw_DimTicketClass] as (select * from dbo.DimTicketClass (nolock)) 


GO
