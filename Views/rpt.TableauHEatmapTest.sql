SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [rpt].[TableauHEatmapTest]
as
SELECT SectionName,SectionDesc, SectionSort, RowName, RowSort, Seat from
[dbo].[FactInventory]  fi
JOIN dimseat ds ON ds.DimSeatId = fi.DimSeatID
JOIN dimseason de ON de.DimSeasonId = fi.DimSeasonId
WHERE de.SeasonName = '2016 Minnesota Vikings Season'
AND fi.DimEventId = 977
GO
