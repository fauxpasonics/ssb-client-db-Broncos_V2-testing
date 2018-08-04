SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Broncos_ods_Eloqua_ContactField]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM [src].[Eloqua_ContactField]),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Name, UpdateType, CheckedValue, DataType, DefaultValue, Description, DisplayType, FolderId, InternalName, IsReadOnly, IsRequired, IsStandard, OptionListId, OutputFormatId, ScheduledFor, SourceTemplatedId, UncheckedValue, Permissions, CreatedAt, CreatedBy, AccessedAt, CurrentStatus, Depth, UpdatedAt, UpdatedBy
INTO #SrcData
FROM [src].[Eloqua_ContactField]

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),AccessedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CheckedValue),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CurrentStatus),'DBNULL_TEXT') + ISNULL(RTRIM(DataType),'DBNULL_TEXT') + ISNULL(RTRIM(DefaultValue),'DBNULL_TEXT') + ISNULL(RTRIM(Depth),'DBNULL_TEXT') + ISNULL(RTRIM(Description),'DBNULL_TEXT') + ISNULL(RTRIM(DisplayType),'DBNULL_TEXT') + ISNULL(RTRIM(FolderId),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(InternalName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsReadOnly)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsRequired)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsStandard)),'DBNULL_BIT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(OptionListId),'DBNULL_TEXT') + ISNULL(RTRIM(OutputFormatId),'DBNULL_TEXT') + ISNULL(RTRIM(Permissions),'DBNULL_TEXT') + ISNULL(RTRIM(ScheduledFor),'DBNULL_TEXT') + ISNULL(RTRIM(SourceTemplatedId),'DBNULL_TEXT') + ISNULL(RTRIM(UncheckedValue),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(UpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(UpdateType),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE [ods].[Eloqua_ContactField] AS myTarget

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
     ,myTarget.[UpdateType] = mySource.[UpdateType]
     ,myTarget.[CheckedValue] = mySource.[CheckedValue]
     ,myTarget.[DataType] = mySource.[DataType]
     ,myTarget.[DefaultValue] = mySource.[DefaultValue]
     ,myTarget.[Description] = mySource.[Description]
     ,myTarget.[DisplayType] = mySource.[DisplayType]
     ,myTarget.[FolderId] = mySource.[FolderId]
     ,myTarget.[InternalName] = mySource.[InternalName]
     ,myTarget.[IsReadOnly] = mySource.[IsReadOnly]
     ,myTarget.[IsRequired] = mySource.[IsRequired]
     ,myTarget.[IsStandard] = mySource.[IsStandard]
     ,myTarget.[OptionListId] = mySource.[OptionListId]
     ,myTarget.[OutputFormatId] = mySource.[OutputFormatId]
     ,myTarget.[ScheduledFor] = mySource.[ScheduledFor]
     ,myTarget.[SourceTemplatedId] = mySource.[SourceTemplatedId]
     ,myTarget.[UncheckedValue] = mySource.[UncheckedValue]
     ,myTarget.[Permissions] = mySource.[Permissions]
     ,myTarget.[CreatedAt] = mySource.[CreatedAt]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[AccessedAt] = mySource.[AccessedAt]
     ,myTarget.[CurrentStatus] = mySource.[CurrentStatus]
     ,myTarget.[Depth] = mySource.[Depth]
     ,myTarget.[UpdatedAt] = mySource.[UpdatedAt]
     ,myTarget.[UpdatedBy] = mySource.[UpdatedBy]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[Name]
     ,[UpdateType]
     ,[CheckedValue]
     ,[DataType]
     ,[DefaultValue]
     ,[Description]
     ,[DisplayType]
     ,[FolderId]
     ,[InternalName]
     ,[IsReadOnly]
     ,[IsRequired]
     ,[IsStandard]
     ,[OptionListId]
     ,[OutputFormatId]
     ,[ScheduledFor]
     ,[SourceTemplatedId]
     ,[UncheckedValue]
     ,[Permissions]
     ,[CreatedAt]
     ,[CreatedBy]
     ,[AccessedAt]
     ,[CurrentStatus]
     ,[Depth]
     ,[UpdatedAt]
     ,[UpdatedBy]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Name]
     ,mySource.[UpdateType]
     ,mySource.[CheckedValue]
     ,mySource.[DataType]
     ,mySource.[DefaultValue]
     ,mySource.[Description]
     ,mySource.[DisplayType]
     ,mySource.[FolderId]
     ,mySource.[InternalName]
     ,mySource.[IsReadOnly]
     ,mySource.[IsRequired]
     ,mySource.[IsStandard]
     ,mySource.[OptionListId]
     ,mySource.[OutputFormatId]
     ,mySource.[ScheduledFor]
     ,mySource.[SourceTemplatedId]
     ,mySource.[UncheckedValue]
     ,mySource.[Permissions]
     ,mySource.[CreatedAt]
     ,mySource.[CreatedBy]
     ,mySource.[AccessedAt]
     ,mySource.[CurrentStatus]
     ,mySource.[Depth]
     ,mySource.[UpdatedAt]
     ,mySource.[UpdatedBy]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_ContactField] WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_ContactField] WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
