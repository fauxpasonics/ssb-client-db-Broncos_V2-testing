SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ods_Load_Fanatics_Orders]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = NULL
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     03/15/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM src.Fanatics_Orders),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, Order_ID, Client_First_Name, Client_Last_Name, Client_Email, EmailOptIn, Client_ID, OrderDate, ProductCategory, ProductSubCategory, ProductID, ProductName, QtySold, UnitPrice, OrderDiscountTotal, OrderGrossSubTotal, OrderTaxableSubTotal, OrderNonTaxableSubTotal, OrderTaxTotal, OrderNetTotal, OrderShipTotal, Total_Of_Sale_Paid_By_Account_Order, OrderPromo, ShipAddress0, ShipAddress1, ShipAddress2, ShipAddressCity, ShipAddressState, ShipAddressCounty, ShipAddressZip, ShipAddressTel, ShipAddressAttention, BillAddress0, BillAddress1, BillAddress2, BillAddressCity, BillAddressState, BilAddressCountry, BillAddressZip, IsTeamShop
INTO #SrcData
FROM (SELECT Order_ID, Client_First_Name, Client_Last_Name, Client_Email, EmailOptIn, Client_ID, OrderDate, ProductCategory, ProductSubCategory, ProductID, ProductName, QtySold, UnitPrice, OrderDiscountTotal, OrderGrossSubTotal, OrderTaxableSubTotal, OrderNonTaxableSubTotal, OrderTaxTotal, OrderNetTotal, OrderShipTotal, Total_Of_Sale_Paid_By_Account_Order, OrderPromo, ShipAddress0, ShipAddress1, ShipAddress2, ShipAddressCity, ShipAddressState, ShipAddressCounty, ShipAddressZip, ShipAddressTel, ShipAddressAttention, BillAddress0, BillAddress1, BillAddress2, BillAddressCity, BillAddressState, BilAddressCountry, BillAddressZip, IsTeamShop,
		ROW_NUMBER() OVER (PARTITION BY Order_Id, ProductID, QtySold ORDER BY ETL_ID) AS RowNum
		FROM src.Fanatics_Orders) A
WHERE RowNum = 1
;

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(BilAddressCountry),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddress0),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddress1),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddress2),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressCity),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressState),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressZip),'DBNULL_TEXT') + ISNULL(RTRIM(Client_Email),'DBNULL_TEXT') + ISNULL(RTRIM(Client_First_Name),'DBNULL_TEXT') + ISNULL(RTRIM(Client_ID),'DBNULL_TEXT') + ISNULL(RTRIM(Client_Last_Name),'DBNULL_TEXT') + ISNULL(RTRIM(EmailOptIn),'DBNULL_TEXT') + ISNULL(RTRIM(IsTeamShop),'DBNULL_TEXT') + ISNULL(RTRIM(Order_ID),'DBNULL_TEXT') + ISNULL(RTRIM(OrderDate),'DBNULL_TEXT') + ISNULL(RTRIM(OrderDiscountTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderGrossSubTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderNetTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderNonTaxableSubTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderPromo),'DBNULL_TEXT') + ISNULL(RTRIM(OrderShipTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTaxableSubTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTaxTotal),'DBNULL_TEXT') + ISNULL(RTRIM(ProductCategory),'DBNULL_TEXT') + ISNULL(RTRIM(ProductID),'DBNULL_TEXT') + ISNULL(RTRIM(ProductName),'DBNULL_TEXT') + ISNULL(RTRIM(ProductSubCategory),'DBNULL_TEXT') + ISNULL(RTRIM(QtySold),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddress0),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddress1),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddress2),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressAttention),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressCity),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressCounty),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressState),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressTel),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressZip),'DBNULL_TEXT') + ISNULL(RTRIM(Total_Of_Sale_Paid_By_Account_Order),'DBNULL_TEXT') + ISNULL(RTRIM(UnitPrice),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Order_Id, ProductID, QtySold)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ods.Fanatics_Orders AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.Order_ID = mySource.Order_ID
AND myTarget.ProductID = mySource.ProductID
AND myTarget.QtySold = mySource.QtySold

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[Order_ID] = mySource.[Order_ID]
     ,myTarget.[Client_First_Name] = mySource.[Client_First_Name]
     ,myTarget.[Client_Last_Name] = mySource.[Client_Last_Name]
     ,myTarget.[Client_Email] = mySource.[Client_Email]
     ,myTarget.[EmailOptIn] = mySource.[EmailOptIn]
     ,myTarget.[Client_ID] = mySource.[Client_ID]
     ,myTarget.[OrderDate] = mySource.[OrderDate]
     ,myTarget.[ProductCategory] = mySource.[ProductCategory]
     ,myTarget.[ProductSubCategory] = mySource.[ProductSubCategory]
     ,myTarget.[ProductID] = mySource.[ProductID]
     ,myTarget.[ProductName] = mySource.[ProductName]
     ,myTarget.[QtySold] = mySource.[QtySold]
     ,myTarget.[UnitPrice] = mySource.[UnitPrice]
     ,myTarget.[OrderDiscountTotal] = mySource.[OrderDiscountTotal]
     ,myTarget.[OrderGrossSubTotal] = mySource.[OrderGrossSubTotal]
     ,myTarget.[OrderTaxableSubTotal] = mySource.[OrderTaxableSubTotal]
     ,myTarget.[OrderNonTaxableSubTotal] = mySource.[OrderNonTaxableSubTotal]
     ,myTarget.[OrderTaxTotal] = mySource.[OrderTaxTotal]
     ,myTarget.[OrderNetTotal] = mySource.[OrderNetTotal]
     ,myTarget.[OrderShipTotal] = mySource.[OrderShipTotal]
     ,myTarget.[Total_Of_Sale_Paid_By_Account_Order] = mySource.[Total_Of_Sale_Paid_By_Account_Order]
     ,myTarget.[OrderPromo] = mySource.[OrderPromo]
     ,myTarget.[ShipAddress0] = mySource.[ShipAddress0]
     ,myTarget.[ShipAddress1] = mySource.[ShipAddress1]
     ,myTarget.[ShipAddress2] = mySource.[ShipAddress2]
     ,myTarget.[ShipAddressCity] = mySource.[ShipAddressCity]
     ,myTarget.[ShipAddressState] = mySource.[ShipAddressState]
     ,myTarget.[ShipAddressCounty] = mySource.[ShipAddressCounty]
     ,myTarget.[ShipAddressZip] = mySource.[ShipAddressZip]
     ,myTarget.[ShipAddressTel] = mySource.[ShipAddressTel]
     ,myTarget.[ShipAddressAttention] = mySource.[ShipAddressAttention]
     ,myTarget.[BillAddress0] = mySource.[BillAddress0]
     ,myTarget.[BillAddress1] = mySource.[BillAddress1]
     ,myTarget.[BillAddress2] = mySource.[BillAddress2]
     ,myTarget.[BillAddressCity] = mySource.[BillAddressCity]
     ,myTarget.[BillAddressState] = mySource.[BillAddressState]
     ,myTarget.[BilAddressCountry] = mySource.[BilAddressCountry]
     ,myTarget.[BillAddressZip] = mySource.[BillAddressZip]
     ,myTarget.[IsTeamShop] = mySource.[IsTeamShop]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[Order_ID]
     ,[Client_First_Name]
     ,[Client_Last_Name]
     ,[Client_Email]
     ,[EmailOptIn]
     ,[Client_ID]
     ,[OrderDate]
     ,[ProductCategory]
     ,[ProductSubCategory]
     ,[ProductID]
     ,[ProductName]
     ,[QtySold]
     ,[UnitPrice]
     ,[OrderDiscountTotal]
     ,[OrderGrossSubTotal]
     ,[OrderTaxableSubTotal]
     ,[OrderNonTaxableSubTotal]
     ,[OrderTaxTotal]
     ,[OrderNetTotal]
     ,[OrderShipTotal]
     ,[Total_Of_Sale_Paid_By_Account_Order]
     ,[OrderPromo]
     ,[ShipAddress0]
     ,[ShipAddress1]
     ,[ShipAddress2]
     ,[ShipAddressCity]
     ,[ShipAddressState]
     ,[ShipAddressCounty]
     ,[ShipAddressZip]
     ,[ShipAddressTel]
     ,[ShipAddressAttention]
     ,[BillAddress0]
     ,[BillAddress1]
     ,[BillAddress2]
     ,[BillAddressCity]
     ,[BillAddressState]
     ,[BilAddressCountry]
     ,[BillAddressZip]
     ,[IsTeamShop]
     )
VALUES
     (@RunTime	--ETL_CreatedDate
     ,@RunTime	--ETL_UpdateddDate
     ,0			--ETL_IsDeleted
     ,NULL		--ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[Order_ID]
     ,mySource.[Client_First_Name]
     ,mySource.[Client_Last_Name]
     ,mySource.[Client_Email]
     ,mySource.[EmailOptIn]
     ,mySource.[Client_ID]
     ,mySource.[OrderDate]
     ,mySource.[ProductCategory]
     ,mySource.[ProductSubCategory]
     ,mySource.[ProductID]
     ,mySource.[ProductName]
     ,mySource.[QtySold]
     ,mySource.[UnitPrice]
     ,mySource.[OrderDiscountTotal]
     ,mySource.[OrderGrossSubTotal]
     ,mySource.[OrderTaxableSubTotal]
     ,mySource.[OrderNonTaxableSubTotal]
     ,mySource.[OrderTaxTotal]
     ,mySource.[OrderNetTotal]
     ,mySource.[OrderShipTotal]
     ,mySource.[Total_Of_Sale_Paid_By_Account_Order]
     ,mySource.[OrderPromo]
     ,mySource.[ShipAddress0]
     ,mySource.[ShipAddress1]
     ,mySource.[ShipAddress2]
     ,mySource.[ShipAddressCity]
     ,mySource.[ShipAddressState]
     ,mySource.[ShipAddressCounty]
     ,mySource.[ShipAddressZip]
     ,mySource.[ShipAddressTel]
     ,mySource.[ShipAddressAttention]
     ,mySource.[BillAddress0]
     ,mySource.[BillAddress1]
     ,mySource.[BillAddress2]
     ,mySource.[BillAddressCity]
     ,mySource.[BillAddressState]
     ,mySource.[BilAddressCountry]
     ,mySource.[BillAddressZip]
     ,mySource.[IsTeamShop]
     )
;



DECLARE @MergeInsertRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.Fanatics_Orders WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.Fanatics_Orders WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
