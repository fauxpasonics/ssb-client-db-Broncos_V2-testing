SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [etl].[LoadDimCustomer_AddressChanges_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LogLevel INT
)
AS
BEGIN


/*[etl].[LoadDimCustomer_AddressChanges] 
* created: 7/2/2015 - Kwyss - dynamic sql procedure to load data to dimcustomer.   Pass in client db name and view to load from.
*
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

+' IF OBJECT_ID( ''tempdb..#AddressChanges'') IS NOT NULL DROP TABLE #AddressChanges;' + CHAR(13)
 
 SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
+' CREATE TABLE #AddressChanges('+ CHAR(13)
+'   ChangeType         NVARCHAR(50)'+ CHAR(13)
+'   ,Street_old		 nvarchar(max)'+ CHAR(13)
+'   ,City_old	nvarchar(max)'+ CHAR(13)
+'   ,state_old	nvarchar(max)'+ CHAR(13)
+'   , zip_old	nvarchar(max)'+ CHAR(13)
+'   , County_old	nvarchar(max)'+ CHAR(13)
+'   , Country_old	nvarchar(max)'+ CHAR(13)
+'   ,DirtyHash_old	Nvarchar(max)'+ CHAR(13)
+'   ,IsCleanStatus_old	NVARCHAR(MAX)'+ CHAR(13)
+'   , street_new	nvarchar(max)'+ CHAR(13)
+'   , city_new	nvarchar(max)'+ CHAR(13)
+'   , State_new	nvarchar(max)'+ CHAR(13)
+'   , zip_new	nvarchar(max)'+ CHAR(13)
+'   , county_new	nvarchar(max)'+ CHAR(13)
+'   , country_new	nvarchar(max)'+ CHAR(13)
+'  ,DirtyHash_new	Nvarchar(max)'+ CHAR(13)
+'  ,IsCleanStatus_new	NVARCHAR(MAX)'+ CHAR(13)
+'  ,DateTimeChanged    DateTime NOT NULL'+ CHAR(13)
+'  ,SSID	NVARCHAR(MAX)'+ CHAR(13)
+'  ,SourceSystem NVARCHAR(MAX)'+ CHAR(13)
+'  ,SourceDB NVARCHAR(MAX)'+ CHAR(13)
+'  );'+ CHAR(13)


/***AddressPrimary***/
SET @sql = @sql + CHAR(13) + CHAR(13)	
SET @sql = @sql

+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.AddressPrimaryDirtyHash,-1) <> isnull(myTarget.AddressPrimaryDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+' 	 myTarget.AddressPrimaryDirtyHash = mySource.AddressPrimaryDirtyHash' + CHAR(13)
+' 	, myTarget.AddressPrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
+' 	, myTarget.AddressPrimaryStreet = mySource.AddressPrimaryStreet' + CHAR(13)
+' 	, myTarget.AddressPrimaryCity = mySource.AddressPrimaryCity' + CHAR(13)
+' 	, myTarget.AddressPrimaryState = mySource.AddressPrimaryState' + CHAR(13)
+' 	, myTarget.AddressPrimaryZip = mySource.AddressPrimaryZip' + CHAR(13)
+' 	, myTarget.AddressPrimaryCounty = mySource.AddressPrimaryCounty' + CHAR(13)
+' 	, myTarget.AddressPrimaryCountry = mySource.AddressPrimaryCountry' + CHAR(13)

+' 	, myTarget.ContactDirtyHash = mySource.ContactDirtyHash' + CHAR(13)
	--, myTarget.ContactGUID = mySource.ContactGUID
		
+' 	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+' 	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+' 	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+' 	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+' 	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'     , myTarget.UpdatedDate = current_timestamp' + CHAR(13)

+' OUTPUT ''Primary Address Updated'' AS ChangeType, deleted.AddressPrimaryStreet, deleted.AddressPrimaryCity,' + CHAR(13)
+' deleted.AddressPrimaryState, deleted.AddressPrimaryZip, deleted.AddressPrimaryCounty, deleted.AddressPrimaryCountry,' + CHAR(13)
+' deleted.AddressPrimaryDirtyHash, deleted.AddressPrimaryIsCleanStatus,' + CHAR(13)
+' inserted.AddressPrimaryStreet, inserted.AddressPrimaryCity,' + CHAR(13)
+' inserted.AddressPrimaryState, inserted.AddressPrimaryZip, inserted.AddressPrimaryCounty, inserted.AddressPrimaryCountry,' + CHAR(13)
+' inserted.AddressPrimaryDirtyHash, inserted.AddressPrimaryIsCleanStatus,  ' + CHAR(13)
+' current_timestamp, mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #AddressChanges; ' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Address Primary Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


/***AddressOne***/
SET @sql = @sql + CHAR(13) + CHAR(13)	
SET @sql = @sql

+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.AddressOneDirtyHash,-1) <> isnull(myTarget.AddressOneDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+' 	 myTarget.AddressOneDirtyHash = mySource.AddressOneDirtyHash' + CHAR(13)
+' 	, myTarget.AddressOneIsCleanStatus = ''Dirty''' + CHAR(13)
+' 	, myTarget.AddressOneStreet = mySource.AddressOneStreet' + CHAR(13)
+' 	, myTarget.AddressOneCity = mySource.AddressOneCity' + CHAR(13)
+' 	, myTarget.AddressOneState = mySource.AddressOneState' + CHAR(13)
+' 	, myTarget.AddressOneZip = mySource.AddressOneZip' + CHAR(13)
+' 	, myTarget.AddressOneCounty = mySource.AddressOneCounty' + CHAR(13)
+' 	, myTarget.AddressOneCountry = mySource.AddressOneCountry' + CHAR(13)
		
+' 	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+' 	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+' 	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+' 	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+' 	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'     , myTarget.UpdatedDate = current_timestamp' + CHAR(13)

+' OUTPUT ''Address One Updated'' AS ChangeType, deleted.AddressOneStreet, deleted.AddressOneCity,' + CHAR(13)
+' deleted.AddressOneState, deleted.AddressOneZip, deleted.AddressOneCounty, deleted.AddressOneCountry,' + CHAR(13)
+' deleted.AddressOneDirtyHash, deleted.AddressOneIsCleanStatus,' + CHAR(13)
+' inserted.AddressOneStreet, inserted.AddressOneCity,' + CHAR(13)
+' inserted.AddressOneState, inserted.AddressOneZip, inserted.AddressOneCounty, inserted.AddressOneCountry,' + CHAR(13)
+' inserted.AddressOneDirtyHash, inserted.AddressOneIsCleanStatus,  ' + CHAR(13)
+' current_timestamp, mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #AddressChanges; ' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Address One Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


/***AddressTwo***/
SET @sql = @sql + CHAR(13) + CHAR(13)	
SET @sql = @sql

+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.AddressTwoDirtyHash,-1) <> isnull(myTarget.AddressTwoDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+' 	 myTarget.AddressTwoDirtyHash = mySource.AddressTwoDirtyHash' + CHAR(13)
+' 	, myTarget.AddressTwoIsCleanStatus = ''Dirty''' + CHAR(13)
+' 	, myTarget.AddressTwoStreet = mySource.AddressTwoStreet' + CHAR(13)
+' 	, myTarget.AddressTwoCity = mySource.AddressTwoCity' + CHAR(13)
+' 	, myTarget.AddressTwoState = mySource.AddressTwoState' + CHAR(13)
+' 	, myTarget.AddressTwoZip = mySource.AddressTwoZip' + CHAR(13)
+' 	, myTarget.AddressTwoCounty = mySource.AddressTwoCounty' + CHAR(13)
+' 	, myTarget.AddressTwoCountry = mySource.AddressTwoCountry' + CHAR(13)
		
+' 	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+' 	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+' 	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+' 	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+' 	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'     , myTarget.UpdatedDate = current_timestamp' + CHAR(13)

+' OUTPUT ''Address Two Updated'' AS ChangeType, deleted.AddressTwoStreet, deleted.AddressTwoCity,' + CHAR(13)
+' deleted.AddressTwoState, deleted.AddressTwoZip, deleted.AddressTwoCounty, deleted.AddressTwoCountry,' + CHAR(13)
+' deleted.AddressTwoDirtyHash, deleted.AddressTwoIsCleanStatus,' + CHAR(13)
+' inserted.AddressTwoStreet, inserted.AddressTwoCity,' + CHAR(13)
+' inserted.AddressTwoState, inserted.AddressTwoZip, inserted.AddressTwoCounty, inserted.AddressTwoCountry,' + CHAR(13)
+' inserted.AddressTwoDirtyHash, inserted.AddressTwoIsCleanStatus,  ' + CHAR(13)
+' current_timestamp, mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #AddressChanges; ' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Address Two Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/***AddressThree***/
SET @sql = @sql + CHAR(13) + CHAR(13)	
SET @sql = @sql

+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.AddressThreeDirtyHash,-1) <> isnull(myTarget.AddressThreeDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+' 	 myTarget.AddressThreeDirtyHash = mySource.AddressThreeDirtyHash' + CHAR(13)
+' 	, myTarget.AddressThreeIsCleanStatus = ''Dirty''' + CHAR(13)
+' 	, myTarget.AddressThreeStreet = mySource.AddressThreeStreet' + CHAR(13)
+' 	, myTarget.AddressThreeCity = mySource.AddressThreeCity' + CHAR(13)
+' 	, myTarget.AddressThreeState = mySource.AddressThreeState' + CHAR(13)
+' 	, myTarget.AddressThreeZip = mySource.AddressThreeZip' + CHAR(13)
+' 	, myTarget.AddressThreeCounty = mySource.AddressThreeCounty' + CHAR(13)
+' 	, myTarget.AddressThreeCountry = mySource.AddressThreeCountry' + CHAR(13)
		
+' 	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+' 	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+' 	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+' 	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+' 	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'     , myTarget.UpdatedDate = current_timestamp' + CHAR(13)

+' OUTPUT ''Address Three Updated'' AS ChangeType, deleted.AddressThreeStreet, deleted.AddressThreeCity,' + CHAR(13)
+' deleted.AddressThreeState, deleted.AddressThreeZip, deleted.AddressThreeCounty, deleted.AddressThreeCountry,' + CHAR(13)
+' deleted.AddressThreeDirtyHash, deleted.AddressThreeIsCleanStatus,' + CHAR(13)
+' inserted.AddressThreeStreet, inserted.AddressThreeCity,' + CHAR(13)
+' inserted.AddressThreeState, inserted.AddressThreeZip, inserted.AddressThreeCounty, inserted.AddressThreeCountry,' + CHAR(13)
+' inserted.AddressThreeDirtyHash, inserted.AddressThreeIsCleanStatus,  ' + CHAR(13)
+' current_timestamp, mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #AddressChanges; ' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	


SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Address Three Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/***AddressFour***/
SET @sql = @sql + CHAR(13) + CHAR(13)	
SET @sql = @sql

+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED AND isnull(mySource.AddressFourDirtyHash,-1) <> isnull(myTarget.AddressFourDirtyHash, -1)' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+' 	 myTarget.AddressFourDirtyHash = mySource.AddressFourDirtyHash' + CHAR(13)
+' 	, myTarget.AddressFourIsCleanStatus = ''Dirty''' + CHAR(13)
+' 	, myTarget.AddressFourStreet = mySource.AddressFourStreet' + CHAR(13)
+' 	, myTarget.AddressFourCity = mySource.AddressFourCity' + CHAR(13)
+' 	, myTarget.AddressFourState = mySource.AddressFourState' + CHAR(13)
+' 	, myTarget.AddressFourZip = mySource.AddressFourZip' + CHAR(13)
+' 	, myTarget.AddressFourCounty = mySource.AddressFourCounty' + CHAR(13)
+' 	, myTarget.AddressFourCountry = mySource.AddressFourCountry' + CHAR(13)
		
+' 	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+' 	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+' 	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+' 	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+' 	, myTarget.UpdatedBy = ''CI''' + CHAR(13)
+'     , myTarget.UpdatedDate = current_timestamp' + CHAR(13)

+' OUTPUT ''Address Four Updated'' AS ChangeType, deleted.AddressFourStreet, deleted.AddressFourCity,' + CHAR(13)
+' deleted.AddressFourState, deleted.AddressFourZip, deleted.AddressFourCounty, deleted.AddressFourCountry,' + CHAR(13)
+' deleted.AddressFourDirtyHash, deleted.AddressFourIsCleanStatus,' + CHAR(13)
+' inserted.AddressFourStreet, inserted.AddressFourCity,' + CHAR(13)
+' inserted.AddressFourState, inserted.AddressFourZip, inserted.AddressFourCounty, inserted.AddressFourCountry,' + CHAR(13)
+' inserted.AddressFourDirtyHash, inserted.AddressFourIsCleanStatus,  ' + CHAR(13)
+' current_timestamp, mySource.SSID,  mySource.SourceSystem,  mySource.SourceDB' + CHAR(13)
+' INTO #AddressChanges; ' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Address Four Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

IF @LogLevel = 2

BEGIN 
SET @sql = @sql

+' INSERT INTO  ' + @ClientDB  +'audit.ChangeLogDetail ' + CHAR(13)
+' SELECT ''Dimcustomer'', ChangeType, ''Data Load'', DateTimeChanged, ' + CHAR(13)
+' ssb_mdm.dbo.fnStripLowAscii(Replace((SELECT SSID, SourceSystem, SourceDB, street_old, city_old, state_old, zip_old, county_old, country_old, dirtyhash_old, iscleanstatus_old FROM #Addresschanges AS Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem and changetype = a.changetype FOR XML AUTO, Elements XSINIL), ''&'', ''&amp;'')) AS Old, ' + CHAR(13)
+' ssb_mdm.dbo.fnStripLowAscii(Replace((SELECT SSID, SourceSystem, SourceDB, street_new, city_new, state_new, zip_new, county_new, country_new, dirtyhash_new, iscleanstatus_new FROM #Addresschanges AS Changes WHERE ssid = a.ssid AND sourcesystem = a.sourcesystem and changetype = a.changetype FOR XML AUTO, Elements XSINIL), ''&'', ''&amp;'')) AS New ' + CHAR(13)
+' FROM #AddressChanges a;' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Address Change Detail'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

END
	

EXEC sp_executesql @sql;

END









GO
