SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[LoadDimCustomer_AttributeChanges_bak] 
(
	@ClientDB VARCHAR(50),
	@LoadView VARCHAR(100),
	@LogLevel INT 
)
AS
BEGIN


/*[etl].[LoadDimCustomer_AttributeChanges] 
* created: 7/2/2015 - Kwyss - dynamic sql procedure to load data to dimcustomer.   Pass in client db name and view to load from.
* Log Levels - 0 = none; 1 = record; 2 = detail
* Currently not logging changes to extended attributes
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

/***Standard and Extended Attributes***/
+' MERGE ' + @ClientDB + 'dbo.DimCustomer AS myTarget' + CHAR(13)

+' USING (select * from ' + @LoadView + ') as mySource' + CHAR(13)
+'     ON' + CHAR(13)
+'		myTarget.SourceDB = mySource.SourceDB' + CHAR(13)
+'		and myTarget.SourceSystem = mySource.SourceSystem' + CHAR(13)
+'		and myTarget.SSID = mySource.SSID' + CHAR(13)

+' WHEN MATCHED   ' + CHAR(13)

+' THEN UPDATE SET ' + CHAR(13)
+'	myTarget.CustomerType = mySource.CustomerType ' + CHAR(13)
+'	, myTarget.CustomerStatus = mySource.CustomerStatus ' + CHAR(13)
+'  , myTarget.AccountType = mySource.AccountType' + CHAR(13)
+'	, myTarget.AccountRep = mySource.AccountRep' + CHAR(13)
+'	, myTarget.CompanyName = mySource.CompanyName' + CHAR(13)
+'	, myTarget.SalutationName = mySource.SalutationName' + CHAR(13)
+'	, myTarget.DonorMailName = mySource.DonorMailName' + CHAR(13)
+'	, myTarget.DonorFormalName = mySource.DonorFormalName' + CHAR(13)
+'	, myTarget.Birthday = mySource.Birthday' + CHAR(13)
+'	, myTarget.Gender = mySource.Gender' + CHAR(13)
+'	, myTarget.AccountId = mySource.AccountId' + CHAR(13)
+'	, myTarget.MergedRecordFlag = mySource.MergedRecordFlag' + CHAR(13)
+'	, myTarget.MergedIntoSSID =  mySource.MergedIntoSSID' + CHAR(13)
+'	, myTarget.IsBusiness = mySource.IsBusiness' + CHAR(13)

+'	, myTarget.ExtAttribute1 = mySource.ExtAttribute1' + CHAR(13)
+'	, myTarget.ExtAttribute2 = mySource.ExtAttribute2' + CHAR(13)
+'	, myTarget.ExtAttribute3 = mySource.ExtAttribute3' + CHAR(13)
+'	, myTarget.ExtAttribute4 = mySource.ExtAttribute4' + CHAR(13)
+'	, myTarget.ExtAttribute5 = mySource.ExtAttribute5' + CHAR(13)
+'	, myTarget.ExtAttribute6 = mySource.ExtAttribute6' + CHAR(13)
+'	, myTarget.ExtAttribute7 = mySource.ExtAttribute7' + CHAR(13)
+'	, myTarget.ExtAttribute8 = mySource.ExtAttribute8' + CHAR(13)
+'	, myTarget.ExtAttribute9 = mySource.ExtAttribute9' + CHAR(13)
+'	, myTarget.ExtAttribute10 = mySource.ExtAttribute10' + CHAR(13)
+'	, myTarget.ExtAttribute11 = mySource.ExtAttribute11' + CHAR(13)
+'	, myTarget.ExtAttribute12 = mySource.ExtAttribute12' + CHAR(13)
+'	, myTarget.ExtAttribute13 = mySource.ExtAttribute13' + CHAR(13)
+'	, myTarget.ExtAttribute14 = mySource.ExtAttribute14' + CHAR(13)
+'	, myTarget.ExtAttribute15 = mySource.ExtAttribute15' + CHAR(13)
+'	, myTarget.ExtAttribute16 = mySource.ExtAttribute16' + CHAR(13)
+'	, myTarget.ExtAttribute17 = mySource.ExtAttribute17' + CHAR(13)
+'	, myTarget.ExtAttribute18 = mySource.ExtAttribute18' + CHAR(13)
+'	, myTarget.ExtAttribute19 = mySource.ExtAttribute19' + CHAR(13)
+'	, myTarget.ExtAttribute20 = mySource.ExtAttribute20' + CHAR(13)
+'	, myTarget.ExtAttribute21 = mySource.ExtAttribute21' + CHAR(13)
+'	, myTarget.ExtAttribute22 = mySource.ExtAttribute22' + CHAR(13)
+'	, myTarget.ExtAttribute23 = mySource.ExtAttribute23' + CHAR(13)
+'	, myTarget.ExtAttribute24 = mySource.ExtAttribute24' + CHAR(13)
+'	, myTarget.ExtAttribute25 = mySource.ExtAttribute25' + CHAR(13)
+'	, myTarget.ExtAttribute26 = mySource.ExtAttribute26' + CHAR(13)
+'	, myTarget.ExtAttribute27 = mySource.ExtAttribute27' + CHAR(13)
+'	, myTarget.ExtAttribute28 = mySource.ExtAttribute28' + CHAR(13)
+'	, myTarget.ExtAttribute29 = mySource.ExtAttribute29' + CHAR(13)
+'	, myTarget.ExtAttribute30 = mySource.ExtAttribute30' + CHAR(13)
+'	, myTarget.ExtAttribute31 = mySource.ExtAttribute31' + CHAR(13)
+'	, myTarget.ExtAttribute32 = mySource.ExtAttribute32' + CHAR(13)
+'	, myTarget.ExtAttribute33 = mySource.ExtAttribute33' + CHAR(13)
+'	, myTarget.ExtAttribute34 = mySource.ExtAttribute34' + CHAR(13)
+'	, myTarget.ExtAttribute35 = mySource.ExtAttribute35' + CHAR(13)

		
+'	, myTarget.SSCreatedBy = mySource.SSCreatedBy' + CHAR(13)
+'	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy' + CHAR(13)
+'	, myTarget.SSCreatedDate = mySource.SSCreatedDate' + CHAR(13)
+'	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate' + CHAR(13)
+'	, myTarget.UpdatedBy = ''CI'''+ CHAR(13)
+'   , myTarget.UpdatedDate = CURRENT_TIMESTAMP' + CHAR(13)
+'	;' + CHAR(13)

SET @sql = @sql + CHAR(13) + CHAR(13)	


SET @sql = @sql
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Load DimCustomer'', ''Attribute Changes'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

EXEC sp_executesql @sql;

END




GO
