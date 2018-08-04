SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [segmentation].[vw__Fanatics_Orders] 

AS



SELECT
       ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
      ,[Order_ID]
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
	FROM    dbo.dimcustomerssbid ssbid WITH (NOLOCK) 
    INNER JOIN [Broncos].[ods].[Fanatics_Orders] b WITH (NOLOCK)
		 ON  ssbid.SSID = b.Client_ID
	WHERE   --ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1 AND --deleted 3/9 to test count issues in segmentation
	ssbid.sourcesystem = 'Fanatics' AND orderdate > (GETDATE() - 730)



GO
