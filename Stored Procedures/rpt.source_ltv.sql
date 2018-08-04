SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 9/20/2016
-- Description: LTV Calculations Across Source Systems
-- Aggregated by SSB Contact GUID
-- =============================================
CREATE PROCEDURE [rpt].[source_ltv]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SELECT  DISTINCT
        fo.Client_ID
      , fo.Client_Email
      , fo.Order_ID
      , fo.OrderGrossSubTotal
INTO    #FanaticsOrders
FROM    ods.Fanatics_Orders AS fo;


-- =============================================
-- LTV by Source System
-- =============================================

WITH    TM
          AS (
               SELECT   d.SSB_CRMSYSTEM_CONTACT_ID
                      , SUM(tvt.block_purchase_price) AS TM_Revenue
               FROM     dbo.DimCustomer AS dc
                        INNER JOIN dbo.dimcustomerssbid AS d ON d.DimCustomerId = dc.DimCustomerId
                        INNER JOIN ods.TM_vw_Ticket AS tvt ON tvt.acct_id = dc.AccountId
               WHERE    dc.SourceSystem = 'TM'
               GROUP BY d.SSB_CRMSYSTEM_CONTACT_ID
             ) ,
        TEX
          AS (
               SELECT   d.SSB_CRMSYSTEM_CONTACT_ID
                      , SUM(tt2.te_purchase_price) AS TicketExchange_Revenue
               FROM     dbo.DimCustomer AS dc
                        INNER JOIN dbo.dimcustomerssbid AS d ON d.DimCustomerId = dc.DimCustomerId
                        INNER JOIN ods.TM_Tex AS tt2 ON tt2.assoc_acct_id = dc.AccountId
               WHERE    tt2.assoc_acct_id NOT IN ( 0, 2097711, 1380826 ) -- Removes TM Resale/Exchange Acct
                        AND dc.SourceSystem = 'TM'
               GROUP BY d.SSB_CRMSYSTEM_CONTACT_ID
             ) ,
        FANATICS
          AS (
               SELECT   d.SSB_CRMSYSTEM_CONTACT_ID
                      , SUM(fo.OrderGrossSubTotal) AS Fanatics_Revenue
               FROM     dbo.DimCustomer AS dc
                        INNER JOIN dbo.dimcustomerssbid AS d ON d.DimCustomerId = dc.DimCustomerId
                        INNER JOIN #FanaticsOrders AS fo ON fo.Client_ID = dc.SSID
               GROUP BY d.SSB_CRMSYSTEM_CONTACT_ID
             )
    SELECT DISTINCT
            d.SSB_CRMSYSTEM_CONTACT_ID
          , ISNULL(FANATICS.Fanatics_Revenue, 0) AS Fanatics_Revenue
          , ISNULL(TM.TM_Revenue, 0) AS TM_Revenue
          , ISNULL(TEX.TicketExchange_Revenue, 0) AS TicketExchange_Revenue
          , ISNULL(FANATICS.Fanatics_Revenue, 0) + ISNULL(TM.TM_Revenue, 0)
            + ISNULL(TEX.TicketExchange_Revenue, 0) AS Total_LTV
    FROM    dbo.DimCustomer AS dc
            JOIN dbo.dimcustomerssbid AS d ON d.DimCustomerId = dc.DimCustomerId
            LEFT JOIN FANATICS ON FANATICS.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
            LEFT JOIN TM ON TM.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
            LEFT JOIN TEX ON TEX.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
    ORDER BY Total_LTV DESC;



END
GO
