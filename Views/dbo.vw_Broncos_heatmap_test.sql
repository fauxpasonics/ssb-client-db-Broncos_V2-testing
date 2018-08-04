SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Broncos_heatmap_test]
AS
SELECT
        CASE
        WHEN ds.sectionname IN ('100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135')
            AND ds.Rowname IN ('A1', 'W1', 'A21', 'W21', '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21')
        THEN sectionname + '--Lower'
        ELSE sectionname
        END SectionName
       , '' AS SectionDesc
       , 0 AS SectionSort
       --, Replicate('0', 10 - Len(Row)) + Row as RowName
       --, CASE WHEN ISNUMERIC(Replicate('0', 10 - Len(Row)) + Row) = 1 THEN 2 ELSE 1 END AS rowsort
       , CAST(DENSE_RANK() OVER (PARTITION BY ds.sectionname ORDER BY CASE
                                      WHEN ds.rowname IN ('W1', 'A1') THEN 1
                                      WHEN LEN(RTRIM(ds.rowname)) = '1' THEN 2
                        WHEN LEN(RTRIM(ds.rowname)) = 2 AND ds.[rowname] NOT IN ('W1', 'A1') THEN 3
                                         WHEN LEN(RTRIM(ds.rowname)) = '3' THEN 4
                        ELSE 5
                        END
            ) AS INT) AS rowsort
       , CAST(ds.Seat AS INT) AS Seat
FROM dbo.dimseat ds
INNER JOIN dbo.dimseason dsn ON ds.ManifestId = dsn.ManifestId
WHERE dsn.seasonname = 'Broncos Football - 2017'

GO
