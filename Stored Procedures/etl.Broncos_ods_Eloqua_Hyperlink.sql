SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Broncos_ods_Eloqua_Hyperlink]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM [src].[Eloqua_Hyperlink]),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Name, IsSystem, Description, UpdatedAt, UpdatedBy, FolderId, CreatedAt, CreatedBy, Href, HyperlinkType
INTO #SrcData
FROM [src].[Eloqua_Hyperlink]

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(Description),'DBNULL_TEXT') + ISNULL(RTRIM(FolderId),'DBNULL_TEXT') + ISNULL(RTRIM(Href),'DBNULL_TEXT') + ISNULL(RTRIM(HyperlinkType),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsSystem)),'DBNULL_BIT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(UpdatedBy),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE [ods].[Eloqua_Hyperlink] AS myTarget

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
     ,myTarget.[IsSystem] = mySource.[IsSystem]
     ,myTarget.[Description] = mySource.[Description]
     ,myTarget.[UpdatedAt] = mySource.[UpdatedAt]
     ,myTarget.[UpdatedBy] = mySource.[UpdatedBy]
     ,myTarget.[FolderId] = mySource.[FolderId]
     ,myTarget.[CreatedAt] = mySource.[CreatedAt]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[Href] = mySource.[Href]
     ,myTarget.[HyperlinkType] = mySource.[HyperlinkType]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[Name]
     ,[IsSystem]
     ,[Description]
     ,[UpdatedAt]
     ,[UpdatedBy]
     ,[FolderId]
     ,[CreatedAt]
     ,[CreatedBy]
     ,[Href]
     ,[HyperlinkType]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Name]
     ,mySource.[IsSystem]
     ,mySource.[Description]
     ,mySource.[UpdatedAt]
     ,mySource.[UpdatedBy]
     ,mySource.[FolderId]
     ,mySource.[CreatedAt]
     ,mySource.[CreatedBy]
     ,mySource.[Href]
     ,mySource.[HyperlinkType]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_Hyperlink] WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_Hyperlink] WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
