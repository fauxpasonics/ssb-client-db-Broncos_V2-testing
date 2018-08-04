SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*****Hash Rules for Reference******
WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_INT'')'
WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIGINT'')'
WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'  
WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'
WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ',112)),''DBNULL_DATE'')' 
WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIT'')'  
WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
ELSE 'ISNULL(RTRIM(' + COLUMN_NAME + '),''DBNULL_TEXT'')'
*****/

CREATE VIEW [ods].[vw_Fanatics_LoadDimCustomer]
AS
    (
      SELECT  *
/*Name*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.Prefix), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.FirstName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.MiddleName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.LastName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.Suffix), 'DBNULL_TEXT')) AS [NameDirtyHash]
              , 'Dirty' AS [NameIsCleanStatus]
              , NULL AS [NameMasterId]

/*Address*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressPrimaryStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCounty),
                                   'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCountry),
                                   'DBNULL_TEXT')) AS [AddressPrimaryDirtyHash]
              , 'Dirty' AS [AddressPrimaryIsCleanStatus]
              , NULL AS [AddressPrimaryMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressOneStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneCountry), 'DBNULL_TEXT')) AS [AddressOneDirtyHash]
              , 'Dirty' AS [AddressOneIsCleanStatus]
              , NULL AS [AddressOneMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressTwoStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoCountry), 'DBNULL_TEXT')) AS [AddressTwoDirtyHash]
              , 'Dirty' AS [AddressTwoIsCleanStatus]
              , NULL AS [AddressTwoMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressThreeStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeCountry), 'DBNULL_TEXT')) AS [AddressThreeDirtyHash]
              , 'Dirty' AS [AddressThreeIsCleanStatus]
              , NULL AS [AddressThreeMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressFourStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourCountry), 'DBNULL_TEXT')) AS [AddressFourDirtyHash]
              , 'Dirty' AS [AddressFourIsCleanStatus]
              , NULL AS [AddressFourMasterId]

/*Contact*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.Prefix), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.FirstName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.MiddleName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.LastName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.Suffix), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryStreet),
                                   'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCounty),
                                   'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCountry),
                                   'DBNULL_TEXT')) AS [ContactDirtyHash]
              , CAST(NULL AS NVARCHAR(50)) AS [ContactGuid]

/*Phone*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhonePrimary), 'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
              , 'Dirty' AS [PhonePrimaryIsCleanStatus]
              , NULL AS [PhonePrimaryMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhoneHome), 'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
              , 'Dirty' AS [PhoneHomeIsCleanStatus]
              , NULL AS [PhoneHomeMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhoneCell), 'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
              , 'Dirty' AS [PhoneCellIsCleanStatus]
              , NULL AS [PhoneCellMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhoneBusiness), 'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
              , 'Dirty' AS [PhoneBusinessIsCleanStatus]
              , NULL AS [PhoneBusinessMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.PhoneFax), 'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
              , 'Dirty' AS [PhoneFaxIsCleanStatus]
              , NULL AS [PhoneFaxMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.PhoneFax), 'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
              , 'Dirty' AS [PhoneOtherIsCleanStatus]
              , NULL AS [PhoneOtherMasterId]

/*Email*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.EmailPrimary), 'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
              , 'Dirty' AS [EmailPrimaryIsCleanStatus]
              , NULL AS [EmailPrimaryMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.EmailOne), 'DBNULL_TEXT')) AS [EmailOneDirtyHash]
              , 'Dirty' AS [EmailOneIsCleanStatus]
              , NULL AS [EmailOneMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.EmailTwo), 'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
              , 'Dirty' AS [EmailTwoIsCleanStatus]
              , NULL AS [EmailTwoMasterId]
			  /*External Attributes*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(customerType),'DBNULL_TEXT')  ---------------------- Added in by PS 01/24/2016
							+ ISNULL(RTRIM(CustomerStatus),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AccountType),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AccountRep),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(SalutationName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(DonorMailName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(DonorFormalName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Birthday),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(Gender),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AccountId),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedRecordFlag),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedIntoSSID),'DBNULL_TEXT')
							+ ISNULL(RTRIM(IsBusiness),'DBNULL_TEXT')) AS [contactattrDirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute1),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute2),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute3),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute4),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute5),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute6),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute7),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute8),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute9),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute10),'DBNULL_TEXT') 
							) AS [extattr1_10DirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute11),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute12),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute13),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute14),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute15),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute16),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute17),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute18),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute19),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute20),'DBNULL_TEXT') 
							) AS [extattr11_20DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute21),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute22),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute23),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute24),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute25),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute26),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute27),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute28),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute29),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute30),'DBNULL_TEXT') 
							) AS [extattr21_30DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute31),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute32),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute33),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute34),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute35),'DBNULL_TEXT')
							) AS [extattr31_35DirtyHash]




      FROM      (
                  --base set
SELECT  DB_NAME() AS [SourceDB]
      , 'Fanatics' AS [SourceSystem]
      , 2 AS [SourceSystemPriority]

/*Standard Attributes*/
      , CAST(Client_ID AS NVARCHAR(100)) AS [SSID]
      , NULL AS [CustomerType]
      , NULL AS [CustomerStatus]
      , NULL AS [AccountType]
      , NULL AS [AccountRep]
      , NULL AS [CompanyName]
      , NULL AS [SalutationName]
      , NULL AS [DonorMailName]
      , NULL AS [DonorFormalName]
      , CAST(NULL AS DATE) AS [Birthday]
      , NULL AS [Gender]
      , 0 [MergedRecordFlag]
      , NULL [MergedIntoSSID]

/**ENTITIES**/
/*Name*/
      , NULL AS [Prefix]
      , Client_First_Name AS [FirstName]
      , NULL AS [MiddleName]
      , Client_Last_Name AS [LastName]
      , NULL AS [Suffix]
--, c.name_title as [Title]

/*AddressPrimary*/
      , BillAddressFull AS [AddressPrimaryStreet]
      , BillAddressCity AS [AddressPrimaryCity]
      , BillAddressState AS [AddressPrimaryState]
      , BillAddressZip AS [AddressPrimaryZip]
      , NULL AS [AddressPrimaryCounty]
      , BilAddressCountry AS [AddressPrimaryCountry]
      , NULL AS [AddressOneStreet]
      , NULL AS [AddressOneCity]
      , NULL AS [AddressOneState]
      , NULL AS [AddressOneZip]
      , NULL AS [AddressOneCounty]
      , NULL AS [AddressOneCountry]
      , NULL AS [AddressTwoStreet]
      , NULL AS [AddressTwoCity]
      , NULL AS [AddressTwoState]
      , NULL AS [AddressTwoZip]
      , NULL AS [AddressTwoCounty]
      , NULL AS [AddressTwoCountry]
      , NULL AS [AddressThreeStreet]
      , NULL AS [AddressThreeCity]
      , NULL AS [AddressThreeState]
      , NULL AS [AddressThreeZip]
      , NULL AS [AddressThreeCounty]
      , NULL AS [AddressThreeCountry]
      , NULL AS [AddressFourStreet]
      , NULL AS [AddressFourCity]
      , NULL AS [AddressFourState]
      , NULL AS [AddressFourZip]
      , NULL AS [AddressFourCounty]
      , NULL AS [AddressFourCountry] 

/*Phone*/
      , NULL AS [PhonePrimary] --May not be appropriate mapping
      , NULL AS [PhoneHome]
      , NULL AS [PhoneCell]
      , NULL AS [PhoneBusiness]
      , NULL AS [PhoneFax]
      , NULL AS [PhoneOther]

/*Email*/
      , Client_Email AS [EmailPrimary]
      , NULL AS [EmailOne]
      , NULL AS [EmailTwo]

/*Extended Attributes*/
      , NULL AS [ExtAttribute1] --nvarchar(100)
      , NULL AS [ExtAttribute2]
      , NULL AS [ExtAttribute3]
      , NULL AS [ExtAttribute4]
      , NULL AS [ExtAttribute5]
      , NULL AS [ExtAttribute6]
      , NULL AS [ExtAttribute7]
      , NULL AS [ExtAttribute8]
      , NULL AS [ExtAttribute9]
      , NULL AS [ExtAttribute10]
      , NULL AS [ExtAttribute11]
      , --CRMGUID
        NULL AS [ExtAttribute12]
      , NULL AS [ExtAttribute13]
      , NULL AS [ExtAttribute14]
      , NULL AS [ExtAttribute15]
      , NULL AS [ExtAttribute16]
      , NULL AS [ExtAttribute17]
      , NULL AS [ExtAttribute18]
      , NULL AS [ExtAttribute19]
      , NULL AS [ExtAttribute20]
      , NULL AS [ExtAttribute21] --datetime
      , NULL AS [ExtAttribute22]
      , NULL AS [ExtAttribute23]
      , NULL AS [ExtAttribute24]
      , NULL AS [ExtAttribute25]
      , NULL AS [ExtAttribute26]
      , NULL AS [ExtAttribute27]
      , NULL AS [ExtAttribute28]
      , NULL AS [ExtAttribute29]
      , NULL AS [ExtAttribute30]  
	  , NULL AS [ExtAttribute31]
      , NULL AS [ExtAttribute32]
      , NULL AS [ExtAttribute33]
      , NULL AS [ExtAttribute34]
      , NULL AS [ExtAttribute35]

/*Source Created and Updated*/
      , NULL [SSCreatedBy]
      , NULL [SSUpdatedBy]
      , OrderDate [SSCreatedDate]
	  , OrderDate [CreatedDate]
      , CAST(NULL AS DATE) [SSUpdatedDate]
      , Client_ID [AccountId]
      , NULL IsBusiness
	  , 0 isdeleted
--		select top 100 *
		FROM ods.vw_Fanatics_Orders_Rank
		WHERE 1 = 1
		AND ETL_UpdatedDate > DATEADD(DAY,-10,GETDATE())


                ) a
    );




















GO
