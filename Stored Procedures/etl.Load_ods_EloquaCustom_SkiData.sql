SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Load_ods_EloquaCustom_SkiData]
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
Date:     06/24/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId UNIQUEIDENTIFIER = NEWID();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM [src].[EloquaCustom_SkiData]),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Points_Available1, Rank1, Total_Points_Earned1, Last_Activity_Date1, Ticket_Account_ID1, Last_Name1, First_Name1, Email_Address1, Username1, UserID1
INTO #SrcData
FROM [src].[EloquaCustom_SkiData]

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(Email_Address1),'DBNULL_TEXT') + ISNULL(RTRIM(First_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(Last_Activity_Date1),'DBNULL_TEXT') + ISNULL(RTRIM(Last_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(Points_Available1),'DBNULL_TEXT') + ISNULL(RTRIM(Rank1),'DBNULL_TEXT') + ISNULL(RTRIM(Ticket_Account_ID1),'DBNULL_TEXT') + ISNULL(RTRIM(Total_Points_Earned1),'DBNULL_TEXT') + ISNULL(RTRIM(UserID1),'DBNULL_TEXT') + ISNULL(RTRIM(Username1),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE [ods].[EloquaCustom_SkiData] AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.ID = mySource.ID

WHEN MATCHED
AND (ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	OR myTarget.ETL_IsDeleted = 1)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
	 ,myTarget.[ETL_IsDeleted] = 0
	 ,myTarget.[ETL_DeletedDate] = NULL
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ID] = mySource.[ID]
     ,myTarget.[Points_Available1] = mySource.[Points_Available1]
     ,myTarget.[Rank1] = mySource.[Rank1]
     ,myTarget.[Total_Points_Earned1] = mySource.[Total_Points_Earned1]
     ,myTarget.[Last_Activity_Date1] = mySource.[Last_Activity_Date1]
     ,myTarget.[Ticket_Account_ID1] = mySource.[Ticket_Account_ID1]
     ,myTarget.[Last_Name1] = mySource.[Last_Name1]
     ,myTarget.[First_Name1] = mySource.[First_Name1]
     ,myTarget.[Email_Address1] = mySource.[Email_Address1]
     ,myTarget.[Username1] = mySource.[Username1]
     ,myTarget.[UserID1] = mySource.[UserID1]


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
     ,[ID]
     ,[Points_Available1]
     ,[Rank1]
     ,[Total_Points_Earned1]
     ,[Last_Activity_Date1]
     ,[Ticket_Account_ID1]
     ,[Last_Name1]
     ,[First_Name1]
     ,[Email_Address1]
     ,[Username1]
     ,[UserID1]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Points_Available1]
     ,mySource.[Rank1]
     ,mySource.[Total_Points_Earned1]
     ,mySource.[Last_Activity_Date1]
     ,mySource.[Ticket_Account_ID1]
     ,mySource.[Last_Name1]
     ,mySource.[First_Name1]
     ,mySource.[Email_Address1]
     ,mySource.[Username1]
     ,mySource.[UserID1]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[EloquaCustom_SkiData] WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[EloquaCustom_SkiData] WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
