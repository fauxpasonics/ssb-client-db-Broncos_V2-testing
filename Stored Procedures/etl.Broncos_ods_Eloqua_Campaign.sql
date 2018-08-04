SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Broncos_ods_Eloqua_Campaign]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM src.Eloqua_Campaign),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Name, ActualCost, BudgetedCost, CampaignType, CrmId, EndAt, EndValues, IsMemberAllowedReEntry, IsReadOnly, Product, Region, StartAt, CreatedAt, CreatedBy, AccessedAt, CurrentStatus, Depth, UpdatedAt, UpdatedBy, Permissions, ScheduledFor, SourceTemplatedId, FolderId, Campaign_Type, Five, Four, Three, Two, CLREndDate
INTO #SrcData
FROM src.Eloqua_Campaign

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),AccessedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),ActualCost)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),BudgetedCost)),'DBNULL_NUMBER') + ISNULL(RTRIM(Campaign_Type),'DBNULL_TEXT') + ISNULL(RTRIM(CampaignType),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),CLREndDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CrmId),'DBNULL_TEXT') + ISNULL(RTRIM(CurrentStatus),'DBNULL_TEXT') + ISNULL(RTRIM(Depth),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),EndAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(EndValues),'DBNULL_TEXT') + ISNULL(RTRIM(Five),'DBNULL_TEXT') + ISNULL(RTRIM(FolderId),'DBNULL_TEXT') + ISNULL(RTRIM(Four),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsMemberAllowedReEntry)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsReadOnly)),'DBNULL_BIT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(Permissions),'DBNULL_TEXT') + ISNULL(RTRIM(Product),'DBNULL_TEXT') + ISNULL(RTRIM(Region),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ScheduledFor)),'DBNULL_DATETIME') + ISNULL(RTRIM(SourceTemplatedId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),StartAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(Three),'DBNULL_TEXT') + ISNULL(RTRIM(Two),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(UpdatedBy),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ods.Eloqua_Campaign AS myTarget

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
     ,myTarget.[ActualCost] = mySource.[ActualCost]
     ,myTarget.[BudgetedCost] = mySource.[BudgetedCost]
     ,myTarget.[CampaignType] = mySource.[CampaignType]
     ,myTarget.[CrmId] = mySource.[CrmId]
     ,myTarget.[EndAt] = mySource.[EndAt]
     ,myTarget.[EndValues] = mySource.[EndValues]
     ,myTarget.[IsMemberAllowedReEntry] = mySource.[IsMemberAllowedReEntry]
     ,myTarget.[IsReadOnly] = mySource.[IsReadOnly]
     ,myTarget.[Product] = mySource.[Product]
     ,myTarget.[Region] = mySource.[Region]
     ,myTarget.[StartAt] = mySource.[StartAt]
     ,myTarget.[CreatedAt] = mySource.[CreatedAt]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[AccessedAt] = mySource.[AccessedAt]
     ,myTarget.[CurrentStatus] = mySource.[CurrentStatus]
     ,myTarget.[Depth] = mySource.[Depth]
     ,myTarget.[UpdatedAt] = mySource.[UpdatedAt]
     ,myTarget.[UpdatedBy] = mySource.[UpdatedBy]
     ,myTarget.[Permissions] = mySource.[Permissions]
     ,myTarget.[ScheduledFor] = mySource.[ScheduledFor]
     ,myTarget.[SourceTemplatedId] = mySource.[SourceTemplatedId]
     ,myTarget.[FolderId] = mySource.[FolderId]
     ,myTarget.[Campaign_Type] = mySource.[Campaign_Type]
     ,myTarget.[Five] = mySource.[Five]
     ,myTarget.[Four] = mySource.[Four]
     ,myTarget.[Three] = mySource.[Three]
     ,myTarget.[Two] = mySource.[Two]
     ,myTarget.[CLREndDate] = mySource.[CLREndDate]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[Name]
     ,[ActualCost]
     ,[BudgetedCost]
     ,[CampaignType]
     ,[CrmId]
     ,[EndAt]
     ,[EndValues]
     ,[IsMemberAllowedReEntry]
     ,[IsReadOnly]
     ,[Product]
     ,[Region]
     ,[StartAt]
     ,[CreatedAt]
     ,[CreatedBy]
     ,[AccessedAt]
     ,[CurrentStatus]
     ,[Depth]
     ,[UpdatedAt]
     ,[UpdatedBy]
     ,[Permissions]
     ,[ScheduledFor]
     ,[SourceTemplatedId]
     ,[FolderId]
     ,[Campaign_Type]
     ,[Five]
     ,[Four]
     ,[Three]
     ,[Two]
     ,[CLREndDate]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Name]
     ,mySource.[ActualCost]
     ,mySource.[BudgetedCost]
     ,mySource.[CampaignType]
     ,mySource.[CrmId]
     ,mySource.[EndAt]
     ,mySource.[EndValues]
     ,mySource.[IsMemberAllowedReEntry]
     ,mySource.[IsReadOnly]
     ,mySource.[Product]
     ,mySource.[Region]
     ,mySource.[StartAt]
     ,mySource.[CreatedAt]
     ,mySource.[CreatedBy]
     ,mySource.[AccessedAt]
     ,mySource.[CurrentStatus]
     ,mySource.[Depth]
     ,mySource.[UpdatedAt]
     ,mySource.[UpdatedBy]
     ,mySource.[Permissions]
     ,mySource.[ScheduledFor]
     ,mySource.[SourceTemplatedId]
     ,mySource.[FolderId]
     ,mySource.[Campaign_Type]
     ,mySource.[Five]
     ,mySource.[Four]
     ,mySource.[Three]
     ,mySource.[Two]
     ,mySource.[CLREndDate]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Eloqua_Campaign WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Eloqua_Campaign WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
