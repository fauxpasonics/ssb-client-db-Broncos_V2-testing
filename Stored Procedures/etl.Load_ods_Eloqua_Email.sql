SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ods_Eloqua_Email]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM [src].[Eloqua_Email]),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Name, EmailGroupId, HtmlContent, IsPlainTextEditable, IsTracked, PlainText, BouncebackEmail, ReplyToEmail, ReplyToName, SenderEmail, SenderName, SenderPlainTextOnly, Subject, Description, FolderId, Permissions, CreatedAt, CreatedBy, AccessedAt, CurrentStatus, Depth, UpdatedAt, UpdatedBy
INTO #SrcData
FROM [src].[Eloqua_Email]
-- DROP TABLE [#SrcData]
UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),AccessedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(BouncebackEmail),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CurrentStatus),'DBNULL_TEXT') + ISNULL(RTRIM(Depth),'DBNULL_TEXT') + ISNULL(RTRIM(Description),'DBNULL_TEXT') + ISNULL(RTRIM(EmailGroupId),'DBNULL_TEXT') + ISNULL(RTRIM(FolderId),'DBNULL_TEXT') + ISNULL(RTRIM(RIGHT(HtmlContent,1000)),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsPlainTextEditable)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsTracked)),'DBNULL_BIT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(Permissions),'DBNULL_TEXT')  + ISNULL(RTRIM(ReplyToEmail),'DBNULL_TEXT') + ISNULL(RTRIM(ReplyToName),'DBNULL_TEXT') + ISNULL(RTRIM(SenderEmail),'DBNULL_TEXT') + ISNULL(RTRIM(SenderName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SenderPlainTextOnly)),'DBNULL_BIT') + ISNULL(RTRIM(Subject),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(UpdatedBy),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE [ods].[Eloqua_Email] AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ID = mySource.ID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime,
     myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ID] = mySource.[ID]
     ,myTarget.[Name] = mySource.[Name]
     ,myTarget.[EmailGroupId] = mySource.[EmailGroupId]
     ,myTarget.[HtmlContent] = mySource.[HtmlContent]
     ,myTarget.[IsPlainTextEditable] = mySource.[IsPlainTextEditable]
     ,myTarget.[IsTracked] = mySource.[IsTracked]
     ,myTarget.[PlainText] = mySource.[PlainText]
     ,myTarget.[BouncebackEmail] = mySource.[BouncebackEmail]
     ,myTarget.[ReplyToEmail] = mySource.[ReplyToEmail]
     ,myTarget.[ReplyToName] = mySource.[ReplyToName]
     ,myTarget.[SenderEmail] = mySource.[SenderEmail]
     ,myTarget.[SenderName] = mySource.[SenderName]
     ,myTarget.[SenderPlainTextOnly] = mySource.[SenderPlainTextOnly]
     ,myTarget.[Subject] = mySource.[Subject]
     ,myTarget.[Description] = mySource.[Description]
     ,myTarget.[FolderId] = mySource.[FolderId]
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
     ,[EmailGroupId]
     ,[HtmlContent]
     ,[IsPlainTextEditable]
     ,[IsTracked]
     ,[PlainText]
     ,[BouncebackEmail]
     ,[ReplyToEmail]
     ,[ReplyToName]
     ,[SenderEmail]
     ,[SenderName]
     ,[SenderPlainTextOnly]
     ,[Subject]
     ,[Description]
     ,[FolderId]
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
     (
	 @RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Name]
     ,mySource.[EmailGroupId]
     ,mySource.[HtmlContent]
     ,mySource.[IsPlainTextEditable]
     ,mySource.[IsTracked]
     ,mySource.[PlainText]
     ,mySource.[BouncebackEmail]
     ,mySource.[ReplyToEmail]
     ,mySource.[ReplyToName]
     ,mySource.[SenderEmail]
     ,mySource.[SenderName]
     ,mySource.[SenderPlainTextOnly]
     ,mySource.[Subject]
     ,mySource.[Description]
     ,mySource.[FolderId]
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



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_Email] WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_Email] WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
