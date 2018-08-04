SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[LoadDimCustomer_PhoneChanges_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LogLevel INT
)
AS
BEGIN


/*[etl].[LoadDimCustomer_PhoneChanges] 
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

+' IF OBJECT_ID( ''tempdb..#PhoneChanges'') IS NOT NULL DROP TABLE #PhoneChanges;' + CHAR(13)
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' CREATE TABLE #PhoneChanges(' + CHAR(13)
+'   ChangeType         NVARCHAR(50)' + CHAR(13)
+'  ,Phone_old		 nvarchar(max)' + CHAR(13)
+'   ,DirtyHash_old	Nvarchar(max)' + CHAR(13)
+'   ,IsCleanStatus_old	NVARCHAR(MAX)' + CHAR(13)
+'   , Phone_new	nvarchar(max)' + CHAR(13)
+'   ,DirtyHash_new	Nvarchar(max)' + CHAR(13)
+'   ,IsCleanStatus_new	NVARCHAR(MAX)' + CHAR(13)
+'  ,DateTimeChanged    DateTime NOT NULL' + CHAR(13)
+'  ,SSID	NVARCHAR(MAX)' + CHAR(13)
+'  ,SourceSystem NVARCHAR(MAX)' + CHAR(13)
+'  ,SourceDB NVARCHAR(MAX)' + CHAR(13)
+'  );' + CHAR(13)



/***PhonePrimary***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+'	WHEN MATCHED AND isnull(mySource.PhonePrimaryDirtyHash,-1) <> isnull(myTarget.PhonePrimaryDirtyHash, -1)' + CHAR(13)

+'	THEN UPDATE SET ' + CHAR(13)

+'		 myTarget.PhonePrimaryDirtyHash = mySource.PhonePrimaryDirtyHash' + CHAR(13)
+'		, myTarget.PhonePrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
+'		, myTarget.PhonePrimary = mySource.PhonePrimary' + CHAR(13)
		
+'		, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'		, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'		, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'		, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'		, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'	    , myTarget.UpdatedDate = GETDATE()' + CHAR(13)
	
+'	OUTPUT ''Phone Primary Updated'' AS ChangeType, deleted.PhonePrimary, ' + CHAR(13)
+'	deleted.PhonePrimaryDirtyHash, deleted.PhonePrimaryIsCleanStatus, ' + CHAR(13)
+'	inserted.PhonePrimary, ' + CHAR(13)
+'	inserted.PhonePrimaryDirtyHash, inserted.PhonePrimaryIsCleanStatus,  ' + CHAR(13) 
+'	GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB ' + CHAR(13)
+'	INTO #PhoneChanges; ' + CHAR(13)


SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Primary Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


/***PhoneHome***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+'	WHEN MATCHED AND isnull(mySource.PhoneHomeDirtyHash,-1) <> isnull(myTarget.PhoneHomeDirtyHash, -1)' + CHAR(13)

+'	THEN UPDATE SET ' + CHAR(13)

+'		 myTarget.PhoneHomeDirtyHash = mySource.PhoneHomeDirtyHash' + CHAR(13)
+'		, myTarget.PhoneHomeIsCleanStatus = ''Dirty''' + CHAR(13)
+'		, myTarget.PhoneHome = mySource.PhoneHome' + CHAR(13)
		
+'		, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'		, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'		, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'		, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'		, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'	    , myTarget.UpdatedDate = GETDATE()' + CHAR(13)
	
+'	OUTPUT ''Phone Home Updated'' AS ChangeType, deleted.PhoneHome, ' + CHAR(13)
+'	deleted.PhoneHomeDirtyHash, deleted.PhoneHomeIsCleanStatus, ' + CHAR(13)
+'	inserted.PhoneHome, ' + CHAR(13)
+'	inserted.PhoneHomeDirtyHash, inserted.PhoneHomeIsCleanStatus,  ' + CHAR(13) 
+'	GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB ' + CHAR(13)
+'	INTO #PhoneChanges; ' + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Home Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


/***PhoneCell***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+'	WHEN MATCHED AND isnull(mySource.PhoneCellDirtyHash,-1) <> isnull(myTarget.PhoneCellDirtyHash, -1)' + CHAR(13)

+'	THEN UPDATE SET ' + CHAR(13)

+'		 myTarget.PhoneCellDirtyHash = mySource.PhoneCellDirtyHash' + CHAR(13)
+'		, myTarget.PhoneCellIsCleanStatus = ''Dirty''' + CHAR(13)
+'		, myTarget.PhoneCell = mySource.PhoneCell' + CHAR(13)
		
+'		, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'		, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'		, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'		, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'		, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'	    , myTarget.UpdatedDate = GETDATE()' + CHAR(13)
	
+'	OUTPUT ''Phone Cell Updated'' AS ChangeType, deleted.PhoneCell, ' + CHAR(13)
+'	deleted.PhoneCellDirtyHash, deleted.PhoneCellIsCleanStatus, ' + CHAR(13)
+'	inserted.PhoneCell, ' + CHAR(13)
+'	inserted.PhoneCellDirtyHash, inserted.PhoneCellIsCleanStatus,  ' + CHAR(13) 
+'	GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB ' + CHAR(13)
+'	INTO #PhoneChanges; ' + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Cell Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)



/***PhoneBusiness***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+'	WHEN MATCHED AND isnull(mySource.PhoneBusinessDirtyHash,-1) <> isnull(myTarget.PhoneBusinessDirtyHash, -1)' + CHAR(13)

+'	THEN UPDATE SET ' + CHAR(13)

+'		 myTarget.PhoneBusinessDirtyHash = mySource.PhoneBusinessDirtyHash' + CHAR(13)
+'		, myTarget.PhoneBusinessIsCleanStatus = ''Dirty''' + CHAR(13)
+'		, myTarget.PhoneBusiness = mySource.PhoneBusiness' + CHAR(13)
		
+'		, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'		, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'		, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'		, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'		, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'	    , myTarget.UpdatedDate = GETDATE()' + CHAR(13)
	
+'	OUTPUT ''Phone Business Updated'' AS ChangeType, deleted.PhoneBusiness, ' + CHAR(13)
+'	deleted.PhoneBusinessDirtyHash, deleted.PhoneBusinessIsCleanStatus, ' + CHAR(13)
+'	inserted.PhoneBusiness, ' + CHAR(13)
+'	inserted.PhoneBusinessDirtyHash, inserted.PhoneBusinessIsCleanStatus,  ' + CHAR(13) 
+'	GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB ' + CHAR(13)
+'	INTO #PhoneChanges; ' + CHAR(13)



SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Business Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)



/***PhoneFax***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+'	WHEN MATCHED AND isnull(mySource.PhoneFaxDirtyHash,-1) <> isnull(myTarget.PhoneFaxDirtyHash, -1)' + CHAR(13)

+'	THEN UPDATE SET ' + CHAR(13)

+'		 myTarget.PhoneFaxDirtyHash = mySource.PhoneFaxDirtyHash' + CHAR(13)
+'		, myTarget.PhoneFaxIsCleanStatus = ''Dirty''' + CHAR(13)
+'		, myTarget.PhoneFax = mySource.PhoneFax' + CHAR(13)
		
+'		, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'		, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'		, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'		, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'		, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'	    , myTarget.UpdatedDate = GETDATE()' + CHAR(13)
	
+'	OUTPUT ''Phone Fax Updated'' AS ChangeType, deleted.PhoneFax, ' + CHAR(13)
+'	deleted.PhoneFaxDirtyHash, deleted.PhoneFaxIsCleanStatus, ' + CHAR(13)
+'	inserted.PhoneFax, ' + CHAR(13)
+'	inserted.PhoneFaxDirtyHash, inserted.PhoneFaxIsCleanStatus,  ' + CHAR(13) 
+'	GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB ' + CHAR(13)
+'	INTO #PhoneChanges; ' + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Fax Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


/***PhoneOther***/
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+'	WHEN MATCHED AND isnull(mySource.PhoneOtherDirtyHash,-1) <> isnull(myTarget.PhoneOtherDirtyHash, -1)' + CHAR(13)

+'	THEN UPDATE SET ' + CHAR(13)

+'		 myTarget.PhoneOtherDirtyHash = mySource.PhoneOtherDirtyHash' + CHAR(13)
+'		, myTarget.PhoneOtherIsCleanStatus = ''Dirty''' + CHAR(13)
+'		, myTarget.PhoneOther = mySource.PhoneOther' + CHAR(13)
		
+'		, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'		, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'		, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'		, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'		, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'	    , myTarget.UpdatedDate = GETDATE()' + CHAR(13)
	
+'	OUTPUT ''Phone Other Updated'' AS ChangeType, deleted.PhoneOther, ' + CHAR(13)
+'	deleted.PhoneOtherDirtyHash, deleted.PhoneOtherIsCleanStatus, ' + CHAR(13)
+'	inserted.PhoneOther, ' + CHAR(13)
+'	inserted.PhoneOtherDirtyHash, inserted.PhoneOtherIsCleanStatus,  ' + CHAR(13) 
+'	GETDATE(), mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB ' + CHAR(13)
+'	INTO #PhoneChanges; ' + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Other Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)



IF @LogLevel = 2
BEGIN 
SET @sql = @sql
+' INSERT INTO ' + @ClientDB  +'.audit.ChangeLogDetail ' + CHAR(13)
+' SELECT ''Dimcustomer'', ChangeType, ''Data Load'', DateTimeChanged, ' + CHAR(13)
+' dbo.fnStripLowAscii(Replace((SELECT SSID, SourceSystem, SourceDB, phone_old, dirtyhash_old, iscleanstatus_old FROM #Phonechanges as Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem and changetype = a.changetype FOR XML AUTO, Elements XSINIL), ''&'', ''&amp;'')) AS Old, ' + CHAR(13)
+' dbo.fnStripLowAscii(Replace((SELECT SSID, SourceSystem, SourceDB, Phone_new, dirtyhash_new, iscleanstatus_new FROM #phonechanges as Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem and changetype = a.changetype FOR XML AUTO, Elements XSINIL), ''&'', ''&amp;'')) AS New ' + CHAR(13)
+' FROM #PhoneChanges a; ' + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Phone Change Details'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


END

SET @sql = @sql + CHAR(13) + CHAR(13)	

EXEC sp_executesql @sql;

END


GO
