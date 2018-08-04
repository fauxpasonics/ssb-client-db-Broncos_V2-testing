SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[Fanatics_LoadDimCustomer]
AS
    BEGIN


-- select 1
-- Source 1 (eg.CRM_Account)
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Broncos', @LoadView = 'ods.vw_Fanatics_LoadDimCustomer', @LogLevel = '1', @DropTemp = '0', @IsDataUploaderSource = '0'

    END;





GO
