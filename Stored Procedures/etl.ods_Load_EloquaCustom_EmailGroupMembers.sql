SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [etl].[ods_Load_EloquaCustom_EmailGroupMembers]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = NULL
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     svcETL
Date:     01/27/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId UNIQUEIDENTIFIER = NEWID();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM src.EloquaCustom_EmailGroupMembers),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 AS OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

/*Extract Options, default values set if the option is not specified*/	
DECLARE @DisableInsert NVARCHAR(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
DECLARE @DisableUpdate NVARCHAR(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
DECLARE @DisableDelete NVARCHAR(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')


BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
, EmailGroup, ContactId, EmailAddress, FirstName, LastName, Title, Company, BusinessPhone, [Address], City, Salesperson
INTO #SrcData
FROM (
	SELECT EmailGroup, ContactId, EmailAddress, FirstName, LastName, Title, Company, BusinessPhone, [Address], City, Salesperson
		, ROW_NUMBER() OVER(PARTITION BY ContactId, EmailGroup ORDER BY ETL_ID) RowRank
	FROM src.EloquaCustom_EmailGroupMembers
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM([Address]),'DBNULL_TEXT')
											+ ISNULL(RTRIM(BusinessPhone),'DBNULL_TEXT') 
											+ ISNULL(RTRIM(City),'DBNULL_TEXT') 
											+ ISNULL(RTRIM(Company),'DBNULL_TEXT') 
											+ ISNULL(RTRIM(ContactId),'DBNULL_INT')
											+ ISNULL(RTRIM(EmailAddress),'DBNULL_TEXT')
											+ ISNULL(RTRIM(EmailGroup),'DBNULL_TEXT')
											+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
											+ ISNULL(RTRIM(LastName),'DBNULL_TEXT')
											+ ISNULL(RTRIM(Salesperson),'DBNULL_TEXT')
											+ ISNULL(RTRIM(Title),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ContactId, EmailGroup)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId


MERGE ods.EloquaCustom_EmailGroupMembers AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.ContactId = mySource.ContactId
AND myTarget.EmailGroup = mySource.EmailGroup

WHEN MATCHED
--	AND @DisableUpdate = 'false'
AND (ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	OR myTarget.ETL_IsDeleted = 1)

THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_IsDeleted] = 0
     ,myTarget.[ETL_DeletedDate] = NULL
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[EmailAddress] = myTarget.[EmailAddress]
	 ,myTarget.[FirstName] = mySource.[FirstName]
	 ,myTarget.[LastName] = mySource.[LastName]
	 ,myTarget.[Title] = mySource.[Title]
	 ,myTarget.[Company] = mySource.[Company]
	 ,myTarget.[BusinessPhone] = mySource.[BusinessPhone]
	 ,myTarget.[Address] = mySource.[Address]
	 ,myTarget.[City] = mySource.[City]
	 ,myTarget.[Salesperson] = mySource.[Salesperson]
     
WHEN NOT MATCHED BY SOURCE
AND myTarget.ETL_IsDeleted = 0
--AND @DisableDelete = 'false'
THEN UPDATE SET
		myTarget.[ETL_IsDeleted] = 1
		, myTarget.[ETL_DeletedDate] = @RunTime

WHEN NOT MATCHED BY TARGET --AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
	 ,[EmailGroup]
     ,[ContactId]
	 ,[EmailAddress]
	 ,[FirstName]
	 ,[LastName]
	 ,[Title]
	 ,[Company]
	 ,[BusinessPhone]
	 ,[Address]
	 ,[City]
	 ,[Salesperson]
     )
VALUES
     (@RunTime	--ETL_CreatedDate
     ,@RunTime	--ETL_UpdateddDate
     ,0			--ETL_IsDeleted
     ,NULL		--ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.[EmailGroup]
	 ,mySource.[ContactId]
	 ,mySource.[EmailAddress]
	 ,mySource.[FirstName]
	 ,mySource.[LastName]
	 ,mySource.[Title]
	 ,mySource.[Company]
	 ,mySource.[BusinessPhone]
	 ,mySource.[Address]
	 ,mySource.[City]
	 ,mySource.[Salesperson]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.EloquaCustom_EmailGroupMembers WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.EloquaCustom_EmailGroupMembers WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END













GO
