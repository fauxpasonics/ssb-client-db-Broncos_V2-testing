SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Broncos1]
AS
SELECT 
       SectionName
       , SectionSplit AS SectionDesc
       , 0 AS SectionSort
       , Replicate('0', 3 - Len(RowNAme)) + RowName as RowName
       --, CASE WHEN ISNUMERIC(Replicate('0', 10 - Len(Row)) + Row) = 1 THEN 2 ELSE 1 END AS rowsort
       , CAST(DENSE_RANK() OVER (PARTITION BY SectionName ORDER BY CASE WHEN ISNUMERIC(Replicate('0', 3 - Len(RowName)) + right(RowName,2)) = 1 THEN 2 ELSE 1 END, Replicate('0', 3 - Len(RowNAme)) + right(RowName,2)) AS INT) AS rowsort
       , CAST(Seat AS INT) as seat
FROM dbo.Broncos1
GO
