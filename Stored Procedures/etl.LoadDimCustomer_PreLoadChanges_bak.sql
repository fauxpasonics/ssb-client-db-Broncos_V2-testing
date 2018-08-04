SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[LoadDimCustomer_PreLoadChanges_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LoadGuid VARCHAR(50),
	@LogLevel INT
)
AS
BEGIN


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

DECLARE @LoadGuid VARCHAR(50) = REPLACE(NEWID(), '-', '');
*/

 IF (SELECT @@VERSION) LIKE '%Azure%'
BEGIN
SET @ClientDB = ''
END

IF (SELECT @@VERSION) NOT LIKE '%Azure%'
BEGIN
SET @ClientDB = @ClientDB + '.'
END

DECLARE 
	@sql NVARCHAR(MAX) = '  '


/*Get Changing SSIDs*/
IF @loglevel > 0 
BEGIN
SET @sql = @sql 
+' SELECT b.*' + CHAR(13)
+' INTO ' + @ClientDB + 'etl.tmp_changes_' + @LoadGuid + CHAR(13)
+' FROM ' + @LoadView  + ' a ' + CHAR(13)
+' INNER JOIN ' + @ClientDB + 'dbo.dimcustomer b ' + CHAR(13)
+' ON a.ssid = b.SSID ' + CHAR(13)
+' AND a.sourcesystem = b.SourceSystem ' + CHAR(13)
+' AND a.sourcedb = b.sourcedb; ' + CHAR(13)


SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Get Change IDs'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
+' Alter table ' + @ClientDB + 'etl.tmp_changes_' + @LoadGuid + ' Add constraint pk_dimcust_' + @LoadGuid + ' Primary Key Clustered (dimcustomerid); '+ CHAR(13)
END

EXEC sp_executesql @sql;
END



GO
