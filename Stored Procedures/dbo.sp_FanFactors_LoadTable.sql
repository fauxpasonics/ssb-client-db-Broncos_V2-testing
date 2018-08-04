SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROC [dbo].[sp_FanFactors_LoadTable]
AS




--SELECT TOP 1000 * FROM ro.vw_FanFactors

--CREATE Table #FanFactors AS

/*

SELECT * FROM ro.vw_FanFactors WHERE SSB_CRMSYSTEM_CONTACT_ID IN (

SELECT ssb_crmsystem_contact_Id
FROM ro.vw_fanfactors
GROUP BY  ssb_crmsystem_contact_id
HAVING COUNT(*) > 1

)
ORDER BY 5

*/




		--This is the ticket purchase information
IF OBJECT_ID('tempdb.dbo.#ltpd', 'U') IS NOT NULL
  DROP TABLE #ltpd; 
          SELECT
                [b].[SSB_CRMSYSTEM_CONTACT_ID],
                MAX(fts.SSCreatedDate) AS RecentPurchase,
				SUM(CASE WHEN fts.SSCreatedDate >= DATEADD(YEAR,-1,GETDATE()) THEN QtySeat	ELSE 0 END) AS PurchaseLastYear,
                SUM(CASE WHEN fts.PaidAmount IS NULL THEN 0 ELSE fts.PaidAmount END) AS Ticket_TotalPaid,
				SUM(CASE WHEN fts.QtySeat IS NULL THEN 0 ELSE QtySeat END) AS QtySeat,
				MAX(CASE WHEN ds.SectionName like'CC%' OR ds.SectionName LIKE 'S2%' OR ds.SectionName LIKE 'S4%' OR ds.SectionName LiKE 'PR%' OR ds.sectionName LIKE 'R%%' THEN 1 ELSE 0 END) AS Suite_Club_Flag
				INTO #ltpd
          FROM  (SELECT PaidAmount, QtySeat, SSCreatedDate, DimcustomerId, SSID_section_id FROM [dbo].[FactTicketSales]  WITH (NOLOCK) WHERE DimSeasonId IN (4,22,50,77)
		  UNION 
		  SELECT PaidAmount, QtySeat, SSCreatedDate, DimcustomerId, SSID_section_id FROM
		  dbo.FactTicketSalesHistory WITH (NOLOCK) WHERE DimSeasonId IN (4,22,50,77) ) fts
          INNER JOIN (
				SELECT dc.SSID
				, dc.DimCustomerID
				, dc.SourceSystem
				, dc.SSB_CRMSYSTEM_CONTACT_ID
				FROM dbo.dimcustomerssbid dc WITH (NOLOCK)
				) b
               ON [fts].DimCustomerId = b.DimCustomerID		
		  LEFT JOIN dbo.DimSeat ds WITH (NOLOCK) ON fts.SSID_section_id = ds.SSID_section_id	
          GROUP BY
                [b].[SSB_CRMSYSTEM_CONTACT_ID]
				create clustered index idc_temp_ltpd on #ltpd (ssb_crmsystem_contact_id)


/*********************************************************************************************/

IF OBJECT_ID('tempdb.dbo.#ltlf', 'U') IS NOT NULL
  DROP TABLE #ltlf; 
          SELECT
                [b].[SSB_CRMSYSTEM_CONTACT_ID],
                SUM(CASE WHEN fts.PaidAmount IS NULL THEN 0 ELSE fts.PaidAmount END) AS LicenseFees_TotalPaid
				INTO #ltlf
          FROM  (SELECT PaidAmount, DimcustomerId FROM [dbo].[FactTicketSales]  WITH (NOLOCK) WHERE DimSeasonId IN (6, 24, 54, 80)
		  UNION 
		  SELECT PaidAmount, DimcustomerId FROM
		  dbo.FactTicketSalesHistory WITH (NOLOCK) WHERE DimSeasonId IN (6, 24, 54, 80) ) fts
          INNER JOIN (
				SELECT dc.SSID
				, dc.DimCustomerID
				, dc.SourceSystem
				, dc.SSB_CRMSYSTEM_CONTACT_ID
				FROM dbo.dimcustomerssbid dc WITH (NOLOCK)
				) b
               ON [fts].DimCustomerId = b.DimCustomerID			
          GROUP BY
                [b].[SSB_CRMSYSTEM_CONTACT_ID]
				create clustered index idc_temp_ltlf on #ltlf (ssb_crmsystem_contact_id)
				--select top 1000 * from #ltlf
				--QA against suites

/*********************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#woo', 'U') IS NOT NULL
  DROP TABLE #woo; 
   SELECT

		SSB_CRMSYSTEM_CONTACT_ID
		, MAX(MaxOrderDate)			 AS MaxOrderDate
		, SUM(t.TotalSpent_30Days)	 AS TotalSpent_30Days	
		, SUM(t.TotalSpent_90Days)	 AS TotalSpent_90Days	
		, SUM(t.TotalSpent_Year)	 AS TotalSpent_Year	
		, SUM(t.TotalSpent_Lifetime) AS TotalSpent_Lifetime
		INTO #Woo

	FROM   ( SELECT SSB_CRMSYSTEM_CONTACT_ID, MAX(Order_Date) AS MaxOrderDate
					, CASE WHEN order_date >= DATEADD(DAY,-30,GETDATE()) THEN SUM(Order_Total)	ELSE 0 END AS TotalSpent_30Days
					, CASE WHEN order_date >= DATEADD(DAY,-90,GETDATE()) THEN SUM(Order_Total)	ELSE 0 END AS TotalSpent_90Days
					, CASE WHEN order_date >= DATEADD(YEAR,-1,GETDATE()) THEN SUM(Order_Total)	ELSE 0 END AS TotalSpent_Year
					, SUM(Order_Total) AS TotalSpent_Lifetime
					FROM (SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID  AS SSB_CRMSYSTEM_CONTACT_ID
								, Order_Date
								, Order_Total
								FROM dbo.Marketing_Products_WooCommerce_Through2017 u WITH (NOLOCK)
								  INNER JOIN dbo.vwDimCustomer_ModAcctID dc WITH (NOLOCK) ON dc.SourceSystem = 'Fanatics' AND dc.EmailPrimary = u.Email
						 ) orders
					GROUP BY SSB_CRMSYSTEM_CONTACT_ID, orders.Order_Date
					) t
		GROUP BY SSB_CRMSYSTEM_CONTACT_ID
		create clustered index idc_temp_woo on #Woo (ssb_crmsystem_contact_id)
/***********************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#wa', 'U') IS NOT NULL
  DROP TABLE #wa; 
 SELECT distinct ssb_crmsystem_contact_id INTO #wa FROM dbo.SeasonTicket_WaitList w WITH (NOLOCK) 
 LEFT JOIN dbo.vwDimCustomer_ModAcctId dc WITH (NOLOCK) ON w.AccountID = dc.accountid AND dc.sourcesystem = 'TM' AND dc.customertype = 'Primary' 
 create clustered index idc_temp_wa on #wa (ssb_crmsystem_contact_id)
 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#merch', 'U') IS NOT NULL
  DROP TABLE #merch; 
 SELECT

		SSB_CRMSYSTEM_CONTACT_ID
		, MAX(MaxOrderDate)			 AS MaxOrderDate
		, SUM(t.TotalSpent_30Days)	 AS TotalSpent_30Days	
		, SUM(t.TotalSpent_90Days)	 AS TotalSpent_90Days	
		, SUM(t.TotalSpent_Year)	 AS TotalSpent_Year	
		, SUM(t.TotalSpent_Lifetime) AS TotalSpent_Lifetime
		into #merch
		FROM(
 SELECT SSB_CRMSYSTEM_CONTACT_ID, MAX(OrderDate) AS MaxOrderDate
					, CASE WHEN orderdate >= DATEADD(DAY,-30,GETDATE()) THEN SUM(OrderNetTotal)	ELSE 0 END AS TotalSpent_30Days
					, CASE WHEN orderdate >= DATEADD(DAY,-90,GETDATE()) THEN SUM(OrderNetTotal)	ELSE 0 END AS TotalSpent_90Days
					, CASE WHEN orderdate >= DATEADD(YEAR,-1,GETDATE()) THEN SUM(OrderNetTotal)	ELSE 0 END AS TotalSpent_Year
					, SUM(OrderNetTotal) AS TotalSpent_Lifetime
					FROM (SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID  AS SSB_CRMSYSTEM_CONTACT_ID
								, Client_Id
								, OrderDate
								, OrderNetTotal
								FROM [rpt].[vw_Fanatics_Orders] u WITH (NOLOCK)
								  INNER JOIN dbo.dimcustomerssbid dc WITH (NOLOCK) ON dc.SourceSystem = 'Fanatics' AND dc.SSID = u.Client_Id
								  	 ) orders
					GROUP BY SSB_CRMSYSTEM_CONTACT_ID, orders.OrderDate
					) t
		GROUP BY SSB_CRMSYSTEM_CONTACT_ID
		create clustered index idc_temp_merch on #merch (ssb_crmsystem_contact_id)
 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#crush', 'U') IS NOT NULL
  DROP TABLE #crush; 					--Crush Member Status
SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID AS CrushMember into #crush FROM ods.EloquaCustom_CrushMembers cm WITH (NOLOCK) INNER JOIN dbo.vwdimcustomer_modacctid dc WITH (NOLOCK)
ON cm.EmailAddress = dc.EmailPrimary AND cm.EmailAddress NOT LIKE '%broncos.nfl%'
create clustered index idc_temp_crush on #crush (CrushMember)
 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#bbunch', 'U') IS NOT NULL
  DROP TABLE #bbunch; 				--Child is Broncos Bunch Member Status
SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID AS BunchMember into #bbunch FROM ods.EloquaCustom_BroncosBunchMasterList bb WITH (NOLOCK) INNER JOIN dbo.vwdimcustomer_modacctid dc WITH (NOLOCK)
ON bb.Parents_Email_Address1 = dc.EmailPrimary and bb.Parents_Email_Address1 NOT LIKE '%broncos.nfl%'
create clustered index idc_temp_bbunch on #bbunch (BunchMember)
 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#emg', 'U') IS NOT NULL
  DROP TABLE #emg; 	--EMail Group subscription flags
SELECT
ssbid.SSB_CRMSYSTEM_CONTACT_ID,
MAX(CASE WHEN egm.EmailGroup = 'OrangeJuice' THEN 1 ELSE 0 END) EmailGroup_OrangeJuice, 
MAX(CASE WHEN egm.EmailGroup = 'SurveyPanel' THEN 1 ELSE 0 END) EmailGroup_SurveyPanel, 
MAX(CASE WHEN egm.EmailGroup = 'BroncosPromos' THEN 1 ELSE 0 END) EmailGroup_BroncosPromos, 
MAX(CASE WHEN egm.EmailGroup = 'Stadium' THEN 1 ELSE 0 END) EmailGroup_Stadium, 
MAX(CASE WHEN egm.EmailGroup = 'OrangeHerd' THEN 1 ELSE 0 END) EmailGroup_OrangeHerd, 
MAX(CASE WHEN egm.EmailGroup = 'ICYMI' THEN 1 ELSE 0 END) EmailGroup_ICYMI, 
MAX(CASE WHEN egm.EmailGroup = 'Outlaws' THEN 1 ELSE 0 END) EmailGroup_Outlaws
into #emg
FROM ods.EloquaCustom_EmailGroupMembers egm WITH (NOLOCK)
LEFT JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON CAST(egm.ContactID AS NVARCHAR(200)) = ssbid.ssid --AND ssbid.SourceSystem = 'Eloqua Broncos'-- AND ssbid.sourcesystem = 'Fancentric'
WHERE ETL_IsDeleted = 0 AND ssbid.SourceSystem = 'Eloqua Broncos' AND egm.EMailAddress NOT LIKE '%broncos.nfl%'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_emg on #emg (ssb_crmsystem_contact_id)
 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#eo', 'U') IS NOT NULL
  DROP TABLE #eo; 
SELECT dc.SSB_CRMSYSTEM_CONTACT_ID AS EmailOpened, MAX(o.CreatedAt) AS MostRecentOpen, COUNT(DISTINCT o.CampaignId) AS NumberEmailOpens				
into #eo FROM ods.Eloqua_ActivityEmailOpen o WITH (NOLOCK)
INNER JOIN dbo.vwdimcustomer_modacctid dc WITH (NOLOCK) ON CAST(o.ContactId AS NVARCHAR(200)) =  dc.SSID  AND dc.SourceSystem = 'Eloqua Broncos'	AND dc.EmailPrimary NOT LIKE '%broncos.nfl%'  AND o.ETL_CreatedDate > DATEADD(YEAR,-2,GETDATE()) 
GROUP BY dc.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_eo on #eo (EmailOpened)

 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#fs', 'U') IS NOT NULL
  DROP TABLE #fs; 
SELECT dc.SSB_CRMSYSTEM_CONTACT_ID AS FormSubmit, COUNT(DISTINCT f.AssetName) AS NumberFormsSubmitted into #fs FROM ods.Eloqua_ActivityFormSubmit f WITH (NOLOCK)
INNER JOIN dbo.vwdimcustomer_modacctid dc WITH (NOLOCK) ON CAST(f.ContactId AS NVARCHAR(200)) = dc.SSID AND dc.SourceSystem = 'Eloqua Broncos' AND dc.EmailPrimary NOT LIKE '%broncos.nfl%'  AND f.ETL_CreatedDate > DATEADD(YEAR,-2,GETDATE())
GROUP BY dc.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_fs on #fs (FormSubmit)

 /**************************************************************************************************************/
--IF OBJECT_ID('tempdb.dbo.#dsa', 'U') IS NOT NULL
--  DROP TABLE #dsa; 			--Game attendance within the last three years
--SELECT x.SSB_CRMSYSTEM_CONTACT_ID, SUM(x.AttendedThreeYears) AttendedThreeYears, MAX(x.MaxAttended) MaxAttended
--into #dsa FROM (
--SELECT dc.ssb_crmsystem_contact_id, CASE WHEN ScanDateTime > DATEADD(YEAR,-3,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedThreeYears'
--, ScanDateTime AS 'MaxAttended'
--FROM dbo.FactAttendance fa WITH (NOLOCK)  -- also need factattendancehistory, where can I find that? find out.
--INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
--INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
--INNER JOIN dbo.dimseason ds WITH (NOLOCK) ON de.DimSeasonId = ds.DimSeasonId
--WHERE ds.DimSeasonId IN (4,22,50,77)
--) x
--GROUP BY x.ssb_crmsystem_contact_id
--create clustered index idc_temp_dsa on #dsa (SSB_CRMSYSTEM_CONTACT_ID)--do more QA and find out why some people have a couple thousand attended


IF OBJECT_ID('tempdb.dbo.#dsa', 'U') IS NOT NULL
  DROP TABLE #dsa; 			--Game attendance within the last three years
SELECT x.SSB_CRMSYSTEM_CONTACT_ID, SUM(CASE WHEN x.Attended IS NULL THEN 0 ELSE x.Attended END) AS AttendedThreeYears, MAX(x.MaxAttended) MaxAttended
into #dsa 
FROM (
SELECT dc.ssb_crmsystem_contact_id, dc.dimCustomerId, CASE WHEN fa.ScanDateTime > DATEADD(YEAR,-3,GETDATE()) THEN 1 ELSE 0 END AS 'Attended', fa.ScanDateTime AS MaxAttended
FROM (SELECT AccountId, dim.DimCustomerId, ssb.SSB_CRMSYSTEM_CONTACT_ID FROM dbo.DimCustomer dim WITH (NOLOCK) INNER JOIN dbo.dimcustomerssbid ssb WITH (NOLOCK) ON dim.DimCustomerId = ssb.DimCustomerId WHERE CustomerType = 'Primary' GROUP BY AccountId, dim.DimCustomerId, SSB_CRMSYSTEM_CONTACT_ID) dc
LEFT JOIN (Select * from dbo.FactAttendance WITH (NOLOCK) WHERE DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%'))fa ON fa.DimCustomerId = dc.DimCustomerId
UNION
SELECT dc.ssb_crmsystem_contact_id, dc.dimCustomerId, CASE WHEN fa16.Event_date > DATEADD(YEAR,-3,GETDATE()) THEN 1 ELSE 0 END AS 'Attended', fa16.event_date AS MaxAttended
FROM (SELECT AccountId, dim.DimCustomerId, ssb.SSB_CRMSYSTEM_CONTACT_ID FROM dbo.DimCustomer dim WITH (NOLOCK) INNER JOIN dbo.dimcustomerssbid ssb WITH (NOLOCK) ON dim.DimCustomerId = ssb.DimCustomerId WHERE CustomerType = 'Primary' GROUP BY AccountId, dim.DimCustomerId, SSB_CRMSYSTEM_CONTACT_ID) dc
LEFT JOIN archive.v_2016_attendance_scans fa16 WITH (NOLOCK) ON fa16.acct_id = dc.AccountId AND fa16.event_name LIKE 'GAME%'
UNION
SELECT dc.ssb_crmsystem_contact_id, dc.dimCustomerId, CASE WHEN fa15.Event_date > DATEADD(YEAR,-3,GETDATE()) THEN 1 ELSE 0 END AS 'Attended', fa15.event_date AS MaxAttended
FROM (SELECT AccountId, dim.DimCustomerId, ssb.SSB_CRMSYSTEM_CONTACT_ID FROM dbo.DimCustomer dim WITH (NOLOCK) INNER JOIN dbo.dimcustomerssbid ssb WITH (NOLOCK) ON dim.DimCustomerId = ssb.DimCustomerId WHERE CustomerType = 'Primary' GROUP BY AccountId, dim.DimCustomerId, SSB_CRMSYSTEM_CONTACT_ID) dc
LEFT JOIN archive.v_2015_attendance_scans fa15 WITH (NOLOCK) ON fa15.acct_id = dc.AccountId AND fa15.event_name LIKE 'GAME%'
) x
GROUP BY x.ssb_crmsystem_contact_id
create clustered index idc_temp_dsa on #dsa (SSB_CRMSYSTEM_CONTACT_ID)

 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#dsa2', 'U') IS NOT NULL
  DROP TABLE #dsa2; 			--Game attendance within the last year
SELECT y.SSB_CRMSYSTEM_CONTACT_ID, SUM(y.AttendedOneYear) AttendedOneYear
into #dsa2 FROM (
SELECT dc.ssb_crmsystem_contact_id, de.dimeventid, CASE WHEN ScanDateTime > DATEADD(YEAR,-1,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedOneYear' 
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
INNER JOIN dbo.dimseason ds WITH (NOLOCK) ON de.DimSeasonId = ds.DimSeasonId
WHERE ds.DimSeasonId IN (50,77)
) y
GROUP BY y.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_dsa2 on #dsa2 (SSB_CRMSYSTEM_CONTACT_ID)
/**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#prio', 'U') IS NOT NULL
  DROP TABLE #prio; 
Select cust.priority AS Cust_Priority, dc.SSB_CRMSYSTEM_CONTACT_ID INTO #prio from ods.TM_Cust cust WITH (NOLOCK)
INNER JOIN dbo.dimcustomerssbid dc WITH (NOLOCK) ON CAST(cust.cust_name_id AS varchar) = CAST(RIGHT(dc.SSID, 7) AS VARCHAR)
create clustered index idc_temp_prio on #prio (SSB_CRMSYSTEM_CONTACT_ID)
/**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#att', 'U') IS NOT NULL
  DROP TABLE #att; 		--TD HOF celebration attendance
SELECT y.SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT CASE WHEN y.AttendedTDHOF = 1 THEN y.DimEventId ELSE NULL END) attendedTDHOF,
COUNT(DISTINCT CASE WHEN y.AttendedTrickOrTreat = 1 THEN y.DimEventId ELSE NULL END) attendedtrickortreat, COUNT(DISTINCT CASE WHEN y.AttendedHolidayPicture = 1 THEN y.DimEventId ELSE NULL END) attendedHolidayPicture
into #att FROM (
SELECT dc.ssb_crmsystem_contact_id, de.dimeventid, CASE WHEN de.DimEventId IN (352) THEN 1 ELSE 0 END AS 'AttendedTDHOF', 
CASE WHEN de.DimEventId IN (344, 345, 346) THEN 1 ELSE 0 END AS 'AttendedTrickOrTreat', CASE WHEN de.DimEventId IN (353, 354, 355,356) THEN 1 ELSE 0 END AS 'AttendedHolidayPicture'
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
) y
GROUP BY y.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_att on #att (SSB_CRMSYSTEM_CONTACT_ID)
/**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#fc', 'U') IS NOT NULL
  DROP TABLE #fc; 
SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, SUM(CASE WHEN f.DTV_SUNDAY_TICKET_ACTIVE_FLG = 'Y' THEN 1 ELSE 0 END) Sunday_ticket, --Information on NFL Fantasy and NFL Sunday Ticket subscriptions
SUM(CASE WHEN LEFT(f.FANTASY_LST_VST_DT,4) >= 2017 THEN 1 ELSE 0 END) Fantasy
, SUM(CASE WHEN LEFT(f.LST_PICKEM_SSN_REG_DT,4) >= 2017 THEN 1 ELSE 0 END) Pickem 
into #fc FROM ods.FanCentric_Customers  f WITH (NOLOCK)
LEFT JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON f.cust_id = ssbid.ssid AND ssbid.sourcesystem = 'Fancentric'
WHERE ETL_IsDeleted = 0
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_fc on #fc (SSB_CRMSYSTEM_CONTACT_ID)
/**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#esdc', 'U') IS NOT NULL
  DROP TABLE #esdc; 	--Contest indices, flag 1 for participation. List of desired contests came from Broncos, data found in custom Eloqua object
SELECT				--aggregate this all into one single column, a sum of everything Change to drop if exists, run ststistics on every temp table
 ssbid.SSB_CRMSYSTEM_CONTACT_ID,
MAX(CASE WHEN ecsd.Source1 = 'Arcade' THEN 1 ELSE 0 END) Arcade, 
MAX(CASE WHEN ecsd.Source1 = 'Barclays 2016' THEN 1 ELSE 0 END) Barclays_2016, 
MAX(CASE WHEN ecsd.Source1 = 'Best Seats in the House' THEN 1 ELSE 0 END) Best_Seats_in_the_House, 
MAX(CASE WHEN ecsd.Source1 = 'Bike to Work' THEN 1 ELSE 0 END) Bike_to_Work, 
MAX(CASE WHEN ecsd.Source1 = 'BMW' THEN 1 ELSE 0 END) BMW, 
MAX(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light' THEN 1 ELSE 0 END) Broncos_Bud_Light, 
MAX(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light -  Ring of Fame Contest' THEN 1  WHEN ecsd.Source1 = 'Broncos and Bud Light.com - Ring of Fame Contest' THEN 1 ELSE 0 END) Broncos_Bud_Light__Ring_of_Fame_Contest,
MAX(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light Facebook' THEN 1 ELSE 0 END) Broncos_Bud_Light_Facebook, 
MAX(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light Ticket Giveaway' THEN 1 ELSE 0 END) Broncos_Bud_Light_Ticket_Giveaway, 
MAX(CASE WHEN ecsd.Source1 = 'Broncos and Budlight.com Various Contests' THEN 1 ELSE 0 END) Broncos_Budlight_Various_Contests, 
MAX(CASE WHEN ecsd.Source1 = 'Broncos Fanaticos' THEN 1 ELSE 0 END) Broncos_Fanaticos, 
MAX(CASE WHEN ecsd.Source1 = 'Bud Light Draft' THEN 1 ELSE 0 END) Bud_Light_Draft, 
MAX(CASE WHEN ecsd.Source1 = 'Bud Light Up for Whatever Contest' THEN 1 ELSE 0 END) Bud_Light_Up_for_Whatever_Contest, 
MAX(CASE WHEN ecsd.Source1 = 'BWW' THEN 1 ELSE 0 END) BWW, 
MAX(CASE WHEN ecsd.Source1 = 'Canon Shoot Like a Pro Contests' THEN 1 ELSE 0 END) Canon_Shoot_Like_a_Pro_Contests, 
MAX(CASE WHEN ecsd.Source1 = 'Carmax 2017' THEN 1 ELSE 0 END) Carmax_2017, 
MAX(CASE WHEN ecsd.Source1 = 'Carmax VIP' THEN 1 ELSE 0 END) Carmax_VIP, 
MAX(CASE WHEN ecsd.Source1 = 'CenturyLink 2017' THEN 1 ELSE 0 END) CenturyLink_2017, 
MAX(CASE WHEN ecsd.Source1 = 'CenturyLink Dinner with a Draft Pick' THEN 1 ELSE 0 END) CenturyLink_Dinner_with_a_Draft_Pick,  
MAX(CASE WHEN ecsd.Source1 = 'Denver Broncos Kickoff Kid' THEN 1 ELSE 0 END)	Denver_Broncos_Kickoff_Kid   ,
MAX(CASE WHEN ecsd.Source1 = 'Dia del Nino' THEN 1 ELSE 0 END)	 Dia_del_Nino  ,
MAX(CASE WHEN ecsd.Source1 = 'DirecTV Fan Fly In' THEN 1 ELSE 0 END)	DirecTV_Fan_Fly_In   ,
MAX(CASE WHEN ecsd.Source1 = 'DirecTV Fantasy Football Party' THEN 1 ELSE 0 END)	DirecTV_Fantasy_Football_Party   ,
MAX(CASE WHEN ecsd.Source1 = 'DirecTV Fly In' THEN 1 ELSE 0 END)	DirecTV_Fly_In   ,
MAX(CASE WHEN ecsd.Source1 = 'DirecTV Fly In 2015' THEN 1 ELSE 0 END)	DirecTV_Fly_In_2015   ,
MAX(CASE WHEN ecsd.Source1 = 'En tu Casa' THEN 1 ELSE 0 END)	En_tu_Casa   ,
MAX(CASE WHEN ecsd.Source1 = 'Espanol Prize Registration' THEN 1 ELSE 0 END)	Espanol_Prize_Registration   ,
MAX(CASE WHEN ecsd.Source1 = 'Facebook Ticket Giveaway - Broncos vs Colts Sept 2014' THEN 1 ELSE 0 END) Facebook_Ticket_Giveaway_Broncos_vs_Colts,
MAX(CASE WHEN ecsd.Source1 = 'Famous Dave''s Mini Miles Entries' THEN 1 ELSE 0 END)	Famous_Daves_Mini_Miles_Entries	,
MAX(CASE WHEN ecsd.Source1 = 'Fan Pack' THEN 1 ELSE 0 END) Fan_Pack,
MAX(CASE WHEN ecsd.Source1 = 'Fanaticos Fathers Day' THEN 1 ELSE 0 END)Fanaticos_Fathers_Day,
MAX(CASE WHEN ecsd.Source1 = 'Fanaticos Giveaway' THEN 1 ELSE 0 END)Fanaticos_Giveaway,
MAX(CASE WHEN ecsd.Source1 = 'Fast Dash' THEN 1 ELSE 0 END)Fast_Dash,
MAX(CASE WHEN ecsd.Source1 = 'Free Tickets' THEN 1 ELSE 0 END)Free_Tickets,
MAX(CASE WHEN ecsd.Source1 = 'Gameday 2016 Season' THEN 1 ELSE 0 END)Gameday_2016_Season,
MAX(CASE WHEN ecsd.Source1 = 'Gameday Preview' THEN 1 ELSE 0 END)Gameday_Preview,
MAX(CASE WHEN ecsd.Source1 = 'Grease Monkey 2017' THEN 1 ELSE 0 END)Grease_Monkey_2017,
MAX(CASE WHEN ecsd.Source1 = 'Guess the Schedule' THEN 1 ELSE 0 END)Guess_the_Schedule,
MAX(CASE WHEN ecsd.Source1 = 'Hackathon' THEN 1 ELSE 0 END)Hackathon,
MAX(CASE WHEN ecsd.Source1 = 'HelmetForHelmet' THEN 1 ELSE 0 END)HelmetForHelmet,
MAX(CASE WHEN ecsd.Source1 = 'Indi.com' THEN 1 ELSE 0 END) [Indi.com],
MAX(CASE WHEN ecsd.Source1 = 'Jack Black' THEN 1 ELSE 0 END)Jack_Black,
MAX(CASE WHEN ecsd.Source1 = 'Kickoff Kid' THEN 1 WHEN ecsd.Source1 = 'Kickoff Kid, presented by Nationwide' THEN 1 ELSE 0 END)Kickoff_Kid,
MAX(CASE WHEN ecsd.Source1 = 'King Soopers' THEN 1 ELSE 0 END)King_Soopers,
MAX(CASE WHEN ecsd.Source1 = 'Kwal Paint Winner' THEN 1 ELSE 0 END)Kwal_Paint_Winner,
MAX(CASE WHEN ecsd.Source1 = 'Levi''s' THEN 1 ELSE 0 END) Levis ,
MAX(CASE WHEN ecsd.Source1 = 'mcdonald''s key tag' THEN 1 ELSE 0 END)	Mcdonalds_key_tag   ,
MAX(CASE WHEN ecsd.Source1 = 'McDonald''s Playoffs' THEN 1 ELSE 0 END)McDonalds_Playoffs,
MAX(CASE WHEN ecsd.Source1 = 'Panini' THEN 1 ELSE 0 END)Panini,
MAX(CASE WHEN ecsd.Source1 = 'Papa johns' THEN 1 ELSE 0 END)Papa_johns,
MAX(CASE WHEN ecsd.Source1 = 'Playoff Tickets' THEN 1 ELSE 0 END)Playoff_Tickets,
MAX(CASE WHEN ecsd.Source1 = 'Posada' THEN 1 ELSE 0 END)Posada,
MAX(CASE WHEN ecsd.Source1 = 'Salute to Fans Vote' THEN 1 ELSE 0 END)Salute_to_Fans_Vote,
MAX(CASE WHEN ecsd.Source1 = 'SB50 Ring Digital' THEN 1 ELSE 0 END)SB50_Ring_Digital,
MAX(CASE WHEN ecsd.Source1 = 'SB50 Tickets' THEN 1 ELSE 0 END)SB50_Tickets,
MAX(CASE WHEN ecsd.Source1 = 'SB50 VIP' THEN 1 ELSE 0 END)SB50_VIP,
MAX(CASE WHEN ecsd.Source1 = 'social' THEN 1 ELSE 0 END)social,
MAX(CASE WHEN ecsd.Source1 = 'thankyoufans' THEN 1 ELSE 0 END)thankyoufans,
MAX(CASE WHEN ecsd.Source1 = 'United in Orange Helmet Hunt' THEN 1 ELSE 0 END)United_in_OrangeHelmet_Hunt,
MAX(CASE WHEN ecsd.Source1 = 'Von Miller Contest' THEN 1 ELSE 0 END)Von_Miller_Contest,
MAX(CASE WHEN ecsd.Source1 = 'Web Contest' THEN 1 ELSE 0 END)Web_Contest,
MAX(CASE WHEN ecsd.Source1 = 'Westrock' THEN 1 ELSE 0 END)Westrock,
MAX(CASE WHEN ecsd.Source1 = 'What Would You Do for Broncos Playoff Tickets' THEN 1 ELSE 0 END)What_Would_You_Do_for_Broncos_Playoff_Tickets,
MAX(CASE WHEN ecsd.Source1 = 'Xcel Energy - Draft' THEN 1 ELSE 0 END)Xcel_Energy_Draft,
MAX(CASE WHEN ecsd.Source1 = 'Xome Playoffs' THEN 1 ELSE 0 END)Xome_Playoffs,
MAX(CASE WHEN ecsd.Source1 = 'Yahoo Fantasy' THEN 1 ELSE 0 END)Yahoo_Fantasy
into #esdc
FROM ods.EloquaCustom_SourceDetail ecsd WITH (NOLOCK)
LEFT JOIN dbo.vwdimcustomer_ModAcctId ssbid WITH (NOLOCK) ON ecsd.Email_Address1 = ssbid.EmailPrimary			--ID is not an identifier for the individual and does not join back clean, only good identifier is Email
WHERE ETL_IsDeleted = 0 AND ssbid.SourceSystem = 'Eloqua Broncos' 	AND ssbid.EmailPrimary NOT LIKE '%broncos.nfl%' AND ecsd.ETL_CreatedDate > DATEADD(YEAR,-2,GETDATE())
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_esdc on #esdc (SSB_CRMSYSTEM_CONTACT_ID)

 /**************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#nge', 'U') IS NOT NULL
  DROP TABLE #nge;  --Non-Game events, Flag 1 for participation. Event list came from Broncos, data came from custom Eloqua object.
SELECT
ssbid.SSB_CRMSYSTEM_CONTACT_ID,
 MAX(CASE WHEN ecsd.Source1 = '45 day challenge' THEN 1 ELSE 0 END )AS [45_day_challenge]
,MAX(CASE WHEN ecsd.Source1 = '45 Day Fitness Fall 2016' THEN 1 ELSE 0 END )AS [45_Day_Fitness_Fall_2016]
,MAX(CASE WHEN ecsd.Source1 = 'All You Can Eat Tailgate' THEN 1 ELSE 0 END )AS All_You_Can_Eat_Tailgate
,MAX(CASE WHEN ecsd.Source1 = 'Broadnet 2017' THEN 1 ELSE 0 END )AS Broadnet_2017
,MAX(CASE WHEN ecsd.Source1 = 'Broncos 7K 2015' THEN 1 ELSE 0 END )AS Broncos_7K_2015
,MAX(CASE WHEN ecsd.Source1 = 'Broncos 7K Registration 2014' THEN 1 ELSE 0 END) AS Broncos_7K_Registration_2014
,MAX(CASE WHEN ecsd.Source1 = 'Broncos Bunch Movie Night' THEN 1 ELSE 0 END) AS Broncos_Bunch_Movie_Night
,MAX(CASE WHEN ecsd.Source1 = 'Broncos Bunch Trick-or-Treat RS' THEN 1 ELSE 0 END) AS Broncos_Bunch_Trick_or_Treat
,MAX(CASE WHEN ecsd.Source1 = 'Bunch Kids Day' THEN 1 ELSE 0 END) AS Bunch_Kids_Day
,MAX(CASE WHEN ecsd.Source1 = 'Bunch Movie Night RSVP' THEN 1 ELSE 0 END) AS Bunch_Movie_Night_RSVP
,MAX(CASE WHEN ecsd.Source1 = 'Bunch Movie Night RSVP - 2016' THEN 1 ELSE 0 END) AS Bunch_Movie_Night_RSVP_2016
,MAX(CASE WHEN ecsd.Source1 = 'Bunch Summer Kickoff RSVP' THEN 1 ELSE 0 END )AS Bunch_Summer_Kickoff_RSVP
,MAX(CASE WHEN ecsd.Source1 = 'Bunch training camp' THEN 1 ELSE 0 END )AS Bunch_training_camp
,MAX(CASE WHEN ecsd.Source1 = 'Bunch trick of treat' THEN 1 ELSE 0 END )AS Bunch_trick_of_treat
,MAX(CASE WHEN ecsd.Source1 = 'Carne Asada Flea Market 2017' THEN 1 ELSE 0 END) AS Carne_Asada_Flea_Market_2017
,MAX(CASE WHEN ecsd.Source1 = 'Carne Asada Greeley 2017' THEN 1 ELSE 0 END )AS Carne_Asada_Greeley_2017
,MAX(CASE WHEN ecsd.Source1 = 'Crush Night Out' THEN 1 ELSE 0 END )AS Crush_Night_Out
,MAX(CASE WHEN ecsd.Source1 = 'Denver 7K 2017' THEN 1 ELSE 0 END) AS Denver_7K_2017
,MAX(CASE WHEN ecsd.Source1 = 'Espanol' THEN 1 ELSE 0 END )AS Espanol
,MAX(CASE WHEN ecsd.Source1 = 'Espanol 2017' THEN 1 ELSE 0 END) AS Espanol_2017
,MAX(CASE WHEN ecsd.Source1 = 'Expo 2016' THEN 1 ELSE 0 END )AS Expo_2016
,MAX(CASE WHEN ecsd.Source1 = 'Expo 2017' THEN 1 ELSE 0 END )AS Expo_2017
,MAX(CASE WHEN ecsd.Source1 = 'Expo Survey collect' THEN 1 ELSE 0 END) AS Expo_Survey_collect
,MAX(CASE WHEN ecsd.Source1 = 'Fan Forum' THEN 1 ELSE 0 END )AS Fan_Forum
,MAX(CASE WHEN ecsd.Source1 = 'Greeley - Salute to Fans' THEN 1 ELSE 0 END) AS Greeley_Salute_to_Fans
,MAX(CASE WHEN ecsd.Source1 = 'Mountain Village 2016' THEN 1 ELSE 0 END) AS Mountain_Village_2016
,MAX(CASE WHEN ecsd.Source1 = 'Mountain Village 2017' THEN 1 ELSE 0 END )AS Mountain_Village_2017
,MAX(CASE WHEN ecsd.Source1 = 'Orange County' THEN 1 ELSE 0 END )AS Orange_County
,MAX(CASE WHEN ecsd.Source1 = 'Philadelphia' THEN 1 ELSE 0 END )AS Philadelphia
,MAX(CASE WHEN ecsd.Source1 = 'Salute to Fans' THEN 1 ELSE 0 END) AS Salute_to_Fans
,MAX(CASE WHEN ecsd.Source1 = 'Salute to Fans 2016' THEN 1 ELSE 0 END) AS Salute_to_Fans_2016
,MAX(CASE WHEN ecsd.Source1 = 'Training Camp 2016' THEN 1 ELSE 0 END )AS Training_Camp_2016
,MAX(CASE WHEN ecsd.Source1 = 'Training Camp 2017' THEN 1 ELSE 0 END )AS Training_Camp_2017
into #nge
FROM ods.EloquaCustom_SourceDetail ecsd WITH (NOLOCK)
LEFT JOIN dbo.vwdimcustomer_ModAcctId ssbid WITH (NOLOCK) ON ecsd.Email_Address1 = ssbid.EmailPrimary
WHERE ETL_IsDeleted = 0 AND ssbid.SourceSystem = 'Eloqua Broncos' AND ssbid.EmailPrimary NOT LIKE '%broncos.nfl%'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_nge on #nge (SSB_CRMSYSTEM_CONTACT_ID)
/***************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#sums', 'U') IS NOT NULL
  DROP TABLE #sums;
SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID,
MAX(	 #nge.[45_day_challenge]
		+#nge.[45_Day_Fitness_Fall_2016]
		+#nge.All_You_Can_Eat_Tailgate
		+#nge.Broadnet_2017
		+#nge.Broncos_7K_2015
		+#nge.Broncos_7K_Registration_2014
		+#nge.Broncos_Bunch_Movie_Night
		+#nge.Broncos_Bunch_Trick_or_Treat
		+#nge.Bunch_Kids_Day
		+#nge.Bunch_Movie_Night_RSVP
		+#nge.Bunch_Movie_Night_RSVP_2016
		+#nge.Bunch_Summer_Kickoff_RSVP
		+#nge.Bunch_training_camp
		+#nge.Bunch_trick_of_treat
		+#nge.Carne_Asada_Flea_Market_2017
		+#nge.Carne_Asada_Greeley_2017
		+#nge.Crush_Night_Out
		+#nge.Denver_7K_2017
		+#nge.Espanol
		+#nge.Espanol_2017
		+#nge.Expo_2016
		+#nge.Expo_2017
		+#nge.Expo_Survey_collect
		+#nge.Fan_Forum
		+#nge.Greeley_Salute_to_Fans
		+#nge.Mountain_Village_2016
		+#nge.Mountain_Village_2017
		+#nge.Orange_County
		+#nge.Philadelphia
		+#nge.Salute_to_Fans
		+#nge.Salute_to_Fans_2016
		+#nge.Training_Camp_2016
		+#nge.Training_Camp_2017)AS Total_NonGame_Events,
	MAX( #esdc.Arcade									 
		+#esdc.Barclays_2016							 
		+#esdc.Best_Seats_in_the_House					 
		+#esdc.Bike_to_Work							 
		+#esdc.BMW										 
		+#esdc.Broncos_Bud_Light						 
		+#esdc.Broncos_Bud_Light__Ring_of_Fame_Contest	 
		+#esdc.Broncos_Bud_Light_Facebook				 
		+#esdc.Broncos_Bud_Light_Ticket_Giveaway		 
		+#esdc.Broncos_Budlight_Various_Contests		 
		+#esdc.Broncos_Fanaticos						 
		+#esdc.Bud_Light_Draft							 
		+#esdc.Bud_Light_Up_for_Whatever_Contest		 
		+#esdc.BWW										 
		+#esdc.Canon_Shoot_Like_a_Pro_Contests			 
		+#esdc.Carmax_2017								 
		+#esdc.Carmax_VIP								 
		+#esdc.CenturyLink_2017						 
		+#esdc.CenturyLink_Dinner_with_a_Draft_Pick	 
		+#esdc.Denver_Broncos_Kickoff_Kid				 
		+#esdc.Dia_del_Nino							 
		+#esdc.DirecTV_Fan_Fly_In						 
		+#esdc.DirecTV_Fantasy_Football_Party			 
		+#esdc.DirecTV_Fly_In							 
		+#esdc.DirecTV_Fly_In_2015						 
		+#esdc.En_tu_Casa								 
		+#esdc.Espanol_Prize_Registration				 
		+#esdc.Facebook_Ticket_Giveaway_Broncos_vs_Colts
		+#esdc.Famous_Daves_Mini_Miles_Entries			
		+#esdc.Fan_Pack								
		+#esdc.Fanaticos_Fathers_Day					
		+#esdc.Fanaticos_Giveaway						
		+#esdc.Fast_Dash								
		+#esdc.Free_Tickets							
		+#esdc.Gameday_2016_Season						
		+#esdc.Gameday_Preview							
		+#esdc.Grease_Monkey_2017						
		+#esdc.Guess_the_Schedule						
		+#esdc.Hackathon								
		+#esdc.HelmetForHelmet							
		+#esdc.[Indi.com]								
		+#esdc.Jack_Black								
		+#esdc.Kickoff_Kid								
		+#esdc.King_Soopers							
		+#esdc.Kwal_Paint_Winner						
		+#esdc.Levis									
		+#esdc.Mcdonalds_key_tag						
		+#esdc.McDonalds_Playoffs						
		+#esdc.Panini									
		+#esdc.Papa_johns								
		+#esdc.Playoff_Tickets							
		+#esdc.Posada									
		+#esdc.Salute_to_Fans_Vote						
		+#esdc.SB50_Ring_Digital						
		+#esdc.SB50_Tickets							
		+#esdc.SB50_VIP								
		+#esdc.social									
		+#esdc.thankyoufans							
		+#esdc.United_in_OrangeHelmet_Hunt				
		+#esdc.Von_Miller_Contest						
		+#esdc.Web_Contest								
		+#esdc.Westrock								
		+#esdc.What_Would_You_Do_for_Broncos_Playoff_Tickets
		+#esdc.Xcel_Energy_Draft
		+#esdc.Xome_Playoffs	 
		+#esdc.Yahoo_Fantasy)AS ContestsEntered_Total,
	MAX( #emg.EmailGroup_Outlaws
		+#emg.EmailGroup_OrangeJuice
		+#emg.EmailGroup_OrangeHerd
		+#emg.EmailGroup_SurveyPanel
		+#emg.EmailGroup_BroncosPromos
		+#emg.EmailGroup_Stadium
		+#emg.EmailGroup_ICYMI)AS EmailGroup_Memberships_Total
INTO #sums FROM dbo.vwDImCustomer_ModAcctId ssbid WITH (NOLOCK)
LEFT JOIN #nge ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = #nge.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #esdc ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = #esdc.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #emg ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = #emg.SSB_CRMSYSTEM_CONTACT_ID
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_sums on #sums (SSB_CRMSYSTEM_CONTACT_ID)

update #sums set
Total_NonGame_events = case when Total_NonGame_events is null then 0 else Total_NonGame_events end,
ContestsEntered_Total = case when ContestsEntered_Total is null then 0 else ContestsEntered_Total end,
EmailGroup_Memberships_Total = case when EmailGroup_Memberships_Total is null then 0 else EmailGroup_Memberships_Total end


/****************************************************************************************************************/
IF OBJECT_ID('tempdb.dbo.#tex', 'U') IS NOT NULL
  DROP TABLE #tex; 
SELECT SSB_CRMSYSTEM_CONTACT_ID, SUM(R_Orig_Purchase_Price) OrigPrice_Total, SUM(R_TE_Purchase_Price) ResalePrice_Total, SUM(R_TE_Price_Difference) MarkupPaid_Total
INTO #tex FROM segmentation.vw__Ticket_Exchange_Recipient WITH (NOLOCK)
WHERE R_Season_Year = '2017' AND R_Event_Code LIKE 'GAME%'
GROUP BY SSB_CRMSYSTEM_CONTACT_ID
create clustered index idc_temp_tex on #tex (SSB_CRMSYSTEM_CONTACT_ID) 
/*****************************************************************************************************************/

--IF OBJECT_ID('tempdb.dbo.#tk', 'U') IS NOT NULL
--  DROP TABLE #tk; 
--
--SELECT  SSB_CRMSYSTEM_CONTACT_ID 
--	  ,tk.[TicketingSystemAccountID]			--Turnkey_Appends stuff that we will hopefiully get, I have no idea if this is the right join though. Will only be able to find out if we get data and can test it.
--      ,tk.[AgeinTwoYearIncrements1stIndividual]			--Maybe we can ask the Broncos to use an ID that already exists to make the join easier?
--      ,tk.[AgeinTwoYearIncrements2ndIndividual]
--      ,tk.[AgeinTwoYearIncrementsInputIndividual]
--	  ,tk.[DwellingType]
--	  ,tk.[BusinessOwner]
--	  ,tk.[Education1stIndividual]
--      ,tk.[Education2ndIndividual]
--      ,tk.[EducationInputIndividual]
--	  ,tk.[HomeAssessedValueRanges]
--      ,tk.[HomeFurnishingandDecoratingMOBs]
--      ,tk.[HomeMarketValue]
--      ,tk.[HomeOwnerRenter]
--      ,tk.[HomePropertyTypeDetail]
--      ,tk.[HomeSquareFootageActual]
--      ,tk.[HomeYearBuiltActual]
--      ,tk.[HouseholdAbilitecID]
--      ,tk.[IncomeEstimatedHousehold]
--      ,tk.[InfoBasePositiveMatchIndicator]
--      ,tk.[InvestingActive]
--	  ,tk.[MailOrderBuyer]
--      ,tk.[MailOrderDonor]
--      ,tk.[MailOrderResponder]
--	  ,tk.[LengthOfResidence]
--	  ,tk.[MotorcycleOwner]
--	  ,tk.[Occupation1stIndividual]
--      ,tk.[Occupation2ndIndividual]
--      ,tk.[OccupationDetailInputIndividual]
--      ,tk.[OccupationInputIndividual]
--	  ,tk.[OnlinePurchasingIndicator]
--	  ,tk.[RetailActivityDateofLast]
--      ,tk.[RetailPurchasesMostFrequentCategory]
--      ,tk.[RVOwner]
--	  ,tk.[TruckOwner]
--	  ,tk.[UpscaleRetailHighEndRetailBuyersUpscaleRetail]
--      ,tk.[UpscaleSpecialtyTravelPersonalServices]
--      ,tk.[VehicleDominantLifestyleIndicator]
--      ,tk.[VehicleKnownOwnedNumber]
--      ,tk.[VehicleNewCarBuyer]
--      ,tk.[VehicleNewUsedIndicator1stVehicle]
--      ,tk.[VehicleNewUsedIndicator2ndVehicle]
--      ,tk.[WorkingWoman]
--INTO #tk
--FROM ods.Turnkey_Appends tk WITH (NOLOCK) LEFT JOIN dbo.vwDimCustomer_ModAcctId ssbid WITH (NOLOCK) on tk.TicketingSystemAccountID = ssbid.ContactId
--CREATE CLUSTERED INDEX idc_temp_tk ON #tk (SSB_CRMSYSTEM_CONTACT_ID)


IF OBJECT_ID('dbo.TempFanFactors', 'U') IS NOT NULL
  DROP TABLE dbo.TempFanFactors; 

SELECT
        MAX(mcr.DimCustomerId)DimCustomerId,
        MAX(mcr.SourceDB)SourceDB,
        MAX(mcr.SourceSystem)SourceSystem,
        MAX(mcr.SSID)SSID,
        mcr.SSB_CRMSYSTEM_CONTACT_ID,
        MAX(mcr.SSB_CRMSYSTEM_ACCT_ID)SSB_CRMSYSTEM_ACCT_ID,
        MAX(mcr.FirstName) AS First_Name,
        MAX(mcr.LastName) AS Last_Name,
        MAX(mcr.Suffix)Suffix,
        MAX(mcr.Birthday)Birthday,
        MAX(mcr.CD_Gender) AS Gender,
		MAX(#prio.Cust_Priority)Cust_Priority,
        MAX(mcr.AddressPrimaryZip) AS AddressPrimary_Zip,
        MAX(mcr.AddressPrimaryState) AS AddressPrimary_State,
		MAX(CASE WHEN mcr.AddressPrimaryState = 'CO' THEN 1 ELSE 0 END) AS AddressPrimary_Colorado_Flag,
		MAX(CASE WHEN #wa.ssb_crmsystem_contact_id IS NOT NULL THEN 1 ELSE 0 END) AS WaitList_Flag,
		--MAX(wa.WaitListNum AS WaitList_Number), 
        MAX(mcr.UpdatedDate)UpdatedDate,
		MAX(CAST(mcr.IsDeleted AS INT))IsDeleted,
		MAX(CASE WHEN #eo.EmailOpened IS NULL THEN 0 ELSE 1 END) AS Email_Opened_Flag,
		MAX(#eo.MostRecentOpen) AS Email_Open_MostRecent,
		MAX(#eo.NumberEmailOpens) AS Email_Open_Qty,
		MAX(CASE WHEN #fs.FormSubmit IS NULL THEN 0 ELSE 1 END) AS Form_Submit_Flag,
		MAX(#fs.NumberFormsSubmitted) AS Form_Submit_Qty,
		MAX(CASE WHEN #crush.CrushMember IS NULL THEN 0 ELSE 1 END) AS CrushMember_Flag,
		MAX(CASE WHEN #bbunch.BunchMember IS NULL THEN 0 ELSE 1 END) AS BunchMember_Flag,
		MAX(CASE WHEN #emg.EmailGroup_OrangeJuice >= 1 THEN 1 ELSE 0 END) AS EmailGroup_OrangeJuice, 
		MAX(CASE WHEN #emg.EmailGroup_OrangeHerd >= 1 THEN 1 ELSE 0 END) AS EmailGroup_OrangeHerd, 
		MAX(CASE WHEN #emg.EmailGroup_ICYMI >= 1 THEN 1 ELSE 0 END) AS EmailGroup_ICYMI, 
		MAX(CASE WHEN #emg.EmailGroup_SurveyPanel >= 1 THEN 1 ELSE 0 END) AS EmailGroup_SurveyPanel, 
		MAX(CASE WHEN #emg.EmailGroup_BroncosPromos >= 1 THEN 1 ELSE 0 END) AS EmailGroup_BroncosPromos, 
		MAX(CASE WHEN #emg.EmailGroup_Stadium >= 1 THEN 1 ELSE 0 END) AS EmailGroup_Stadium, 
		MAX(CASE WHEN #emg.EmailGroup_Outlaws >= 1 THEN 1 ELSE 0 END) AS EmailGroup_Outlaws,
		MAX(#sums.EmailGroup_Memberships_Total)EmailGroup_Memberships_Total,
--		MAX(,#esdc.Arcade									 
--		MAX(,#esdc.Barclays_2016							 
--		MAX(,#esdc.Best_Seats_in_the_House					 
--		MAX(,#esdc.Bike_to_Work							 
--		MAX(,#esdc.BMW										 
--		MAX(,#esdc.Broncos_Bud_Light						 
--		MAX(,#esdc.Broncos_Bud_Light__Ring_of_Fame_Contest	 
--		MAX(,#esdc.Broncos_Bud_Light_Facebook				 
--		MAX(,#esdc.Broncos_Bud_Light_Ticket_Giveaway		 
--		MAX(,#esdc.Broncos_Budlight_Various_Contests		 
--		MAX(,#esdc.Broncos_Fanaticos						 
--		MAX(,#esdc.Bud_Light_Draft							 
--		MAX(,#esdc.Bud_Light_Up_for_Whatever_Contest		 
--		MAX(,#esdc.BWW										 
--		MAX(,#esdc.Canon_Shoot_Like_a_Pro_Contests			 
--		MAX(,#esdc.Carmax_2017								 
--		MAX(,#esdc.Carmax_VIP								 
--		MAX(,#esdc.CenturyLink_2017						 
--		MAX(,#esdc.CenturyLink_Dinner_with_a_Draft_Pick	 
--		MAX(,#esdc.Denver_Broncos_Kickoff_Kid				 
--		MAX(,#esdc.Dia_del_Nino							 
--		MAX(,#esdc.DirecTV_Fan_Fly_In						 
--		MAX(,#esdc.DirecTV_Fantasy_Football_Party			 
--		MAX(,#esdc.DirecTV_Fly_In							 
--		MAX(,#esdc.DirecTV_Fly_In_2015						 
--		MAX(,#esdc.En_tu_Casa								 
--		MAX(,#esdc.Espanol_Prize_Registration				 
--		MAX(,#esdc.Facebook_Ticket_Giveaway_Broncos_vs_Colts
--		MAX(,#esdc.Famous_Daves_Mini_Miles_Entries			
--		MAX(,#esdc.Fan_Pack								
--		MAX(,#esdc.Fanaticos_Fathers_Day					
--		MAX(,#esdc.Fanaticos_Giveaway						
--		MAX(,#esdc.Fast_Dash								
--		MAX(,#esdc.Free_Tickets							
--		MAX(,#esdc.Gameday_2016_Season						
--		MAX(,#esdc.Gameday_Preview							
--		MAX(,#esdc.Grease_Monkey_2017						
--		MAX(,#esdc.Guess_the_Schedule						
--		MAX(,#esdc.Hackathon								
--		MAX(,#esdc.HelmetForHelmet							
--		MAX(,#esdc.[Indi.com]								
--		MAX(,#esdc.Jack_Black								
--		MAX(,#esdc.Kickoff_Kid								
--		MAX(,#esdc.King_Soopers							
--		MAX(,#esdc.Kwal_Paint_Winner						
--		MAX(,#esdc.Levis									
--		MAX(,#esdc.Mcdonalds_key_tag						
--		MAX(,#esdc.McDonalds_Playoffs						
--		MAX(,#esdc.Panini									
--		MAX(,#esdc.Papa_johns								
--		MAX(,#esdc.Playoff_Tickets							
--		MAX(,#esdc.Posada									
--		MAX(,#esdc.Salute_to_Fans_Vote						
--		MAX(,#esdc.SB50_Ring_Digital						
--		MAX(,#esdc.SB50_Tickets							
--		MAX(,#esdc.SB50_VIP								
--		MAX(,#esdc.social									
--		MAX(,#esdc.thankyoufans							
--		MAX(,#esdc.United_in_OrangeHelmet_Hunt				
--		MAX(,#esdc.Von_Miller_Contest						
--		MAX(,#esdc.Web_Contest								
--		MAX(,#esdc.Westrock								
--		MAX(,#esdc.What_Would_You_Do_for_Broncos_Playoff_Tickets
--		MAX(,#esdc.Xcel_Energy_Draft
--		MAX(,#esdc.Xome_Playoffs	 
--		MAX(,#esdc.Yahoo_Fantasy	 
--		MAX(,#nge.[45_day_challenge]
--		MAX(,#nge.[45_Day_Fitness_Fall_2016]
--		MAX(,#nge.All_You_Can_Eat_Tailgate
--		MAX(,#nge.Broadnet_2017
--		MAX(,#nge.Broncos_7K_2015
--		MAX(,#nge.Broncos_7K_Registration_2014
--		MAX(,#nge.Broncos_Bunch_Movie_Night
--		MAX(,#nge.Broncos_Bunch_Trick_or_Treat
--		MAX(,#nge.Bunch_Kids_Day
--		MAX(,#nge.Bunch_Movie_Night_RSVP
--		MAX(,#nge.Bunch_Movie_Night_RSVP_2016
--		MAX(,#nge.Bunch_Summer_Kickoff_RSVP
--		MAX(,#nge.Bunch_training_camp
--		MAX(,#nge.Bunch_trick_of_treat
--		MAX(,#nge.Carne_Asada_Flea_Market_2017
--		MAX(,#nge.Carne_Asada_Greeley_2017
--		MAX(,#nge.Crush_Night_Out
--		MAX(,#nge.Denver_7K_2017
--		MAX(,#nge.Espanol
--		MAX(,#nge.Espanol_2017
--		MAX(,#nge.Expo_2016
--		MAX(,#nge.Expo_2017
--		MAX(,#nge.Expo_Survey_collect
--		MAX(,#nge.Fan_Forum
--		MAX(,#nge.Greeley_Salute_to_Fans
--		MAX(,#nge.Mountain_Village_2016
--		MAX(,#nge.Mountain_Village_2017
--		MAX(,#nge.Orange_County
--		MAX(,#nge.Philadelphia
--		MAX(,#nge.Salute_to_Fans
--		MAX(,#nge.Salute_to_Fans_2016
--		MAX(,#nge.Training_Camp_2016
--		MAX(,#nge.Training_Camp_2017
		MAX(#sums.Total_NonGame_Events) AS NonGameEvents_Total,
		MAX(#sums.ContestsEntered_Total)ContestsEntered_Total,
		MAX(#ltpd.RecentPurchase) AS Tickets_LastPurchase_Date,
		MAX(DATEDIFF(DAY, #ltpd.RecentPurchase, GETDATE())) AS Tickets_DaysSince_LastPurchase,
        MAX(#ltpd.Ticket_TotalPaid) AS Tickets_TotalPaid,
        MAX(#ltpd.QtySeat) AS Tickets_TotalQty,
		MAX(#ltpd.Suite_Club_Flag)Suite_Club_Flag,
		MAX(#ltlf.LicenseFees_TotalPaid)LicenseFees_TotalPaid,
		MAX(#tex.OrigPrice_Total)OrigPrice_Total,
		MAX(#tex.ResalePrice_Total)ResalePrice_Total,
		MAX(#tex.MarkupPaid_Total)MarkupPaid_Total,
		MAX(#dsa.AttendedThreeYears) AS Tickets_Attendance_Three_Years,  --Recency and frequency of attendance are here, I am not sure what else they want with this.
		MAX(#dsa2.AttendedOneYear) AS Tickets_Attendance_One_Year,
		MAX(#dsa.MaxAttended) AS Tickets_Attendance_MostRecent_Date,
		MAX(#att.AttendedTrickOrTreat) AS Attended_TrickOrTreat,
		MAX(#att.AttendedTDHOF) AS Attended_TD_HOF_Celebration,
		MAX(#att.AttendedHolidayPicture) AS Attended_HolidayPhoto,
		MAX(#merch.MaxOrderDate)        AS Fanatics_MaxOrderDate,
		MAX(#merch.TotalSpent_30Days)   AS Fanatics_TotalSpent_30Days,                 
		MAX(#merch.TotalSpent_90Days)   AS Fanatics_TotalSpent_90Days, 
		MAX(#merch.TotalSpent_Year)  AS Fanatics_TotalSpent_Year,
		MAX(#merch.TotalSpent_LifeTime) AS Fanatics_TotalSpent_LifeTime,
		MAX(#woo.MaxOrderDate)        AS WooCommerce_MaxOrderDate,
		MAX(#woo.TotalSpent_30Days)   AS WooCommerce_TotalSpent_30Days,                 
		MAX(#woo.TotalSpent_90Days)   AS WooCommerce_TotalSpent_90Days, 
		MAX(#woo.TotalSpent_Year)  AS	   WooCommerce_TotalSpent_Year,
		MAX(#woo.TotalSpent_LifeTime) AS WooCommerce_TotalSpent_LifeTime,
		MAX(#fc.Sunday_ticket)Sunday_ticket,
		MAX(#fc.Fantasy)Fantasy,
		MAX(#fc.Pickem)Pickem
--		,#tk.[AgeinTwoYearIncrements2ndIndividual]
--		,#tk.[AgeinTwoYearIncrementsInputIndividual]
--		,#tk.[DwellingType]
--		,#tk.[BusinessOwner]
--		,#tk.[Education1stIndividual]
--		,#tk.[Education2ndIndividual]
--		,#tk.[EducationInputIndividual]
--		,#tk.[HomeAssessedValueRanges]
--		,#tk.[HomeFurnishingandDecoratingMOBs]
--		,#tk.[HomeMarketValue]
--		,#tk.[HomeOwnerRenter]
--		,#tk.[HomePropertyTypeDetail]
--		,#tk.[HomeSquareFootageActual]
--		,#tk.[HomeYearBuiltActual]
--		,#tk.[HouseholdAbilitecID]
--		,#tk.[IncomeEstimatedHousehold]
--		,#tk.[InfoBasePositiveMatchIndicator]
--		,#tk.[AgeinTwoYearIncrements1stIndividual]
--		,#tk.[InvestingActive]
--		,#tk.[MailOrderBuyer]
--		,#tk.[MailOrderDonor]
--		,#tk.[MailOrderResponder]
--		,#tk.[LengthOfResidence]
--		,#tk.[MotorcycleOwner]
--		,#tk.[Occupation1stIndividual]
--		,#tk.[Occupation2ndIndividual]
--		,#tk.[OccupationDetailInputIndividual]
--		,#tk.[OccupationInputIndividual]
--		,#tk.[OnlinePurchasingIndicator]
--		,#tk.[RetailActivityDateofLast]
--		,#tk.[RetailPurchasesMostFrequentCategory]
--		,#tk.[RVOwner]
--		,#tk.[TruckOwner]
--		,#tk.[UpscaleRetailHighEndRetailBuyersUpscaleRetail]
--		,#tk.[UpscaleSpecialtyTravelPersonalServices]
--		,#tk.[VehicleDominantLifestyleIndicator]
--		,#tk.[VehicleKnownOwnedNumber]
--		,#tk.[VehicleNewCarBuyer]
--		,#tk.[VehicleNewUsedIndicator1stVehicle]
--		,#tk.[VehicleNewUsedIndicator2ndVehicle]
--		,#tk.[WorkingWoman]
INTO dbo.TempFanFactors
FROM    mdm.CompositeRecord mcr WITH (NOLOCK) 
LEFT JOIN #ltpd
    ON #ltpd.[SSB_CRMSYSTEM_CONTACT_ID] = mcr.[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN		--WooCommerce Orders
	#Woo ON mcr.SSB_CRMSYSTEM_CONTACT_ID = #Woo.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN		--Fanatics Orders
	#merch ON mcr.SSB_CRMSYSTEM_CONTACT_ID = #merch.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN  #wa 
	ON #wa.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN 
	#crush ON mcr.SSB_CRMSYSTEM_CONTACT_ID = #crush.CrushMember
LEFT JOIN 
	#bbunch ON mcr.SSB_CRMSYSTEM_CONTACT_ID = #bbunch.BunchMember
LEFT JOIN 
	#emg ON #emg.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN						--Email opens, from Eloqua
	#eo ON #eo.EmailOpened = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN 						--Online form submits, from Eloqua							
	#fs ON #fs.FormSubmit = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #dsa
	ON #dsa.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #dsa2
	ON #dsa2.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #att
	ON #att.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN  
	#fc ON #fc.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN 
	#esdc ON #esdc.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN  
	#nge ON #nge.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN
	#sums ON #sums.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN
	#tex ON #tex.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN
	#ltlf ON #ltlf.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN
	#prio ON #prio.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
--LEFT JOIN
--	#tk ON #tk.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID
WHERE mcr.SSB_CRMSYSTEM_CONTACT_ID NOT IN (SELECT SSB_CRMSYSTEM_CONTACT_ID FROM mdm.CompositeRecord WHERE EmailPrimary LIKE '%broncos.nfl%')
GROUP BY mcr.SSB_CRMSYSTEM_CONTACT_ID



GO
