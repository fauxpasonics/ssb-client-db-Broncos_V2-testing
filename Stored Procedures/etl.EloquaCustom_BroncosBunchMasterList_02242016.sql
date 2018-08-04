SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[EloquaCustom_BroncosBunchMasterList_02242016]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM src.EloquaCustom_BroncosBunchMasterList),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)



SELECT    max(ETL_ID) AS ETL_ID,CAST(NULL AS BINARY(32)) ETL_DeltaHashKey,ETL_IsDeleted, ETL_DeletedDate, Id, Unique_ID1, Date_of_Birth1, Parents_Email_Address1, Status1, Sign_Up_Date1, Child_Last_Name1, Child_First_Name1
INTO #SrcData
FROM src.EloquaCustom_BroncosBunchMasterList_02242016 
GROUP BY ETL_DeltaHashKey,ETL_IsDeleted, ETL_DeletedDate, Id, Unique_ID1, Date_of_Birth1,
 Parents_Email_Address1, Status1, Sign_Up_Date1, Child_Last_Name1, Child_First_Name1

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(Child_First_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(Child_Last_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Date_of_Birth1,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_DeletedDate)),'DBNULL_DATETIME')  + ISNULL(RTRIM(CONVERT(varchar(10),ETL_IsDeleted)),'DBNULL_BIT')  + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(Parents_Email_Address1),'DBNULL_TEXT') + ISNULL(RTRIM(Sign_Up_Date1),'DBNULL_TEXT') + ISNULL(RTRIM(Status1),'DBNULL_TEXT') + ISNULL(RTRIM(Unique_ID1),'DBNULL_TEXT'))



CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ods.EloquaCustom_BroncosBunchMasterList_02242016 AS myTarget

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
     ,myTarget.[Unique_ID1] = mySource.[Unique_ID1]
     ,myTarget.[Date_of_Birth1] = mySource.[Date_of_Birth1]
     ,myTarget.[Parents_Email_Address1] = mySource.[Parents_Email_Address1]
     ,myTarget.[Status1] = mySource.[Status1]
     ,myTarget.[Sign_Up_Date1] = mySource.[Sign_Up_Date1]
     ,myTarget.[Child_Last_Name1] = mySource.[Child_Last_Name1]
     ,myTarget.[Child_First_Name1] = mySource.[Child_First_Name1]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[Unique_ID1]
     ,[Date_of_Birth1]
     ,[Parents_Email_Address1]
     ,[Status1]
     ,[Sign_Up_Date1]
     ,[Child_Last_Name1]
     ,[Child_First_Name1]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Unique_ID1]
     ,mySource.[Date_of_Birth1]
     ,mySource.[Parents_Email_Address1]
     ,mySource.[Status1]
     ,mySource.[Sign_Up_Date1]
     ,mySource.[Child_Last_Name1]
     ,mySource.[Child_First_Name1]
     )
;



DECLARE @MergeInsertRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.EloquaCustom_BroncosBunchMasterList_02242016 WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.EloquaCustom_BroncosBunchMasterList_02242016 WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
