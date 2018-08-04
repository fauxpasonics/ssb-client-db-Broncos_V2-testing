SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[Load_ods_EloquaCustom_CrushMembers]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = NULL
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\shegde
Date:     12/15/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM src.EloquaCustom_CrushMembers),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, EmailAddress, DataCardExternalId, DataCardCreatedAt, DataCardUpdatedAt
INTO #SrcData
FROM src.EloquaCustom_CrushMembers

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(DataCardCreatedAt),'DBNULL_DATE') + ISNULL(RTRIM(DataCardExternalId),'DBNULL_TEXT') + ISNULL(RTRIM(DataCardUpdatedAt),'DBNULL_DATE') + ISNULL(RTRIM(EmailAddress),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (DataCardExternalId)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ods.EloquaCustom_CrushMembers AS myTarget
USING #SrcData AS mySource
ON myTarget.DataCardExternalId = mySource.DataCardExternalId

WHEN MATCHED
AND (ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	OR myTarget.ETL_IsDeleted = 1)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
	 ,myTarget.[ETL_IsDeleted] = 0
	 ,myTarget.[ETL_DeletedDate] = NULL
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[EmailAddress] = mySource.[EmailAddress]
	 ,myTarget.[DataCardCreatedAt] = mySource.[DataCardCreatedAt]
	 ,myTarget.[DataCardUpdatedAt] = mySource.[DataCardUpdatedAt]


WHEN NOT MATCHED BY SOURCE
AND myTarget.ETL_IsDeleted = 0
THEN UPDATE SET
		myTarget.[ETL_IsDeleted] = 1
		,myTarget.[ETL_DeletedDate] = @RunTime

    
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[EmailAddress]
     ,[DataCardExternalId]
	 ,[DataCardCreatedAt]
	 ,[DataCardUpdatedAt]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[EmailAddress]
     ,mySource.[DataCardExternalId]
	 ,mySource.[DataCardCreatedAt]
	 ,mySource.[DataCardUpdatedAt]
     )
;



DECLARE @MergeInsertRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.EloquaCustom_CrushMembers WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.EloquaCustom_CrushMembers WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END






GO
