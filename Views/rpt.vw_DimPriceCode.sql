SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [rpt].[vw_DimPriceCode] as (select * from dbo.DimPriceCode (nolock)) 


GO
