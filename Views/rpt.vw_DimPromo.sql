SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [rpt].[vw_DimPromo] as (select * from dbo.DimPromo (nolock)) 


GO
