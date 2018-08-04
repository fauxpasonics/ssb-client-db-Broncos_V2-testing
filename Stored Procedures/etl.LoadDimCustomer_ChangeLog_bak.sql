SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [etl].[LoadDimCustomer_ChangeLog_bak] 
(
	@ClientDB VARCHAR(50),
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
exec [etl].[LoadDimCustomer_ChangeLog] 'PSP', 'test', 1
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


IF @LogLevel > 1
BEGIN

SET @sql = @sql

/*Insert records with changes into change log*/
+' INSERT INTO ' + @ClientDB + 'audit.ChangeLog' + CHAR(13)
+' SELECT  a.dimcustomerid' + CHAR(13)
+' , ''Incoming Record''' + CHAR(13)
+' , ''DataLoad''' + CHAR(13)
+' , dbo.fnStripLowAscii(Replace((SELECT Dimcustomerid, batchid' + CHAR(13)
+ '           ,[ODSRowLastUpdated]' + CHAR(13)
+ '           ,[SourceDB]' + CHAR(13)
+ '           ,[SourceSystem]' + CHAR(13)
+ '           ,[SourceSystemPriority]' + CHAR(13)
+ '           ,[SSID] as SSID' + CHAR(13)
+ '           ,[CustomerType]' + CHAR(13)
+ '           ,[CustomerStatus]' + CHAR(13)
+ '           ,[AccountType]' + CHAR(13)
+ '           ,[AccountRep]' + CHAR(13)
+ '           ,[CompanyName]' + CHAR(13)
+ '           ,[SalutationName]' + CHAR(13)
+ '           ,[DonorMailName]' + CHAR(13)
+ '           ,[DonorFormalName]' + CHAR(13)
+ '           ,[Birthday]' + CHAR(13)
+ '           ,[Gender]' + CHAR(13)
+ '           ,[MergedRecordFlag]' + CHAR(13)
+ '           ,[MergedIntoSSID]' + CHAR(13)
+ '           ,[Prefix]' + CHAR(13)
+ '           ,[FirstName]' + CHAR(13)
+ '           ,[MiddleName]' + CHAR(13)
+ '           ,[LastName]' + CHAR(13)
+ '           ,[Suffix]' + CHAR(13)
+ '           ,[NameDirtyHash]' + CHAR(13)
+ '           ,[NameIsCleanStatus]' + CHAR(13)
+ '           ,[NameMasterId]' + CHAR(13)
+ '           ,[AddressPrimaryStreet]' + CHAR(13)
+ '           ,[AddressPrimaryCity]' + CHAR(13)
+ '           ,[AddressPrimaryState]' + CHAR(13)
+ '           ,[AddressPrimaryZip]' + CHAR(13)
+ '           ,[AddressPrimaryCounty]' + CHAR(13)
+ '           ,[AddressPrimaryCountry]' + CHAR(13)
+ '           ,[AddressPrimaryDirtyHash]' + CHAR(13)
+ '           ,[AddressPrimaryIsCleanStatus]' + CHAR(13)
+ '           ,[AddressPrimaryMasterId]' + CHAR(13)
+ '           ,[ContactDirtyHash]' + CHAR(13)
+ '           ,[ContactGUID]' + CHAR(13)
+ '           ,[AddressOneStreet]' + CHAR(13)
+ '           ,[AddressOneCity]' + CHAR(13)
+ '           ,[AddressOneState]' + CHAR(13)
+ '           ,[AddressOneZip]' + CHAR(13)
+ '           ,[AddressOneCounty]' + CHAR(13)
+ '           ,[AddressOneCountry]' + CHAR(13)
+ '           ,[AddressOneDirtyHash]' + CHAR(13)
+ '           ,[AddressOneIsCleanStatus]' + CHAR(13)
+ '           ,[AddressOneMasterId]' + CHAR(13)
+ '           ,[AddressTwoStreet]' + CHAR(13)
+ '           ,[AddressTwoCity]' + CHAR(13)
+ '           ,[AddressTwoState]' + CHAR(13)
+ '           ,[AddressTwoZip]' + CHAR(13)
+ '           ,[AddressTwoCounty]' + CHAR(13)
+ '           ,[AddressTwoCountry]' + CHAR(13)
+ '           ,[AddressTwoDirtyHash]' + CHAR(13)
+ '           ,[AddressTwoIsCleanStatus]' + CHAR(13)
+ '           ,[AddressTwoMasterId]' + CHAR(13)
+ '           ,[AddressThreeStreet]' + CHAR(13)
+ '           ,[AddressThreeCity]' + CHAR(13)
+ '           ,[AddressThreeState]' + CHAR(13)
+ '           ,[AddressThreeZip]' + CHAR(13)
+ '           ,[AddressThreeCounty]' + CHAR(13)
+ '           ,[AddressThreeCountry]' + CHAR(13)
+ '           ,[AddressThreeDirtyHash]' + CHAR(13)
+ '           ,[AddressThreeIsCleanStatus]' + CHAR(13)
+ '           ,[AddressThreeMasterId]' + CHAR(13)
+ '           ,[AddressFourStreet]' + CHAR(13)
+ '           ,[AddressFourCity]' + CHAR(13)
+ '           ,[AddressFourState]' + CHAR(13)
+ '           ,[AddressFourZip]' + CHAR(13)
+ '           ,[AddressFourCounty]' + CHAR(13)
+ '           ,[AddressFourCountry]' + CHAR(13)
+ '           ,[AddressFourDirtyHash]' + CHAR(13)
+ '           ,[AddressFourIsCleanStatus]' + CHAR(13)
+ '           ,[AddressFourMasterId]' + CHAR(13)
+ '           ,[PhonePrimary]' + CHAR(13)
+ '           ,[PhonePrimaryDirtyHash]' + CHAR(13)
+ '           ,[PhonePrimaryIsCleanStatus]' + CHAR(13)
+ '           ,[PhonePrimaryMasterId]' + CHAR(13)
+ '           ,[PhoneHome]' + CHAR(13)
+ '           ,[PhoneHomeDirtyHash]' + CHAR(13)
+ '           ,[PhoneHomeIsCleanStatus]' + CHAR(13)
+ '           ,[PhoneHomeMasterId]' + CHAR(13)
+ '           ,[PhoneCell]' + CHAR(13)
+ '           ,[PhoneCellDirtyHash]' + CHAR(13)
+ '           ,[PhoneCellIsCleanStatus]' + CHAR(13)
+ '           ,[PhoneCellMasterId]' + CHAR(13)
+ '           ,[PhoneBusiness]' + CHAR(13)
+ '           ,[PhoneBusinessDirtyHash]' + CHAR(13)
+ '           ,[PhoneBusinessIsCleanStatus]' + CHAR(13)
+ '           ,[PhoneBusinessMasterId]' + CHAR(13)
+ '           ,[PhoneFax]' + CHAR(13)
+ '           ,[PhoneFaxDirtyHash]' + CHAR(13)
+ '           ,[PhoneFaxIsCleanStatus]' + CHAR(13)
+ '           ,[PhoneFaxMasterId]' + CHAR(13)
+ '           ,[PhoneOther]' + CHAR(13)
+ '           ,[PhoneOtherDirtyHash]' + CHAR(13)
+ '           ,[PhoneOtherIsCleanStatus]'+ CHAR(13)
+ '           ,[PhoneOtherMasterId]' + CHAR(13)
+ '           ,[EmailPrimary]' + CHAR(13)
+ '           ,[EmailPrimaryDirtyHash]' + CHAR(13)
+ '           ,[EmailPrimaryIsCleanStatus]' + CHAR(13)
+ '           ,[EmailPrimaryMasterId]' + CHAR(13)
+ '           ,[EmailOne]' + CHAR(13)
+ '           ,[EmailOneDirtyHash]' + CHAR(13)
+ '           ,[EmailOneIsCleanStatus]' + CHAR(13)
+ '           ,[EmailOneMasterId]' + CHAR(13)
+ '           ,[EmailTwo]' + CHAR(13)
+ '           ,[EmailTwoDirtyHash]' + CHAR(13)
+ '           ,[EmailTwoIsCleanStatus]' + CHAR(13)
+ '           ,[EmailTwoMasterId]' + CHAR(13)
+ '           ,[ExtAttribute1]' + CHAR(13)
+ '           ,[ExtAttribute2]' + CHAR(13)
+ '           ,[ExtAttribute3]' + CHAR(13)
+ '           ,[ExtAttribute4]' + CHAR(13)
+ '           ,[ExtAttribute5]' + CHAR(13)
+ '           ,[ExtAttribute6]' + CHAR(13)
+ '           ,[ExtAttribute7]' + CHAR(13)
+ '           ,[ExtAttribute8]' + CHAR(13)
+ '           ,[ExtAttribute9]' + CHAR(13)
+ '           ,[ExtAttribute10]' + CHAR(13)
+ '           ,[ExtAttribute11]' + CHAR(13)
+ '           ,[ExtAttribute12]' + CHAR(13)
+ '           ,[ExtAttribute13]' + CHAR(13)
+ '           ,[ExtAttribute14]' + CHAR(13)
+ '           ,[ExtAttribute15]' + CHAR(13)
+ '           ,[ExtAttribute16]' + CHAR(13)
+ '           ,[ExtAttribute17]' + CHAR(13)
+ '           ,[ExtAttribute18]' + CHAR(13)
+ '           ,[ExtAttribute19]' + CHAR(13)
+ '           ,[ExtAttribute20]' + CHAR(13)
+ '           ,[ExtAttribute21]' + CHAR(13)
+ '           ,[ExtAttribute22]' + CHAR(13)
+ '           ,[ExtAttribute23]' + CHAR(13)
+ '           ,[ExtAttribute24]' + CHAR(13)
+ '           ,[ExtAttribute25]' + CHAR(13)
+ '           ,[ExtAttribute26]' + CHAR(13)
+ '           ,[ExtAttribute27]' + CHAR(13)
+ '           ,[ExtAttribute28]' + CHAR(13)
+ '           ,[ExtAttribute29]' + CHAR(13)
+ '           ,[ExtAttribute30]' + CHAR(13)
+ '           ,[SSCreatedBy]' + CHAR(13)
+ '           ,[SSUpdatedBy]' + CHAR(13)
+ '           ,[SSCreatedDate]' + CHAR(13)
+ '           ,[SSUpdatedDate]' + CHAR(13)
+ '           ,[CreatedBy]' + CHAR(13)
+ '           ,[UpdatedBy]' + CHAR(13)
+ '           ,[CreatedDate]' + CHAR(13)
+ '           ,[UpdatedDate]' + CHAR(13)
+ '           ,[AccountId]' + CHAR(13)
+ '           ,[AddressPrimaryNCOAStatus]' + CHAR(13)
+ '           ,[AddressOneStreetNCOAStatus]' + CHAR(13)
+ '           ,[AddressTwoStreetNCOAStatus]' + CHAR(13)
+ '           ,[AddressThreeStreetNCOAStatus]' + CHAR(13)
+ '           ,[AddressFourStreetNCOAStatus]' + CHAR(13)
+ '           ,[IsDeleted]' + CHAR(13)
+ '           ,[DeleteDate]' + CHAR(13)
+ '           ,[IsBusiness]' + CHAR(13)
+ '           ,[FullName]' + CHAR(13)
+ '           ,[ExtAttribute31]' + CHAR(13)
+ '           ,[ExtAttribute32]' + CHAR(13)
+ '           ,[ExtAttribute33]' + CHAR(13)
+ '           ,[ExtAttribute34]' + CHAR(13)
+ '           ,[ExtAttribute35]' + CHAR(13)
+ '           ,[AddressPrimarySuite]' + CHAR(13)
+ '           ,[AddressOneSuite]' + CHAR(13)
+ '           ,[AddressTwoSuite]' + CHAR(13)
+ '           ,[AddressThreeSuite]' + CHAR(13)
+ '           ,[AddressFourSuite]' + CHAR(13)
+ '           ,[customer_matchkey]' + CHAR(13)
+ '           ,[PhonePrimaryDNC]' + CHAR(13)
+ '           ,[PhoneHomeDNC]' + CHAR(13)
+ '           ,[PhoneCellDNC]' + CHAR(13)
+ '           ,[PhoneBusinessDNC]' + CHAR(13)
+ '           ,[PhoneFaxDNC]' + CHAR(13)
+ '           ,[PhoneOtherDNC]' + CHAR(13)
+ ' FROM ' + @ClientDB + 'etl.tmp_changes_' + @LoadGuid + ' as dimcustomer WHERE dimcustomerid = a.dimcustomerid FOR XML AUTO, ELEMENTS XSINIL), ''&'', ''&amp;'')) AS xmldata  ' + CHAR(13)
+' , GETDATE()' + CHAR(13)
+' FROM  ' + @ClientDB + 'etl.tmp_changes_' + @LoadGuid + ' a' + CHAR(13)


SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into  ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Log Change Records'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)
END

Print @SQL

EXEC sp_executesql @sql;

END



GO
