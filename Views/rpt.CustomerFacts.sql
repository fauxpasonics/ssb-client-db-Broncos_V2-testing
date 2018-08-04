SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[CustomerFacts] AS

SELECT
        dcs.DimCustomerId,
        dc.SourceDB,
        dc.SourceSystem,
        dcs.SSID,
        dcs.SSB_CRMSYSTEM_CONTACT_ID,
        dcs.SSB_CRMSYSTEM_ACCT_ID,
        dc.FirstName,
        dc.LastName,
        dc.Suffix,
        dc.Birthday,
        dc.Gender,
        dc.AddressPrimaryZip,
        dc.AddressPrimaryState,
		dc.CustomerType,
		dc.CustomerStatus,
        dc.UpdatedDate,
		ltpd.Ticket_Date AS Last_TicketPurchase_Date,
        DATEDIFF(DAY, ltpd.Ticket_Date, GETDATE()) AS DaysSince_LastTicketPurchase,
        ISNULL(ltpd.Ticket_TotalPaid,0) AS Tickets_TotalPaid,
        ISNULL(sg.QtySeat,0) AS Tickets_TotalSingleGame,
		merch.MaxOrderDate        AS Fanatics_MaxOrderDate,
		merch.TotalSpent_30Days   AS Fanatics_TotalSpent_30Days,                 
		merch.TotalSpent_90Days   AS Fanatics_TotalSpent_90Days, 
		merch.TotalSpent_365Days  AS Fanatics_TotalSpent_365Days,
		merch.TotalSpent_LifeTime AS Fanatics_TotalSpent_LifeTime
		,tks.Approx_Income
		,tks.Approx_Age
		,tks.[ Tenure ]
		,tks.[ Seat Section ]
		FROM    [dbo].[dimcustomerssbid] dcs
LEFT JOIN
	[dbo].[DimCustomer] dc
	on dcs.SSID = dc.SSID
	LEFT JOIN
     (
          SELECT DISTINCT
                SSB_CRMSYSTEM_CONTACT_ID,
                SUM(QtySeat) QtySeat    --Single Game Ticket Logic
          FROM  [dbo].[FactTicketSales] fts
          INNER JOIN (
		  SELECT TOP (1000) dc.[DimCustomerId]
	     ,dc.[BatchId]
	     ,dc.[ODSRowLastUpdated]
	     ,dc.[SourceDB]
	     ,dc.[SourceSystem]
	     ,dc.[SourceSystemPriority]
	     ,dc.[SSID]
	     ,dc.[CustomerType]
	     ,dc.[CustomerStatus]
	     ,dc.[Prefix]
	     ,dc.[FirstName]
	     ,dc.[MiddleName]
	     ,dc.[LastName]
	     ,dc.[SSCreatedBy]
	     ,dc.[SSUpdatedBy]
	     ,dc.[SSCreatedDate]
	     ,dc.[SSUpdatedDate]
	     ,dc.[CreatedBy]
	     ,dc.[UpdatedBy]
	     ,dc.[CreatedDate]
	     ,dc.[UpdatedDate]
	     ,dc.[AccountId]
	     ,dc.[IsDeleted]
	     ,dc.[DeleteDate]
	     ,dc.[IsBusiness]
	     ,dc.[FullName]
	     ,dc.[customer_matchkey]
		 ,s.SSB_CRMSYSTEM_CONTACT_ID
		FROM [dbo].[vw_dimcustomer] dc
		  INNER JOIN dbo.dimcustomerssbid s on dc.SSID = s.SSID
		  ) b
               ON [fts].[SSID] = b.SSID
--                  AND   b.SourceSystem = 'TI'
--          WHERE DimTicketTypeId = '4'
          GROUP BY
                SSB_CRMSYSTEM_CONTACT_ID
     ) sg
     ON sg.[SSB_CRMSYSTEM_CONTACT_ID] = dcs.[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN
     (
          SELECT
                [b].[SSB_CRMSYSTEM_CONTACT_ID], -- Ticket Spend Fields
                MAX(CreatedDate) AS Ticket_Date,
                SUM(PaidAmount) AS Ticket_TotalPaid
          FROM  [dbo].[FactTicketSales] fts
          INNER JOIN (
				Select dc.SSID
				, dc.SourceSystem
				, dcs.SSB_CRMSYSTEM_CONTACT_ID
				FROM dbo.DimCustomer dc
				INNER JOIN dbo.dimcustomerssbid dcs
				ON dc.SSID = dcs.SSID
				) b
               ON [fts].SSID = b.SSID
          GROUP BY
                [b].[SSB_CRMSYSTEM_CONTACT_ID]
     ) ltpd
     ON ltpd.[SSB_CRMSYSTEM_CONTACT_ID] = dcs.[SSB_CRMSYSTEM_CONTACT_ID]
	 LEFT JOIN 

	(   SELECT

			DISTINCT SSB_CRMSYSTEM_CONTACT_ID
			, MAX(MaxOrderDate)			 AS MaxOrderDate
			, SUM(t.TotalSpent_30Days)	 AS TotalSpent_30Days	
			, SUM(t.TotalSpent_90Days)	 AS TotalSpent_90Days	
			, SUM(t.TotalSpent_365Days)	 AS TotalSpent_365Days	
			, SUM(t.TotalSpent_Lifetime) AS TotalSpent_Lifetime


		FROM   ( SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, MAX(OrderDate) AS MaxOrderDate
						, CASE WHEN orderdate >= DATEADD(DAY,-30,GETDATE()) THEN SUM(OrderNetTotal)	ELSE 0 END AS TotalSpent_30Days
						, CASE WHEN orderdate >= DATEADD(DAY,-90,GETDATE()) THEN SUM(OrderNetTotal)	ELSE 0 END AS TotalSpent_90Days
						, CASE WHEN orderdate >= DATEADD(YEAR,-1,GETDATE()) THEN SUM(OrderNetTotal)	ELSE 0 END AS TotalSpent_365Days
						, SUM(OrderNetTotal) AS TotalSpent_Lifetime
						FROM (SELECT DISTINCT SSBID.SSB_CRMSYSTEM_CONTACT_ID  AS SSB_CRMSYSTEM_CONTACT_ID
									, Client_Id
									, Order_ID
									, OrderDate
									, OrderNetTotal
									from [rpt].[vw_Fanatics_Orders] u WITH (NOLOCK) 
									  INNER JOIN dbo.dimcustomerssbid SSBID WITH (NOLOCK) 
										ON SSBID.SourceSystem = 'Fanatics' and SSBID.SSID = u.Client_Id
							 ) orders
						GROUP BY SSB_CRMSYSTEM_CONTACT_ID, orders.OrderDate
						) t
GROUP BY SSB_CRMSYSTEM_CONTACT_ID
) merch ON dcs.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN (
select CAST(CASE WHEN REPLACE(REPLACE(right(left([ Annual Household Income Before Taxes ], 8),7),' ',''),',','') in ('refern','esstha') THEN NULL 
	ELSE REPLACE(REPLACE(right(left([ Annual Household Income Before Taxes ], 8),7),' ',''),',','') END AS INT)  AS Approx_Income
, CASE WHEN left(tk.[ Age ], 2) IN ('Pr', '') THEN NULL ELSE CAST(left(tk.[ Age ], 2) AS INT) END AS Approx_Age
, tk.[ Tenure ]
, tk.[ Customer Key ]
, tk.[ First Name ]
, tk.[ Last Name ]
, tk.[ Seat Section ]
, dc.SSID
from [dbo].[vw_Turnkey_Survey_Pivot_Full2016] tk
INNER JOIN dbo.DimCustomer dc on
tk.[ Customer Key ] = dc.EmailPrimary AND tk.[ First Name ] = dc.FirstName AND tk.[ Last Name ] = dc.LastName) tks 
ON tks.SSID = dcs.SSID

GO
