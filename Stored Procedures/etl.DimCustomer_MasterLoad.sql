SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN


/* Eloqua */
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Broncos', @LoadView = 'etl.vw_Load_DimCustomer_Eloqua', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


/* Fanatics */
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Broncos', @LoadView = 'etl.vw_Load_DimCustomer_Fanatics', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


/*Ticketmaster*/
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Broncos', @LoadView = 'etl.vw_Load_DimCustomer_TM', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


/*FanCentric*/
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Broncos', @LoadView = 'etl.vw_LoadDimCustomer_FanCentric', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

END





GO
