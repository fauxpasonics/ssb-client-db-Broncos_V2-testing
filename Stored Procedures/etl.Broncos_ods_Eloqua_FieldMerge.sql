SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Broncos_ods_Eloqua_FieldMerge]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\shegde
Date:     06/17/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM [src].[Eloqua_FieldMerge]),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Name, Description, FolderId, ScheduledFor, SourceTemplatedId, Permissions, CreatedAt, CreatedBy, AccessedAt, CurrentStatus, UpdatedAt, UpdatedBy, Syntax, DefaultValue, ContactFieldId, AccountFieldId, EventId, EventFieldId, EventSessionFieldId, MergeType
INTO #SrcData
FROM [src].[Eloqua_FieldMerge]

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),AccessedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(AccountFieldId),'DBNULL_TEXT') + ISNULL(RTRIM(ContactFieldId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CurrentStatus),'DBNULL_TEXT') + ISNULL(RTRIM(DefaultValue),'DBNULL_TEXT') + ISNULL(RTRIM(Description),'DBNULL_TEXT') + ISNULL(RTRIM(EventFieldId),'DBNULL_TEXT') + ISNULL(RTRIM(EventId),'DBNULL_TEXT') + ISNULL(RTRIM(EventSessionFieldId),'DBNULL_TEXT') + ISNULL(RTRIM(FolderId),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(MergeType),'DBNULL_TEXT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(Permissions),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ScheduledFor)),'DBNULL_DATETIME') + ISNULL(RTRIM(SourceTemplatedId),'DBNULL_TEXT') + ISNULL(RTRIM(Syntax),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(UpdatedBy),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE [ods].[Eloqua_FieldMerge] AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ID = mySource.ID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ID] = mySource.[ID]
     ,myTarget.[Name] = mySource.[Name]
     ,myTarget.[Description] = mySource.[Description]
     ,myTarget.[FolderId] = mySource.[FolderId]
     ,myTarget.[ScheduledFor] = mySource.[ScheduledFor]
     ,myTarget.[SourceTemplatedId] = mySource.[SourceTemplatedId]
     ,myTarget.[Permissions] = mySource.[Permissions]
     ,myTarget.[CreatedAt] = mySource.[CreatedAt]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[AccessedAt] = mySource.[AccessedAt]
     ,myTarget.[CurrentStatus] = mySource.[CurrentStatus]
     ,myTarget.[UpdatedAt] = mySource.[UpdatedAt]
     ,myTarget.[UpdatedBy] = mySource.[UpdatedBy]
     ,myTarget.[Syntax] = mySource.[Syntax]
     ,myTarget.[DefaultValue] = mySource.[DefaultValue]
     ,myTarget.[ContactFieldId] = mySource.[ContactFieldId]
     ,myTarget.[AccountFieldId] = mySource.[AccountFieldId]
     ,myTarget.[EventId] = mySource.[EventId]
     ,myTarget.[EventFieldId] = mySource.[EventFieldId]
     ,myTarget.[EventSessionFieldId] = mySource.[EventSessionFieldId]
     ,myTarget.[MergeType] = mySource.[MergeType]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[Name]
     ,[Description]
     ,[FolderId]
     ,[ScheduledFor]
     ,[SourceTemplatedId]
     ,[Permissions]
     ,[CreatedAt]
     ,[CreatedBy]
     ,[AccessedAt]
     ,[CurrentStatus]
     ,[UpdatedAt]
     ,[UpdatedBy]
     ,[Syntax]
     ,[DefaultValue]
     ,[ContactFieldId]
     ,[AccountFieldId]
     ,[EventId]
     ,[EventFieldId]
     ,[EventSessionFieldId]
     ,[MergeType]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Name]
     ,mySource.[Description]
     ,mySource.[FolderId]
     ,mySource.[ScheduledFor]
     ,mySource.[SourceTemplatedId]
     ,mySource.[Permissions]
     ,mySource.[CreatedAt]
     ,mySource.[CreatedBy]
     ,mySource.[AccessedAt]
     ,mySource.[CurrentStatus]
     ,mySource.[UpdatedAt]
     ,mySource.[UpdatedBy]
     ,mySource.[Syntax]
     ,mySource.[DefaultValue]
     ,mySource.[ContactFieldId]
     ,mySource.[AccountFieldId]
     ,mySource.[EventId]
     ,mySource.[EventFieldId]
     ,mySource.[EventSessionFieldId]
     ,mySource.[MergeType]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_FieldMerge] WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_FieldMerge] WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END

GO
