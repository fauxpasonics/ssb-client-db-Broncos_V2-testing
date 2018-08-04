SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Create basic stored procedure template
-- =============================================


CREATE PROCEDURE [etl].[source_load_audit]
AS -- =============================================
-- Create MDM Temp Table
-- =============================================

    SELECT  dc.SourceSystem
          , MAX(dc.CreatedDate) AS CreatedDate
          , MAX(dc.UpdatedDate) AS UpdatedDate
    INTO    #Temp
    FROM    dbo.DimCustomer AS dc
    GROUP BY dc.SourceSystem;

-- =============================================
-- Source System Merge
-- =============================================

-- =============================================
-- Eloqua
-- =============================================

    MERGE dbo.source_load_audit AS TARGET
    USING
        (
          SELECT    'Broncos' AS Client
                  , 'Eloqua Broncos' AS SourceSystem
                  , 'Eloqua_ActivityBounceBack' AS SS_Table
                  , MAX(eab.ETL_CreatedDate) AS ETL_CreatedDate
                  , MAX(eab.ETL_UpdatedDate) AS ETL_UpdatedDate
                  , MAX(dc.CreatedDate) AS MDM_CreatedDate
                  , MAX(dc.UpdatedDate) AS MDM_UpdatedDate
          FROM      ods.Eloqua_ActivityBounceBack eab
                    LEFT JOIN #Temp AS dc ON dc.SourceSystem = 'Eloqua Broncos'
        ) AS Source
    ON ( TARGET.SS_Table = Source.SS_Table )
    WHEN MATCHED THEN
        UPDATE SET
               TARGET.ETL_CreatedDate = Source.ETL_CreatedDate
             , TARGET.ETL_UpdatedDate = Source.ETL_UpdatedDate
             , TARGET.MDM_CraetedDate = Source.MDM_CreatedDate
             , TARGET.MDM_UpdatedDate = Source.MDM_UpdatedDate
    WHEN NOT MATCHED THEN
        INSERT (
                 Client
               , SourceSystem
               , SS_Table
               , ETL_CreatedDate
               , ETL_UpdatedDate
               , MDM_CraetedDate
               , MDM_UpdatedDate
               )
        VALUES (
                 Source.Client
               , Source.SourceSystem
               , Source.SS_Table
               , Source.ETL_CreatedDate
               , Source.ETL_UpdatedDate
               , Source.MDM_CreatedDate
               , Source.MDM_UpdatedDate
               );

-- =============================================
-- TM
-- =============================================

    MERGE dbo.source_load_audit AS TARGET
    USING
        (
          SELECT    'Broncos' AS Client
                  , 'TM' AS SourceSystem
                  , 'TM_Cust' AS SS_Table
                  , MAX(tc.InsertDate) AS ETL_CreatedDate
                  , MAX(tc.UpdateDate) AS ETL_UpdatedDate
                  , MAX(dc.CreatedDate) AS MDM_CreatedDate
                  , MAX(dc.UpdatedDate) AS MDM_UpdatedDate
          FROM      ods.TM_Cust AS tc
                    LEFT JOIN #Temp AS dc ON dc.SourceSystem = 'TM'
        ) AS Source
    ON ( TARGET.SS_Table = Source.SS_Table )
    WHEN MATCHED THEN
        UPDATE SET
               TARGET.ETL_CreatedDate = Source.ETL_CreatedDate
             , TARGET.ETL_UpdatedDate = Source.ETL_UpdatedDate
             , TARGET.MDM_CraetedDate = Source.MDM_CreatedDate
             , TARGET.MDM_UpdatedDate = Source.MDM_UpdatedDate
    WHEN NOT MATCHED THEN
        INSERT (
                 Client
               , SourceSystem
               , SS_Table
               , ETL_CreatedDate
               , ETL_UpdatedDate
               , MDM_CraetedDate
               , MDM_UpdatedDate
               )
        VALUES (
                 Source.Client
               , Source.SourceSystem
               , Source.SS_Table
               , Source.ETL_CreatedDate
               , Source.ETL_UpdatedDate
               , Source.MDM_CreatedDate
               , Source.MDM_UpdatedDate
               );

-- =============================================
-- Fanatics
-- =============================================

    MERGE dbo.source_load_audit AS TARGET
    USING
        (
          SELECT    'Broncos' AS Client
                  , 'Fanatics' AS SourceSystem
                  , 'Fanatics_Orders' AS SS_Table
                  , MAX(fo.ETL_CreatedDate) AS ETL_CreatedDate
                  , MAX(fo.ETL_UpdatedDate) AS ETL_UpdatedDate
                  , MAX(dc.CreatedDate) AS MDM_CreatedDate
                  , MAX(dc.UpdatedDate) AS MDM_UpdatedDate
          FROM      ods.Fanatics_Orders AS fo
                    LEFT JOIN #Temp AS dc ON dc.SourceSystem = 'Fanatics'
        ) AS Source
    ON ( TARGET.SS_Table = Source.SS_Table )
    WHEN MATCHED THEN
        UPDATE SET
               TARGET.ETL_CreatedDate = Source.ETL_CreatedDate
             , TARGET.ETL_UpdatedDate = Source.ETL_UpdatedDate
             , TARGET.MDM_CraetedDate = Source.MDM_CreatedDate
             , TARGET.MDM_UpdatedDate = Source.MDM_UpdatedDate
    WHEN NOT MATCHED THEN
        INSERT (
                 Client
               , SourceSystem
               , SS_Table
               , ETL_CreatedDate
               , ETL_UpdatedDate
               , MDM_CraetedDate
               , MDM_UpdatedDate
               )
        VALUES (
                 Source.Client
               , Source.SourceSystem
               , Source.SS_Table
               , Source.ETL_CreatedDate
               , Source.ETL_UpdatedDate
               , Source.MDM_CreatedDate
               , Source.MDM_UpdatedDate
               );

DROP TABLE #Temp

GO
