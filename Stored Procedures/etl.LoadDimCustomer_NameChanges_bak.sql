SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [etl].[LoadDimCustomer_NameChanges_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LogLevel INT
)
AS
BEGIN


/*[etl].[LoadDimCustomer_NameChanges] 
* created: 7/2/2015 - Kwyss - dynamic sql procedure to load data to dimcustomer.   Pass in client db name and view to load from.
* Log Levels - 0 = none; 1 = record; 2 = detail
*
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
	@sql NVARCHAR(MAX) = ' '

SET @sql = @sql 

+' IF OBJECT_ID( ''tempdb..#CustomerChanges'') IS NOT NULL DROP TABLE #CustomerChanges; ' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql

+' CREATE TABLE #CustomerChanges( ' + CHAR(13)
+'  ChangeType         NVARCHAR(50)' + CHAR(13)
+'  ,Prefix_old		 nvarchar(max)' + CHAR(13)
+'  ,FirstName_old	NVARCHAR(MAX)' + CHAR(13)
+'  ,MiddleName_old	NVARCHAR(MAX)' + CHAR(13)
+'  ,LastName_old	NVARCHAR(MAX)' + CHAR(13)
+'  ,Suffix_old		NVARCHAR(Max)' + CHAR(13)
+'  ,NameDirtyHash_old	Nvarchar(max)' + CHAR(13)
+'  ,NameIsCleanStatus_old	NVARCHAR(MAX)' + CHAR(13)
+'   ,Prefix_new		 nvarchar(max)' + CHAR(13)
+'  ,FirstName_new	NVARCHAR(MAX)' + CHAR(13)
+'  ,MiddleName_new	NVARCHAR(MAX)' + CHAR(13)
+'  ,LastName_new	NVARCHAR(MAX)' + CHAR(13)
+'  ,Suffix_new		NVARCHAR(Max)' + CHAR(13)
+'  ,NameDirtyHash_new	Nvarchar(max)' + CHAR(13)
+'  ,NameIsCleanStatus_new	NVARCHAR(MAX)' + CHAR(13)
+' ,DateTimeChanged    DateTime NOT NULL' + CHAR(13)
+' ,SSID	NVARCHAR(MAX)' + CHAR(13)
+' ,SourceSystem NVARCHAR(MAX)' + CHAR(13)
+' ,SourceDB NVARCHAR(MAX)' + CHAR(13)
+' );' + CHAR(13)

/***Name***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.NameDirtyHash,-1) <> isnull(myTarget.NameDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+' 	 myTarget.Prefix = mySource.Prefix' + CHAR(13)
+' 	, myTarget.FirstName = mySource.FirstName' + CHAR(13)
+' 	, myTarget.MiddleName = mySource.MiddleName' + CHAR(13)
+' 	, myTarget.LastName = mySource.LastName' + CHAR(13)
+' 	, myTarget.Suffix = mySource.Suffix' + CHAR(13)
+' 	, myTarget.NameDirtyHash = mySource.NameDirtyHash' + CHAR(13)
+' 	, myTarget.NameIsCleanStatus = ''Dirty''' + CHAR(13)
	
+' 	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+' 	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+' 	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+' 	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+' 	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'  , myTarget.UpdatedDate = current_timestamp ' + CHAR(13)


+' OUTPUT ''Name Updated'' AS ChangeType, deleted.prefix, deleted.FirstName, Deleted.Middlename, Deleted.LastName, Deleted.Suffix, ' + CHAR(13)
+' Deleted.NameDirtyHash, Deleted.NameIsCleanStatus, inserted.prefix, Inserted.FirstName, Inserted.Middlename, Inserted.LastName, Inserted.Suffix, ' + CHAR(13)
+' Inserted.NameDirtyHash, Inserted.NameIsCleanStatus, current_timestamp, mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #CustomerChanges;' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Name Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

IF @LogLevel = 2
BEGIN
SET @sql = @sql
+' INSERT INTO  ' + @ClientDB  +'audit.ChangeLogDetail ' + CHAR(13)
+' SELECT ''Dimcustomer'', ChangeType, ''Data Load'', DateTimeChanged,  ' + CHAR(13)
+' ssb_mdm.dbo.fnStripLowAscii(replace((SELECT SSID, SourceSystem, SourceDB, prefix_old, firstname_old, middlename_old, lastname_old, suffix_old, namedirtyhash_old, nameiscleanstatus_old FROM #customerchanges As Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem FOR XML AUTO, ELEMENTS XSINIL), ''&'', ''&amp;'')) AS Old,  ' + CHAR(13)
+' ssb_mdm.dbo.fnStripLowAscii(replace((SELECT SSID, SourceSystem, SourceDB, prefix_new, firstname_new, middlename_new, lastname_new, suffix_new, namedirtyhash_new, nameiscleanstatus_new FROM #customerchanges as Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem FOR XML AUTO, ELEMENTS XSINIL), ''&'', ''&amp;'')) AS New  ' + CHAR(13)
+' FROM #CustomerChanges a  ' + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Name Change Detail'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

END



EXEC sp_executesql @sql;

END



GO
