SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw_ltv_base]
AS
   WITH   Fanatics
          AS (
               SELECT   dcs2.SSB_CRMSYSTEM_CONTACT_ID
                      , SUM(vfo.OrderNetTotal) AS Fanatics_LTV
               FROM     rpt.vw_fanatics_orders AS vfo
                        JOIN dbo.DimCustomer AS dc WITH (NOLOCK) ON dc.SSID = vfo.Client_ID
                        JOIN dbo.DimCustomerSSBID AS dcs2 WITH (NOLOCK) ON dcs2.DimCustomerId = dc.DimCustomerId
               WHERE    dcs2.SourceSystem = 'Fanatics'
               GROUP BY dcs2.SSB_CRMSYSTEM_CONTACT_ID
             ) ,
        TM
          AS (
               SELECT   dcs2.SSB_CRMSYSTEM_CONTACT_ID
                      , SUM(tvt.block_purchase_price) AS TM_LTV
               FROM     ods.TM_vw_Ticket AS tvt WITH (NOLOCK)
                        JOIN dbo.DimCustomer AS dc WITH (NOLOCK) ON dc.AccountId = tvt.acct_id
                        JOIN dbo.DimCustomerSSBID AS dcs2 WITH (NOLOCK) ON dcs2.DimCustomerId = dc.DimCustomerId
               WHERE    dcs2.SourceSystem = 'TM'
               GROUP BY dcs2.SSB_CRMSYSTEM_CONTACT_ID
             ) ,
        TEX
          AS (
               SELECT   dcs2.SSB_CRMSYSTEM_CONTACT_ID
                      , SUM(tt.te_purchase_price) AS TEX_LTV
               FROM     ods.TM_Tex AS tt WITH (NOLOCK)
                        JOIN dbo.DimCustomer AS dc WITH (NOLOCK) ON dc.AccountId = tt.assoc_acct_id
                        JOIN dbo.DimCustomerSSBID AS dcs2 WITH (NOLOCK) ON dcs2.DimCustomerId = dc.DimCustomerId
               WHERE    dcs2.SourceSystem = 'TM'
               GROUP BY dcs2.SSB_CRMSYSTEM_CONTACT_ID
             ) ,
        ELOQUA
          AS (
               SELECT   dcs2.SSB_CRMSYSTEM_CONTACT_ID
                      , ec.IsSubscribed
                      , ec.IsBounceback
               FROM     ods.Eloqua_Contact AS ec WITH (NOLOCK)
                        JOIN dbo.DimCustomer AS dc WITH (NOLOCK) ON dc.SSID = ec.ID
                        JOIN dbo.DimCustomerSSBID AS dcs2 WITH (NOLOCK) ON dcs2.DimCustomerId = dc.DimCustomerId
               WHERE    dcs2.SourceSystem = 'Eloqua Broncos'
               GROUP BY dcs2.SSB_CRMSYSTEM_CONTACT_ID
                      , ec.IsSubscribed
                      , ec.IsBounceback
             )
    SELECT d.SSB_CRMSYSTEM_CONTACT_ID
          , dc.EmailPrimary
          , ELOQUA.IsSubscribed
          , ELOQUA.IsBounceback
          , Fanatics.Fanatics_LTV
          , TM.TM_LTV
          , TEX.TEX_LTV
    FROM    dbo.DimCustomer AS dc WITH (NOLOCK)
            JOIN dbo.DimCustomerSSBID AS d WITH (NOLOCK) ON d.DimCustomerId = dc.DimCustomerId
            LEFT JOIN TM ON TM.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
            LEFT JOIN TEX ON TEX.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
            LEFT JOIN Fanatics ON Fanatics.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
            LEFT JOIN ELOQUA ON ELOQUA.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
    WHERE   d.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;




GO
