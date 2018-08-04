SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[LoadDimCustomer_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LogLevel varchar(100)
)
AS
BEGIN

--EXEC etl.loadDimCustomer 'Broncos','[etl].[vw_Eloqua_Load_DimCustomer]',1
--EXEC etl.loadDimCustomer 'Broncos','[ods].[vw_TM_LoadDimCustomer]',1

/*[etl].[LoadDimCustomer] 
* created: 7/2/2015 - Kwyss - dynamic sql procedure to load data to dimcustomer.   Pass in client db name and view to load from.
* Log Levels - 0 = none; 1 = record; 2 = detail
*
*/
/*
DECLARE @LoadView VARCHAR(100)
DECLARE @ClientDB VARCHAR(50)

SET @LoadView  = 'psp.etl.vw_TI_LoadDimCustomer_Sixers'
SET @clientdb = 'psp'

*/

DECLARE @LoadGuid VARCHAR(50) = REPLACE(NEWID(), '-', '');

DECLARE 
	@sql NVARCHAR(MAX) = '  '



SET @sql = @sql
+ ' PRINT '' PreLoad Changes '''
+ 'EXEC etl.LoadDimCustomer_PreLoadChanges @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LoadGuid = ''' + @LoadGuid + ''', @LogLevel = ' + @LogLevel + CHAR(13)
+ ' PRINT '' NameChanges '''
+ 'EXEC etl.LoadDimCustomer_NameChanges @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LogLevel = ' + @LogLevel + CHAR(13)
+ ' PRINT '' Address Changes '''
+ 'EXEC etl.LoadDimCustomer_AddressChanges @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LogLevel = ' + @LogLevel + CHAR(13)
+ ' PRINT '' Phone Changes '''
+ 'EXEC etl.LoadDimCustomer_PhoneChanges @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LogLevel = ' + @LogLevel + CHAR(13)
+ ' PRINT '' Email Changes '''
+ 'EXEC etl.LoadDimCustomer_EmailChanges @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LogLevel = ' + @LogLevel + CHAR(13)
+ ' PRINT '' Attribute Changes '''
+ 'EXEC etl.LoadDimCustomer_AttributeChanges @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LogLevel = ' + @LogLevel + CHAR(13)
+ ' PRINT '' Load New '''
+ 'EXEC etl.LoadDimCustomer_LoadNew @clientdb = ''' + @ClientDB + ''',  @loadview =''' + @LoadView + ''', @LoadGuid = ''' + @LoadGuid + '''' + CHAR(13)
+ ' PRINT '' Change Log '''
+ 'EXEC etl.LoadDimCustomer_ChangeLog @clientdb = ''' + @ClientDB + ''', @LoadGuid = ''' + @LoadGuid + ''',  @LogLevel = ' + @LogLevel  + CHAR(13)


EXEC sp_executesql @sql;

END






GO
