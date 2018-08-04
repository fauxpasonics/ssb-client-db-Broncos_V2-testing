SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[LoadDimCustomer_LoadNew_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LoadGuid VARCHAR(50)
)
AS
BEGIN


/*[etl].[LoadDimCustomer] 
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
	@sql NVARCHAR(MAX) = '  '

SET @sql = @sql 
+ ' If (select count(0) from ' + @ClientDB + @LoadView + ') > 200000 ' + CHAR(13)
+' Begin '
+ 'Exec dbo.sp_EnableDisableIndexes 0, ''dbo.DimCustomer'''
--+ 'Alter Index All on '+ @ClientDB + 'dbo.dimcustomer DISABLE;'
+ ' End '

/*Insert New Records*/
SET @sql = @sql
+ ' INSERT INTO '+ @ClientDB + '[dbo].[DimCustomer] ' + CHAR(13)
+ '( SourceDB, SourceSystem, SourceSystemPriority, SSID, CustomerType, CustomerStatus, AccountType, AccountRep, CompanyName, SalutationName, DonorMailName, DonorFormalName, Birthday, Gender, MergedRecordFlag, MergedIntoSSID, Prefix, FirstName, MiddleName, LastName, Suffix, NameDirtyHash, NameIsCleanStatus, NameMasterId, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip, AddressPrimaryCounty, AddressPrimaryCountry, AddressPrimaryDirtyHash, AddressPrimaryIsCleanStatus, AddressPrimaryMasterId, ContactDirtyHash, AddressOneStreet, AddressOneCity, AddressOneState, AddressOneZip, AddressOneCounty, AddressOneCountry, AddressOneDirtyHash, AddressOneIsCleanStatus, AddressOneMasterId, AddressTwoStreet, AddressTwoCity, AddressTwoState, AddressTwoZip, AddressTwoCounty, AddressTwoCountry, AddressTwoDirtyHash, AddressTwoIsCleanStatus, AddressTwoMasterId, AddressThreeStreet, AddressThreeCity, AddressThreeState, AddressThreeZip, AddressThreeCounty, AddressThreeCountry, AddressThreeDirtyHash, AddressThreeIsCleanStatus, AddressThreeMasterId, AddressFourStreet, AddressFourCity, AddressFourState, AddressFourZip, AddressFourCounty, AddressFourCountry, AddressFourDirtyHash, AddressFourIsCleanStatus, AddressFourMasterId, PhonePrimary, PhonePrimaryDirtyHash, PhonePrimaryIsCleanStatus, PhonePrimaryMasterId, PhoneHome, PhoneHomeDirtyHash, PhoneHomeIsCleanStatus, PhoneHomeMasterId, PhoneCell, PhoneCellDirtyHash, PhoneCellIsCleanStatus, PhoneCellMasterId, PhoneBusiness, PhoneBusinessDirtyHash, PhoneBusinessIsCleanStatus, PhoneBusinessMasterId, PhoneFax, PhoneFaxDirtyHash, PhoneFaxIsCleanStatus, PhoneFaxMasterId, PhoneOther, PhoneOtherDirtyHash, PhoneOtherIsCleanStatus, PhoneOtherMasterId, EmailPrimary, EmailPrimaryDirtyHash, EmailPrimaryIsCleanStatus, EmailPrimaryMasterId, EmailOne, EmailOneDirtyHash, EmailOneIsCleanStatus, EmailOneMasterId, EmailTwo, EmailTwoDirtyHash, EmailTwoIsCleanStatus, EmailTwoMasterId, ExtAttribute1, ExtAttribute2, ExtAttribute3, ExtAttribute4, ExtAttribute5, ExtAttribute6, ExtAttribute7, ExtAttribute8, ExtAttribute9, ExtAttribute10, ExtAttribute11, ExtAttribute12, ExtAttribute13, ExtAttribute14, ExtAttribute15, ExtAttribute16, ExtAttribute17, ExtAttribute18, ExtAttribute19, ExtAttribute20, ExtAttribute21, ExtAttribute22, ExtAttribute23, ExtAttribute24, ExtAttribute25, ExtAttribute26, ExtAttribute27, ExtAttribute28, ExtAttribute29, ExtAttribute30, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, AccountId, AddressPrimaryNCOAStatus, AddressOneStreetNCOAStatus, AddressTwoStreetNCOAStatus, AddressThreeStreetNCOAStatus, AddressFourStreetNCOAStatus, IsDeleted, DeleteDate, IsBusiness, FullName, ExtAttribute31, ExtAttribute32, ExtAttribute33, ExtAttribute34, ExtAttribute35, AddressPrimarySuite, AddressOneSuite, AddressTwoSuite, AddressThreeSuite, AddressFourSuite, customer_matchkey, PhonePrimaryDNC, PhoneHomeDNC, PhoneCellDNC, PhoneBusinessDNC, PhoneFaxDNC, PhoneOtherDNC ) ' + CHAR(13)
+ ' SELECT ' + CHAR(13)
+ '           a.[SourceDB]' + CHAR(13)
+ '           ,a.[SourceSystem]' + CHAR(13)
+ '           ,a.[SourceSystemPriority]' + CHAR(13)
+ '           ,a.[SSID]' + CHAR(13)
+ '           ,a.[CustomerType]' + CHAR(13)
+ '           ,a.[CustomerStatus]' + CHAR(13)
+ '           ,a.[AccountType]' + CHAR(13)
+ '           ,a.[AccountRep]' + CHAR(13)
+ '           ,a.[CompanyName]' + CHAR(13)
+ '           ,a.[SalutationName]' + CHAR(13)
+ '           ,a.[DonorMailName]' + CHAR(13)
+ '           ,a.[DonorFormalName]' + CHAR(13)
+ '           ,a.[Birthday]' + CHAR(13)
+ '           ,a.[Gender]' + CHAR(13)
+ '           ,a.[MergedRecordFlag]' + CHAR(13)
+ '           ,a.[MergedIntoSSID]' + CHAR(13)
+ '           ,a.[Prefix]' + CHAR(13)
+ '           ,a.[FirstName]' + CHAR(13)
+ '           ,a.[MiddleName]' + CHAR(13)
+ '           ,a.[LastName]' + CHAR(13)
+ '           ,a.[Suffix]' + CHAR(13)
+ '           ,a.[NameDirtyHash]' + CHAR(13)
+ '           ,a.[NameIsCleanStatus]' + CHAR(13)
+ '           ,a.[NameMasterId]' + CHAR(13)
+ '           ,a.[AddressPrimaryStreet]' + CHAR(13)
+ '           ,a.[AddressPrimaryCity]' + CHAR(13)
+ '           ,a.[AddressPrimaryState]' + CHAR(13)
+ '           ,a.[AddressPrimaryZip]' + CHAR(13)
+ '           ,a.[AddressPrimaryCounty]' + CHAR(13)
+ '           ,a.[AddressPrimaryCountry]' + CHAR(13)
+ '           ,a.[AddressPrimaryDirtyHash]' + CHAR(13)
+ '           ,a.[AddressPrimaryIsCleanStatus]' + CHAR(13)
+ '           ,a.[AddressPrimaryMasterId]' + CHAR(13)
+ '           ,a.[ContactDirtyHash]' + CHAR(13)
+ '           ,a.[AddressOneStreet]' + CHAR(13)
+ '           ,a.[AddressOneCity]' + CHAR(13)
+ '           ,a.[AddressOneState]' + CHAR(13)
+ '           ,a.[AddressOneZip]' + CHAR(13)
+ '           ,a.[AddressOneCounty]' + CHAR(13)
+ '           ,a.[AddressOneCountry]' + CHAR(13)
+ '           ,a.[AddressOneDirtyHash]' + CHAR(13)
+ '           ,a.[AddressOneIsCleanStatus]' + CHAR(13)
+ '           ,a.[AddressOneMasterId]' + CHAR(13)
+ '           ,a.[AddressTwoStreet]' + CHAR(13)
+ '           ,a.[AddressTwoCity]' + CHAR(13)
+ '           ,a.[AddressTwoState]' + CHAR(13)
+ '           ,a.[AddressTwoZip]' + CHAR(13)
+ '           ,a.[AddressTwoCounty]' + CHAR(13)
+ '           ,a.[AddressTwoCountry]' + CHAR(13)
+ '           ,a.[AddressTwoDirtyHash]' + CHAR(13)
+ '           ,a.[AddressTwoIsCleanStatus]' + CHAR(13)
+ '           ,a.[AddressTwoMasterId]' + CHAR(13)
+ '           ,a.[AddressThreeStreet]' + CHAR(13)
+ '           ,a.[AddressThreeCity]' + CHAR(13)
+ '           ,a.[AddressThreeState]' + CHAR(13)
+ '           ,a.[AddressThreeZip]' + CHAR(13)
+ '           ,a.[AddressThreeCounty]' + CHAR(13)
+ '           ,a.[AddressThreeCountry]' + CHAR(13)
+ '           ,a.[AddressThreeDirtyHash]' + CHAR(13)
+ '           ,a.[AddressThreeIsCleanStatus]' + CHAR(13)
+ '           ,a.[AddressThreeMasterId]' + CHAR(13)
+ '           ,a.[AddressFourStreet]' + CHAR(13)
+ '           ,a.[AddressFourCity]' + CHAR(13)
+ '           ,a.[AddressFourState]' + CHAR(13)
+ '           ,a.[AddressFourZip]' + CHAR(13)
+ '           ,a.[AddressFourCounty]' + CHAR(13)
+ '           ,a.[AddressFourCountry]' + CHAR(13)
+ '           ,a.[AddressFourDirtyHash]' + CHAR(13)
+ '           ,a.[AddressFourIsCleanStatus]' + CHAR(13)
+ '           ,a.[AddressFourMasterId]' + CHAR(13)
+ '           ,a.[PhonePrimary]' + CHAR(13)
+ '           ,a.[PhonePrimaryDirtyHash]' + CHAR(13)
+ '           ,a.[PhonePrimaryIsCleanStatus]' + CHAR(13)
+ '           ,a.[PhonePrimaryMasterId]' + CHAR(13)
+ '           ,a.[PhoneHome]' + CHAR(13)
+ '           ,a.[PhoneHomeDirtyHash]' + CHAR(13)
+ '           ,a.[PhoneHomeIsCleanStatus]' + CHAR(13)
+ '           ,a.[PhoneHomeMasterId]' + CHAR(13)
+ '           ,a.[PhoneCell]' + CHAR(13)
+ '           ,a.[PhoneCellDirtyHash]' + CHAR(13)
+ '           ,a.[PhoneCellIsCleanStatus]' + CHAR(13)
+ '           ,a.[PhoneCellMasterId]' + CHAR(13)
+ '           ,a.[PhoneBusiness]' + CHAR(13)
+ '           ,a.[PhoneBusinessDirtyHash]' + CHAR(13)
+ '           ,a.[PhoneBusinessIsCleanStatus]' + CHAR(13)
+ '           ,a.[PhoneBusinessMasterId]' + CHAR(13)
+ '           ,a.[PhoneFax]' + CHAR(13)
+ '           ,a.[PhoneFaxDirtyHash]' + CHAR(13)
+ '           ,a.[PhoneFaxIsCleanStatus]' + CHAR(13)
+ '           ,a.[PhoneFaxMasterId]' + CHAR(13)
+ '           ,a.[PhoneOther]' + CHAR(13)
+ '           ,a.[PhoneOtherDirtyHash]' + CHAR(13)
+ '           ,a.[PhoneOtherIsCleanStatus]' + CHAR(13)
+ '           ,a.[PhoneOtherMasterId]' + CHAR(13)
+ '           ,a.[EmailPrimary]' + CHAR(13)
+ '           ,a.[EmailPrimaryDirtyHash]' + CHAR(13)
+ '           ,a.[EmailPrimaryIsCleanStatus]' + CHAR(13)
+ '           ,a.[EmailPrimaryMasterId]' + CHAR(13)
+ '           ,a.[EmailOne]' + CHAR(13)
+ '           ,a.[EmailOneDirtyHash]' + CHAR(13)
+ '           ,a.[EmailOneIsCleanStatus]' + CHAR(13)
+ '           ,a.[EmailOneMasterId]' + CHAR(13)
+ '           ,a.[EmailTwo]' + CHAR(13)
+ '           ,a.[EmailTwoDirtyHash]' + CHAR(13)
+ '           ,a.[EmailTwoIsCleanStatus]' + CHAR(13)
+ '           ,a.[EmailTwoMasterId]' + CHAR(13)
+ '           ,a.[ExtAttribute1]' + CHAR(13)
+ '           ,a.[ExtAttribute2]' + CHAR(13)
+ '           ,a.[ExtAttribute3]' + CHAR(13)
+ '           ,a.[ExtAttribute4]' + CHAR(13)
+ '           ,a.[ExtAttribute5]' + CHAR(13)
+ '           ,a.[ExtAttribute6]' + CHAR(13)
+ '           ,a.[ExtAttribute7]' + CHAR(13)
+ '           ,a.[ExtAttribute8]' + CHAR(13)
+ '           ,a.[ExtAttribute9]' + CHAR(13)
+ '           ,a.[ExtAttribute10]' + CHAR(13)
+ '           ,a.[ExtAttribute11]' + CHAR(13)
+ '           ,a.[ExtAttribute12]' + CHAR(13)
+ '           ,a.[ExtAttribute13]' + CHAR(13)
+ '           ,a.[ExtAttribute14]' + CHAR(13)
+ '           ,a.[ExtAttribute15]' + CHAR(13)
+ '           ,a.[ExtAttribute16]' + CHAR(13)
+ '           ,a.[ExtAttribute17]' + CHAR(13)
+ '           ,a.[ExtAttribute18]' + CHAR(13)
+ '           ,a.[ExtAttribute19]' + CHAR(13)
+ '           ,a.[ExtAttribute20]' + CHAR(13)
+ '           ,a.[ExtAttribute21]' + CHAR(13)
+ '           ,a.[ExtAttribute22]' + CHAR(13)
+ '           ,a.[ExtAttribute23]' + CHAR(13)
+ '           ,a.[ExtAttribute24]' + CHAR(13)
+ '           ,a.[ExtAttribute25]' + CHAR(13)
+ '           ,a.[ExtAttribute26]' + CHAR(13)
+ '           ,a.[ExtAttribute27]' + CHAR(13)
+ '           ,a.[ExtAttribute28]' + CHAR(13)
+ '           ,a.[ExtAttribute29]' + CHAR(13)
+ '           ,a.[ExtAttribute30]' + CHAR(13)
+ '           ,a.[SSCreatedBy]' + CHAR(13)
+ '           ,a.[SSUpdatedBy]' + CHAR(13)
+ '           ,a.[SSCreatedDate]' + CHAR(13)
+ '           ,a.[SSUpdatedDate]' + CHAR(13)
+ '           ,''MDM Process'' [CreatedBy]' + CHAR(13)
+ '           ,'''' [UpdatedBy]' + CHAR(13)
+ '           ,a.[CreatedDate]' + CHAR(13)
+ '           ,a.[UpdatedDate]' + CHAR(13)
+ '           ,a.[AccountId]' + CHAR(13)

+ '           ,a.[AddressPrimaryNCOAStatus]' + CHAR(13)
+ '           ,a.[AddressOneStreetNCOAStatus]' + CHAR(13)
+ '           ,a.[AddressTwoStreetNCOAStatus]' + CHAR(13)
+ '           ,a.[AddressThreeStreetNCOAStatus]' + CHAR(13)
+ '           ,a.[AddressFourStreetNCOAStatus]' + CHAR(13)

+ '           ,a.[IsDeleted]' + CHAR(13)
+ '           ,a.[DeleteDate]' + CHAR(13)
+ '           ,a.[IsBusiness]' + CHAR(13)
+ '           ,a.[FullName]' + CHAR(13)
+ '           ,a.[ExtAttribute31]' + CHAR(13)
+ '           ,a.[ExtAttribute32]' + CHAR(13)
+ '           ,a.[ExtAttribute33]' + CHAR(13)
+ '           ,a.[ExtAttribute34]' + CHAR(13)
+ '           ,a.[ExtAttribute35]' + CHAR(13)
+ '           ,a.[AddressPrimarySuite]' + CHAR(13)
+ '           ,a.[AddressOneSuite]' + CHAR(13)
+ '           ,a.[AddressTwoSuite]' + CHAR(13)
+ '           ,a.[AddressThreeSuite]' + CHAR(13)
+ '           ,a.[AddressFourSuite]' + CHAR(13)
+ '           ,a.[customer_matchkey]' + CHAR(13)
+ '           ,NULL [PhonePrimaryDNC]' + CHAR(13)
+ '           ,NULL [PhoneHomeDNC]' + CHAR(13)
+ '           ,NULL [PhoneCellDNC]' + CHAR(13)
+ '           ,NULL [PhoneBusinessDNC]' + CHAR(13)
+ '           ,NULL [PhoneFaxDNC]' + CHAR(13)
+ '           ,NULL [PhoneOtherDNC]' + CHAR(13)
+ '  FROM '+ @ClientDB + @LoadView + ' a' + CHAR(13)
+ '  Left Join '+ @ClientDB + 'etl.tmp_changes_' + @LoadGuid + ' b' + CHAR(13)
+ '  on a.ssid = b.ssid' + CHAR(13)
+ ' and a.sourcesystem = b.sourcesystem' + CHAR(13)
+ ' and a.sourcedb = b.sourcedb' + CHAR(13)
+ ' where b.dimcustomerid is null;' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql
	+ 'Insert into '+ @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Insert New Records'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
+ ' If (select count(0) from '+ @ClientDB + @LoadView + ') > 200000 ' + CHAR(13)
+' Begin '
+ 'Exec dbo.sp_EnableDisableIndexes 1, ''dbo.DimCustomer'''
--+ 'Alter Index All on '+ @ClientDB + 'dbo.dimcustomer REBUILD;'
+ ' End '

SELECT @SQL

EXEC sp_executesql @sql;

END




GO
