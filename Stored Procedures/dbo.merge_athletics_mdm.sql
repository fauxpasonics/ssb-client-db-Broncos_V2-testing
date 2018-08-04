SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[merge_athletics_mdm]  
    (  
        @BatchId INT = 0 ,  
        @Options NVARCHAR(MAX) = NULL  
    )  
AS  
    BEGIN /**************************************Comments***************************************  **************************************************************************************  Mod #:  1  Name:     SSBCRM_HarryJ  Date:     01/16/2018  Comments: I
nitial creation  *************************************************************************************/  
        DECLARE @RunTime DATETIME = GETDATE();  
        DECLARE @ExecutionId UNIQUEIDENTIFIER = NEWID();  
        DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID)  
                                               + '.' + OBJECT_NAME(@@PROCID);  
        DECLARE @SrcRowCount INT = ISNULL(  
                                   (   SELECT CONVERT(VARCHAR, COUNT(*))  
                                       FROM   [dbo].[tmp_stg_Athletics_MDM] ) ,  
                                   '0');  
        DECLARE @SrcDataSize NVARCHAR(255) = '0';  
        BEGIN TRY  
            PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100), @ExecutionId);  
            SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey ,  
                   ssb_crmsystem_contact_id ,  
                   sourcesystem ,  
                   ssid ,  
                   prefix ,  
                   firstname ,  
                   middlename ,  
                   lastname ,  
                   suffix ,  
                   nameiscleanstatus ,  
                   fullname ,  
                   companyname ,  
                   addressprimarystreet ,  
                   addressprimarysuite ,  
                   addressprimarycity ,  
                   addressprimarystate ,  
                   AddressPrimaryZip ,  
                   addressprimarycountry ,  
                   addressprimaryiscleanstatus ,  
                   AddressPrimaryNCOAStatus ,  
				   AddressPrimaryUpdate , 
                   phoneprimary ,  
                   phoneprimaryiscleanstatus ,  
				   PhonePrimaryUpdate , 
                   EmailPrimary ,  
                   emailprimaryiscleanstatus , 
				   EmailPrimaryUpdate ,  
                   updateddate ,  
                   createddate ,  
                   ssupdateddate ,  
                   sscreateddate ,  
                   dimcustomerid ,  
                   customerstatus ,  
                   customertype ,  
                   lastpurchase ,  
                   isdeleted   
            INTO   #SrcData  
            FROM   dbo.[tmp_stg_Athletics_MDM];  
            UPDATE #SrcData  
            SET    ETL_DeltaHashKey = HASHBYTES(  
                                          'sha2_256' ,  
                                          ISNULL(  
                                              RTRIM(addressprimarycity) ,  
                                              'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(addressprimarycountry) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    addressprimaryiscleanstatus) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(AddressPrimaryNCOAStatus) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(addressprimarystate) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(addressprimarystreet) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(addressprimarysuite) ,  
                       'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(AddressPrimaryZip) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(companyname) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(25), createddate)) ,  
                                                'DBNULL_DATETIME')  
                                          + ISNULL(  
                                                RTRIM(customerstatus) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(customertype) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(10) ,  
                                                        dimcustomerid)) ,  
                                                'DBNULL_INT')  
                                          + ISNULL(  
                                                RTRIM(EmailPrimary) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(emailprimaryiscleanstatus) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(firstname), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(fullname), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(10), isdeleted)) ,  
                                                'DBNULL_BIT')  
                                          + ISNULL(  
                                                RTRIM(lastname), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(25) ,  
                                                        lastpurchase)) ,  
                                                'DBNULL_DATETIME')  
                                          + ISNULL(  
                                                RTRIM(middlename), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(nameiscleanstatus) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(phoneprimary) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(phoneprimaryiscleanstatus) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(RTRIM(prefix), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(sourcesystem) ,  
                                                'DBNULL_TEXT')  
                          + ISNULL(  
                                                RTRIM(ssb_crmsystem_contact_id) ,  
                                                'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(25) ,  
                                                        sscreateddate)) ,  
                                                'DBNULL_DATETIME')  
                                          + ISNULL(RTRIM(ssid), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(25) ,  
                                                        ssupdateddate)) ,  
                                                'DBNULL_DATETIME')  
                                          + ISNULL(RTRIM(suffix), 'DBNULL_TEXT')  
                                          + ISNULL(  
                                                RTRIM(  
                                                    CONVERT(  
                                                        VARCHAR(25), updateddate)) ,  
                                                'DBNULL_DATETIME'));  
            CREATE NONCLUSTERED INDEX IDX_Load_Key  
                ON #SrcData ( dimcustomerid );  
            CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey  
                ON #SrcData ( ETL_DeltaHashKey );  
            MERGE dbo.[tmp_ods_Athletics_MDM] AS myTarget  
            USING (   SELECT *  
                      FROM   #SrcData ) AS mySource  
            ON myTarget.dimcustomerid = mySource.dimcustomerid  
            WHEN MATCHED AND ( ISNULL(mySource.ETL_DeltaHashKey, -1) <> ISNULL(  
                                                                            myTarget.ETL_DeltaHashKey ,  
                                                                            -1)) THEN  
                UPDATE SET myTarget.[ssb_crmsystem_contact_id] = mySource.[ssb_crmsystem_contact_id] ,  
                           myTarget.[sourcesystem] = mySource.[sourcesystem] ,  
                           myTarget.[ssid] = mySource.[ssid] ,  
                           myTarget.[prefix] = mySource.[prefix] ,  
                           myTarget.[firstname] = mySource.[firstname] ,  
                           myTarget.[middlename] = mySource.[middlename] ,  
                           myTarget.[lastname] = mySource.[lastname] ,  
                           myTarget.[suffix] = mySource.[suffix] ,  
                           myTarget.[fullname] = mySource.[fullname] ,  
                           myTarget.[companyname] = mySource.[companyname] ,  
                           myTarget.[nameiscleanstatus] = mySource.[nameiscleanstatus] ,  
                           myTarget.[addressprimarystreet] = mySource.[addressprimarystreet] ,  
                           myTarget.[addressprimarysuite] = mySource.[addressprimarysuite] ,  
                           myTarget.[addressprimarycity] = mySource.[addressprimarycity] ,  
                           myTarget.[addressprimarystate] = mySource.[addressprimarystate] ,  
                           myTarget.[AddressPrimaryZip] = mySource.[AddressPrimaryZip] ,  
                           myTarget.[addressprimarycountry] = mySource.[addressprimarycountry] ,  
                           myTarget.[addressprimaryiscleanstatus] = mySource.[addressprimaryiscleanstatus] ,  
                           myTarget.[AddressPrimaryNCOAStatus] = mySource.[AddressPrimaryNCOAStatus] ,  
						   myTarget.[addressprimaryupdate] = mySource.[AddressPrimaryUpdate] ,
                           myTarget.[phoneprimary] = mySource.[phoneprimary] ,  
                           myTarget.[phoneprimaryiscleanstatus] = mySource.[phoneprimaryiscleanstatus] ,  
						   myTarget.[phoneprimaryupdate] = mySource.[PhonePrimaryUpdate] ,  
                           myTarget.[EmailPrimary] = mySource.[EmailPrimary] ,  
                           myTarget.[emailprimaryiscleanstatus] = mySource.[emailprimaryiscleanstatus] ,  
						   myTarget.[EmailPrimaryupdate] = mySource.[EmailPrimaryupdate] ,  
                           myTarget.[updateddate] = mySource.[updateddate] ,  
                           myTarget.[createddate] = mySource.[createddate] ,  
                           myTarget.[ssupdateddate] = mySource.[ssupdateddate] ,  
                           myTarget.[sscreateddate] = mySource.[sscreateddate] ,  
                           myTarget.[dimcustomerid] = mySource.[dimcustomerid] ,  
                           myTarget.[customerstatus] = mySource.[customerstatus] ,  
                           myTarget.[customertype] = mySource.[customertype] ,  
                           myTarget.[lastpurchase] = mySource.[lastpurchase] ,  
                           myTarget.[isdeleted] = mySource.[isdeleted] ,  
         myTarget.[etl_deltahashkey] = mySource.[ETL_DeltaHashKey]  
            WHEN NOT MATCHED BY TARGET THEN  
                INSERT ( [ssb_crmsystem_contact_id] ,  
                         [sourcesystem] ,  
                         [ssid] ,  
                         [prefix] ,  
                         [firstname] ,  
                         [middlename] ,  
                         [lastname] ,  
                         [suffix] ,  
                         [fullname] ,  
                         [companyname] ,  
                         [nameiscleanstatus] ,  
                         [addressprimarystreet] ,  
                         [addressprimarysuite] ,  
                         [addressprimarycity] ,  
                         [addressprimarystate] ,  
                         [AddressPrimaryZip] ,  
                         [addressprimarycountry] ,  
                         [addressprimaryiscleanstatus] ,  
                         [AddressPrimaryNCOAStatus] ,  
						 [AddressPrimaryUpdate],
                         [phoneprimary] ,  
                         [phoneprimaryiscleanstatus] ,
						 [PhonePrimaryUpdate] ,   
                         [EmailPrimary] ,  
                         [emailprimaryiscleanstatus] ,
						 [EmailPrimaryUpdate] ,   
                         [updateddate] ,  
                         [createddate] ,  
                         [ssupdateddate] ,  
                         [sscreateddate] ,  
                         [dimcustomerid] ,  
                         [customerstatus] ,  
                         [customertype] ,  
                         [lastpurchase] ,  
                         [isdeleted] ,  
       etl_deltahashkey )  
                VALUES ( mySource.[ssb_crmsystem_contact_id] ,  
                         mySource.[sourcesystem], mySource.[ssid] ,  
                         mySource.[prefix], mySource.[firstname] ,  
                         mySource.[middlename], mySource.[lastname] ,  
                         mySource.[suffix], mySource.[fullname] ,  
                         mySource.[companyname] ,  
                         mySource.[nameiscleanstatus] ,  
                         mySource.[addressprimarystreet] ,  
                         mySource.[addressprimarysuite] ,  
                         mySource.[addressprimarycity] ,  
                         mySource.[addressprimarystate] ,  
                         mySource.[AddressPrimaryZip] ,  
                         mySource.[addressprimarycountry] ,  
                         mySource.[addressprimaryiscleanstatus] ,  
                         mySource.[AddressPrimaryNCOAStatus] ,  
						 mysource.[AddressPrimaryUpdate] ,
                         mySource.[phoneprimary] ,  
                         mySource.[phoneprimaryiscleanstatus] ,  
						 mysource.[phoneprimaryupdate] , 
                         mySource.[EmailPrimary] ,  
                         mySource.[emailprimaryiscleanstatus] ,  
						 mysource.[emailprimaryupdate] , 
                         mySource.[updateddate], mySource.[createddate] ,  
                         mySource.[ssupdateddate], mySource.[sscreateddate] ,  
                         mySource.[dimcustomerid], mySource.[customerstatus] ,  
                         mySource.[customertype], mySource.[lastpurchase] ,  
                         mySource.[isdeleted], mySource.ETL_DeltaHashKey);  
         DECLARE @MergeInsertRowCount INT = ISNULL(  
                                               (   SELECT CONVERT(  
                                                              VARCHAR ,  
                                                              COUNT(*))  
                                                   FROM   dbo.[tmp_ods_Athletics_MDM]  
                                                   WHERE  ETL_CreatedDate >= @RunTime  
                                                          AND ETL_UpdatedDate = ETL_CreatedDate ) ,  
                                               '0');  
            DECLARE @MergeUpdateRowCount INT = ISNULL(  
                                               (   SELECT CONVERT(  
                                                              VARCHAR ,  
                                                              COUNT(*))  
                                                   FROM   dbo.[tmp_ods_Athletics_MDM]  
                                                   WHERE  ETL_UpdatedDate >= @RunTime  
                                                          AND ETL_UpdatedDate > ETL_CreatedDate ) ,  
                                               '0');  
        END TRY  
        BEGIN CATCH  
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY();  
            DECLARE @ErrorState INT = ERROR_STATE();  
            PRINT @ErrorMessage;  
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);  
        END CATCH;  
    END;


	EXEC merge_athletics_mdm

select * from dbo.tmp_stg_Athletics_MDM
select * from dbo.tmp_ods_Athletics_MDM
GO
