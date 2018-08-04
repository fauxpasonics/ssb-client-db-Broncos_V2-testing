SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_Fanatics_Orders_Rank]
AS
    (
      SELECT    order_rank.Client_ID
              , order_rank.Client_First_Name
              , order_rank.Client_Last_Name
              , order_rank.Client_Email
              , order_rank.BillAddressFull
              , order_rank.BillAddressCity
              , order_rank.BillAddressState
              , order_rank.BillAddressZip
			  , order_rank.BilAddressCountry
              , order_rank.OrderDate
			  , order_rank.ETL_UpdatedDate
      FROM      (
                  SELECT    Client_ID
                          , Client_First_Name
                          , Client_Last_Name
                          , Client_Email
                          , BillAddress1 + BillAddress2 AS BillAddressFull
                          , BillAddressCity
                          , BillAddressState
                          , BillAddressZip
						  , BilAddressCountry
                          , OrderDate
						  , ETL_UpdatedDate
                          , ROW_NUMBER() OVER ( PARTITION BY Client_ID ORDER BY OrderDate DESC ) AS row_Rank
                  FROM      ods.Fanatics_Orders
                ) order_rank
      WHERE     order_rank.row_Rank = 1
    );


GO
