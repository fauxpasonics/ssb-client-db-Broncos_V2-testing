SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[LoadDimCustomer_EmailChanges_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LogLevel INT
)
AS
BEGIN


/*[etl].[LoadDimCustomer_EmailChanges] 
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
+' IF OBJECT_ID( ''tempdb..#EmailChanges'') IS NOT NULL DROP TABLE #EmailChanges;' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' CREATE TABLE #EmailChanges(' + CHAR(13)
+'  ChangeType         NVARCHAR(50)' + CHAR(13)
+'  ,Email_old		 nvarchar(max)' + CHAR(13)
+'  ,DirtyHash_old	Nvarchar(max)' + CHAR(13)
+'  ,IsCleanStatus_old	NVARCHAR(MAX)' + CHAR(13)
+'  , Email_new	nvarchar(max)' + CHAR(13)
+'  ,DirtyHash_new	Nvarchar(max)' + CHAR(13)
+'  ,IsCleanStatus_new	NVARCHAR(MAX)' + CHAR(13)
+' ,DateTimeChanged    DateTime NOT NULL' + CHAR(13)
+' ,SSID	NVARCHAR(MAX)' + CHAR(13)
+' ,SourceSystem NVARCHAR(MAX)' + CHAR(13)
+' ,SourceDB NVARCHAR(MAX)' + CHAR(13)
+' );' + CHAR(13)



/***EmailPrimary***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.EmailPrimaryDirtyHash,-1) <> isnull(myTarget.EmailPrimaryDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+'	 myTarget.EmailPrimaryDirtyHash = mySource.EmailPrimaryDirtyHash' + CHAR(13)
+'	, myTarget.EmailPrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
+'	, myTarget.EmailPrimary = mySource.EmailPrimary	' + CHAR(13)
+'	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'    , myTarget.UpdatedDate = CURRENT_TIMESTAMP' + CHAR(13)

+' OUTPUT ''Email Primary Updated'' AS ChangeType, deleted.EmailPrimary,' + CHAR(13)
+' deleted.EmailPrimaryDirtyHash, deleted.EmailPrimaryIsCleanStatus,' + CHAR(13)
+' inserted.EmailPrimary,' + CHAR(13)
+' inserted.EmailPrimaryDirtyHash, inserted.EmailPrimaryIsCleanStatus, ' + CHAR(13) 
+' GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #EmailChanges;' + CHAR(13)



SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Email Primary Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/***EmailOne***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.EmailOneDirtyHash,-1) <> isnull(myTarget.EmailOneDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+'	 myTarget.EmailOneDirtyHash = mySource.EmailOneDirtyHash' + CHAR(13)
+'	, myTarget.EmailOneIsCleanStatus = ''Dirty''' + CHAR(13)
+'	, myTarget.EmailOne = mySource.EmailOne	' + CHAR(13)
+'	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'    , myTarget.UpdatedDate = CURRENT_TIMESTAMP' + CHAR(13)

+' OUTPUT ''Email One Updated'' AS ChangeType, deleted.EmailOne,' + CHAR(13)
+' deleted.EmailOneDirtyHash, deleted.EmailOneIsCleanStatus,' + CHAR(13)
+' inserted.EmailOne,' + CHAR(13)
+' inserted.EmailOneDirtyHash, inserted.EmailOneIsCleanStatus, ' + CHAR(13) 
+' GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #EmailChanges;' + CHAR(13)


SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Email One Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/***EmailTwo***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.EmailTwoDirtyHash,-1) <> isnull(myTarget.EmailTwoDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+'	 myTarget.EmailTwoDirtyHash = mySource.EmailTwoDirtyHash' + CHAR(13)
+'	, myTarget.EmailTwoIsCleanStatus = ''Dirty''' + CHAR(13)
+'	, myTarget.EmailTwo = mySource.EmailTwo	' + CHAR(13)
+'	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'    , myTarget.UpdatedDate = CURRENT_TIMESTAMP' + CHAR(13)

+' OUTPUT ''Email Two Updated'' AS ChangeType, deleted.EmailTwo,' + CHAR(13)
+' deleted.EmailTwoDirtyHash, deleted.EmailTwoIsCleanStatus,' + CHAR(13)
+' inserted.EmailTwo,' + CHAR(13)
+' inserted.EmailTwoDirtyHash, inserted.EmailTwoIsCleanStatus, ' + CHAR(13) 
+' GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #EmailChanges;' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	


SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Email Two Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

IF @LogLevel = 2
BEGIN
SET @sql = @sql

+' INSERT INTO  ' +  @clientdb +'.audit.ChangeLogDetail ' + CHAR(13)
+' SELECT ''Dimcustomer'', ChangeType, ''Data Load'', DateTimeChanged, ' + CHAR(13)
+' ssb_mdm.dbo.fnStripLowAscii(Replace((SELECT SSID, SourceSystem, SourceDB, email_old, dirtyhash_old, iscleanstatus_old FROM #emailchanges AS Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem and changetype = a.changetype FOR XML AUTO, Elements XSINIL), ''&'', ''&amp;'')) AS Old, ' + CHAR(13)
+' ssb_mdm.dbo.fnStripLowAscii(Replace((SELECT SSID, SourceSystem, SourceDB, email_new, dirtyhash_new, iscleanstatus_new FROM #emailchanges AS Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem and changetype = a.changetype FOR XML AUTO, Elements XSINIL), ''&'', ''&amp;'')) AS New ' + CHAR(13)
+' FROM #EmailChanges a;' + CHAR(13)


SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Email Change Detail'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

END

SET @sql = @sql + CHAR(13) + CHAR(13)	

EXEC sp_executesql @sql;

END


GO
