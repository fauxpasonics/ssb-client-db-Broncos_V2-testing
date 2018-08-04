SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













--re-order, make everything pretty, make more readable
--Is emailable, has bought recently

--SELECT TOP 1000 * FROM ro.vw_FanFactors

CREATE VIEW [ro].[vw_FanFactors_BKP_AMEITIN] AS

/*

SELECT * FROM ro.vw_FanFactors WHERE SSB_CRMSYSTEM_CONTACT_ID IN (

SELECT ssb_crmsystem_contact_Id
FROM ro.vw_fanfactors
GROUP BY  ssb_crmsystem_contact_id
HAVING COUNT(*) > 1

)
ORDER BY 5

*/

SELECT
        mcr.DimCustomerId,
        mcr.SourceDB,
        mcr.SourceSystem,
        mcr.SSID,
        mcr.SSB_CRMSYSTEM_CONTACT_ID,
        mcr.SSB_CRMSYSTEM_ACCT_ID,
        mcr.FirstName AS First_Name,
        mcr.LastName AS Last_Name,
        mcr.Suffix,
        mcr.Birthday,
        mcr.CD_Gender AS Gender,
        mcr.AddressPrimaryZip AS AddressPrimary_Zip,
        mcr.AddressPrimaryState AS AddressPrimary_State,
		CASE WHEN mcr.AddressPrimaryState = 'CO' THEN 1 ELSE 0 END AS Colorado_PrimaryAddress_Flag,
		CASE WHEN wa.ssb_crmsystem_contact_id IS NOT NULL THEN 1 ELSE 0 END AS WaitList_Flag,
		--wa.WaitListNum AS WaitList_Number, 
        mcr.UpdatedDate,
		mcr.IsDeleted,
		CASE WHEN eo.EmailOpened IS NULL THEN 0 ELSE 1 END AS Email_Opened
		,eo.MostRecentOpen AS Most_Recent_Email_Open
		,eo.NumberEmailOpens AS Number_Emails_Opened
		,CASE WHEN fs.FormSubmit IS NULL THEN 0 ELSE 1 END AS FormSubmit_Flag
		,fs.NumberFormsSubmitted AS Number_Forms_Submitted,
		CASE WHEN crush.CrushMember IS NULL THEN 0 ELSE 1 END AS CrushMember_Flag,
		CASE WHEN bbunch.BunchMember IS NULL THEN 0 ELSE 1 END AS BunchMember,
		CASE WHEN emg.OrangeJuice >= 1 THEN 1 ELSE 0 END AS OrangeJuice, 
		CASE WHEN emg.OrangeHerd >= 1 THEN 1 ELSE 0 END AS OrangeHerd, 
		CASE WHEN emg.ICYMI >= 1 THEN 1 ELSE 0 END AS ICYMI, 
		CASE WHEN emg.SurveyPanel >= 1 THEN 1 ELSE 0 END AS SurveyPanel, 
		CASE WHEN emg.BroncosPromos >= 1 THEN 1 ELSE 0 END AS BroncosPromos, 
		CASE WHEN emg.Stadium >= 1 THEN 1 ELSE 0 END AS Stadium, 
		CASE WHEN emg.Outlaws >= 1 THEN 1 ELSE 0 END AS Outlaws 
		,esdc.Arcade									 
		,esdc.Barclays_2016							 
		,esdc.Best_Seats_in_the_House					 
		,esdc.Bike_to_Work							 
		,esdc.BMW										 
		,esdc.Broncos_Bud_Light						 
		,esdc.Broncos_Bud_Light__Ring_of_Fame_Contest	 
		,esdc.Broncos_Bud_Light_Facebook				 
		,esdc.Broncos_Bud_Light_Ticket_Giveaway		 
		,esdc.Broncos_Budlight_Various_Contests		 
		,esdc.Broncos_Fanaticos						 
		,esdc.Bud_Light_Draft							 
		,esdc.Bud_Light_Up_for_Whatever_Contest		 
		,esdc.BWW										 
		,esdc.Canon_Shoot_Like_a_Pro_Contests			 
		,esdc.Carmax_2017								 
		,esdc.Carmax_VIP								 
		,esdc.CenturyLink_2017						 
		,esdc.CenturyLink_Dinner_with_a_Draft_Pick	 
		,esdc.Denver_Broncos_Kickoff_Kid				 
		,esdc.Dia_del_Nino							 
		,esdc.DirecTV_Fan_Fly_In						 
		,esdc.DirecTV_Fantasy_Football_Party			 
		,esdc.DirecTV_Fly_In							 
		,esdc.DirecTV_Fly_In_2015						 
		,esdc.En_tu_Casa								 
		,esdc.Espanol_Prize_Registration				 
		,esdc.Facebook_Ticket_Giveaway_Broncos_vs_Colts
		,esdc.Famous_Daves_Mini_Miles_Entries			
		,esdc.Fan_Pack								
		,esdc.Fanaticos_Fathers_Day					
		,esdc.Fanaticos_Giveaway						
		,esdc.Fast_Dash								
		,esdc.Free_Tickets							
		,esdc.Gameday_2016_Season						
		,esdc.Gameday_Preview							
		,esdc.Grease_Monkey_2017						
		,esdc.Guess_the_Schedule						
		,esdc.Hackathon								
		,esdc.HelmetForHelmet							
		,esdc.[Indi.com]								
		,esdc.Jack_Black								
		,esdc.Kickoff_Kid								
		,esdc.King_Soopers							
		,esdc.Kwal_Paint_Winner						
		,esdc.Levis									
		,esdc.Mcdonalds_key_tag						
		,esdc.McDonalds_Playoffs						
		,esdc.Panini									
		,esdc.Papa_johns								
		,esdc.Playoff_Tickets							
		,esdc.Posada									
		,esdc.Salute_to_Fans_Vote						
		,esdc.SB50_Ring_Digital						
		,esdc.SB50_Tickets							
		,esdc.SB50_VIP								
		,esdc.social									
		,esdc.thankyoufans							
		,esdc.United_in_OrangeHelmet_Hunt				
		,esdc.Von_Miller_Contest						
		,esdc.Web_Contest								
		,esdc.Westrock								
		,esdc.What_Would_You_Do_for_Broncos_Playoff_Tickets
		,esdc.Xcel_Energy_Draft
		,esdc.Xome_Playoffs	 
		,esdc.Yahoo_Fantasy	 
		,nge.[45_day_challenge]
		,nge.[45_Day_Fitness_Fall_2016]
		,nge.All_You_Can_Eat_Tailgate
		,nge.Broadnet_2017
		,nge.Broncos_7K_2015
		,nge.Broncos_7K_Registration_2014
		,nge.Broncos_Bunch_Movie_Night
		,nge.Broncos_Bunch_Trick_or_Treat
		,nge.Bunch_Kids_Day
		,nge.Bunch_Movie_Night_RSVP
		,nge.Bunch_Movie_Night_RSVP_2016
		,nge.Bunch_Summer_Kickoff_RSVP
		,nge.Bunch_training_camp
		,nge.Bunch_trick_of_treat
		,nge.Carne_Asada_Flea_Market_2017
		,nge.Carne_Asada_Greeley_2017
		,nge.Crush_Night_Out
		,nge.Denver_7K_2017
		,nge.Espanol
		,nge.Espanol_2017
		,nge.Expo_2016
		,nge.Expo_2017
		,nge.Expo_Survey_collect
		,nge.Fan_Forum
		,nge.Greeley_Salute_to_Fans
		,nge.Mountain_Village_2016
		,nge.Mountain_Village_2017
		,nge.Orange_County
		,nge.Philadelphia
		,nge.Salute_to_Fans
		,nge.Salute_to_Fans_2016
		,nge.Training_Camp_2016
		,nge.Training_Camp_2017
		,ltpd.RecentPurchase AS Tickets_LastPurchase_Date,
		DATEDIFF(DAY, ltpd.RecentPurchase, GETDATE()) AS Tickets_DaysSince_LastPurchase,
        ltpd.Ticket_TotalPaid AS Tickets_TotalPaid,
        ltpd.QtySeat AS Tickets_TotalQty,
		dsa.AttendedThreeYears AS Tickets_Attendance_Three_Years,
		dsa2.AttendedOneYear AS Tickets_Attendance_One_Year,
		dsa.MaxAttended AS Tickets_Attendance_MostRecent_Date,
		tot.AttendedTrickOrTreat AS Attended_TrickOrTreat,
		tdhof.AttendedTDHOF AS Attended_TD_HOF_Celebration,
		holp.AttendedHolidayPicture AS Attended_HolidayPhoto,
		merch.MaxOrderDate        AS Fanatics_MaxOrderDate,
		merch.TotalSpent_30Days   AS Fanatics_TotalSpent_30Days,                 
		merch.TotalSpent_90Days   AS Fanatics_TotalSpent_90Days, 
		merch.TotalSpent_Year  AS Fanatics_TotalSpent_Year,
		merch.TotalSpent_LifeTime AS Fanatics_TotalSpent_LifeTime,
		woo.MaxOrderDate        AS WooCommerce_MaxOrderDate,
		woo.TotalSpent_30Days   AS WooCommerce_TotalSpent_30Days,                 
		woo.TotalSpent_90Days   AS WooCommerce_TotalSpent_90Days, 
		woo.TotalSpent_Year  AS	   WooCommerce_TotalSpent_Year,
		woo.TotalSpent_LifeTime AS WooCommerce_TotalSpent_LifeTime,
		fc.Sunday_ticket,
		fc.Fantasy,
		fc.Pickem
--		,tk.[AgeinTwoYearIncrements2ndIndividual]
--		,tk.[AgeinTwoYearIncrementsInputIndividual]
--		,tk.[DwellingType]
--		,tk.[BusinessOwner]
--		,tk.[Education1stIndividual]
--		,tk.[Education2ndIndividual]
--		,tk.[EducationInputIndividual]
--		,tk.[HomeAssessedValueRanges]
--		,tk.[HomeFurnishingandDecoratingMOBs]
--		,tk.[HomeMarketValue]
--		,tk.[HomeOwnerRenter]
--		,tk.[HomePropertyTypeDetail]
--		,tk.[HomeSquareFootageActual]
--		,tk.[HomeYearBuiltActual]
--		,tk.[HouseholdAbilitecID]
--		,tk.[IncomeEstimatedHousehold]
--		,tk.[InfoBasePositiveMatchIndicator]
--		,tk.[AgeinTwoYearIncrements1stIndividual]
--		,tk.[InvestingActive]
--		,tk.[MailOrderBuyer]
--		,tk.[MailOrderDonor]
--		,tk.[MailOrderResponder]
--		,tk.[LengthOfResidence]
--		,tk.[MotorcycleOwner]
--		,tk.[Occupation1stIndividual]
--		,tk.[Occupation2ndIndividual]
--		,tk.[OccupationDetailInputIndividual]
--		,tk.[OccupationInputIndividual]
--		,tk.[OnlinePurchasingIndicator]
--		,tk.[RetailActivityDateofLast]
--		,tk.[RetailPurchasesMostFrequentCategory]
--		,tk.[RVOwner]
--		,tk.[TruckOwner]
--		,tk.[UpscaleRetailHighEndRetailBuyersUpscaleRetail]
--		,tk.[UpscaleSpecialtyTravelPersonalServices]
--		,tk.[VehicleDominantLifestyleIndicator]
--		,tk.[VehicleKnownOwnedNumber]
--		,tk.[VehicleNewCarBuyer]
--		,tk.[VehicleNewUsedIndicator1stVehicle]
--		,tk.[VehicleNewUsedIndicator2ndVehicle]
--		,tk.[WorkingWoman]
		FROM    mdm.CompositeRecord mcr WITH (NOLOCK) 

LEFT JOIN		--This is the ticket purchase information
     (
          SELECT
                [b].[SSB_CRMSYSTEM_CONTACT_ID],
                MAX(SSCreatedDate) AS RecentPurchase,
				SUM(CASE WHEN SSCreatedDate >= DATEADD(YEAR,-1,GETDATE()) THEN QtySeat	ELSE 0 END) AS PurchaseLastYear,
                SUM(CASE WHEN fts.PaidAmount IS NULL THEN 0 ELSE fts.PaidAmount END) AS Ticket_TotalPaid,
				SUM(CASE WHEN QtySeat IS NULL THEN 0 ELSE QtySeat END) AS QtySeat
          FROM  (SELECT PaidAmount, QtySeat, SSCreatedDate, DimcustomerId FROM [dbo].[FactTicketSales]  WITH (NOLOCK) WHERE DimSeasonId IN (4,22,50,77)
		  UNION 
		  SELECT PaidAmount, QtySeat, SSCreatedDate, DimcustomerId FROM
		  dbo.FactTicketSalesHistory WITH (NOLOCK) WHERE DimSeasonId IN (4,22,50,77) ) fts
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
     ) ltpd
     ON ltpd.[SSB_CRMSYSTEM_CONTACT_ID] = mcr.[SSB_CRMSYSTEM_CONTACT_ID]


 LEFT JOIN		--WooCommerce Orders
(   SELECT

		SSB_CRMSYSTEM_CONTACT_ID
		, MAX(MaxOrderDate)			 AS MaxOrderDate
		, SUM(t.TotalSpent_30Days)	 AS TotalSpent_30Days	
		, SUM(t.TotalSpent_90Days)	 AS TotalSpent_90Days	
		, SUM(t.TotalSpent_Year)	 AS TotalSpent_Year	
		, SUM(t.TotalSpent_Lifetime) AS TotalSpent_Lifetime

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
) Woo ON mcr.SSB_CRMSYSTEM_CONTACT_ID = Woo.SSB_CRMSYSTEM_CONTACT_ID

  LEFT JOIN		--Fanatics Orders
(   SELECT

		SSB_CRMSYSTEM_CONTACT_ID
		, MAX(MaxOrderDate)			 AS MaxOrderDate
		, SUM(t.TotalSpent_30Days)	 AS TotalSpent_30Days	
		, SUM(t.TotalSpent_90Days)	 AS TotalSpent_90Days	
		, SUM(t.TotalSpent_Year)	 AS TotalSpent_Year	
		, SUM(t.TotalSpent_Lifetime) AS TotalSpent_Lifetime
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
) merch ON mcr.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID

--LEFT JOIN( SELECT [TicketingSystemAccountID]			--Turnkey_Appends stuff that we will hopefiully get, I have no idea if this is the right join though. Will only be able to find out if we get data and can test it.
--      ,[AgeinTwoYearIncrements1stIndividual]			--Maybe we can ask the Broncos to use an ID that already exists to make the join easier?
--      ,[AgeinTwoYearIncrements2ndIndividual]
--      ,[AgeinTwoYearIncrementsInputIndividual]
--	  ,[DwellingType]
--	  ,[BusinessOwner]
--	  ,[Education1stIndividual]
--      ,[Education2ndIndividual]
--      ,[EducationInputIndividual]
--	  ,[HomeAssessedValueRanges]
--      ,[HomeFurnishingandDecoratingMOBs]
--      ,[HomeMarketValue]
--      ,[HomeOwnerRenter]
--      ,[HomePropertyTypeDetail]
--      ,[HomeSquareFootageActual]
--      ,[HomeYearBuiltActual]
--      ,[HouseholdAbilitecID]
--      ,[IncomeEstimatedHousehold]
--      ,[InfoBasePositiveMatchIndicator]
--      ,[InvestingActive]
--	  ,[MailOrderBuyer]
--      ,[MailOrderDonor]
--      ,[MailOrderResponder]
--	  ,[LengthOfResidence]
--	  ,[MotorcycleOwner]
--	  ,[Occupation1stIndividual]
--      ,[Occupation2ndIndividual]
--      ,[OccupationDetailInputIndividual]
--      ,[OccupationInputIndividual]
--	  ,[OnlinePurchasingIndicator]
--	  ,[RetailActivityDateofLast]
--      ,[RetailPurchasesMostFrequentCategory]
--      ,[RVOwner]
--	  ,[TruckOwner]
--	  ,[UpscaleRetailHighEndRetailBuyersUpscaleRetail]
--      ,[UpscaleSpecialtyTravelPersonalServices]
--      ,[VehicleDominantLifestyleIndicator]
--      ,[VehicleKnownOwnedNumber]
--      ,[VehicleNewCarBuyer]
--      ,[VehicleNewUsedIndicator1stVehicle]
--      ,[VehicleNewUsedIndicator2ndVehicle]
--      ,[WorkingWoman]
--FROM ods.Turnkey_Appends) tk on tk.TicketingSystemAccountID = mcr.ContactId


LEFT JOIN (
 SELECT distinct ssb_crmsystem_contact_id FROM dbo.SeasonTicket_WaitList w WITH (NOLOCK) 
 LEFT JOIN dbo.vwDimCustomer_ModAcctId dc WITH (NOLOCK) ON w.AccountID = dc.accountid AND dc.sourcesystem = 'TM' AND dc.customertype = 'Primary' ) wa 
	ON wa.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID

LEFT JOIN (						--Crush Member Status
SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID AS CrushMember FROM ods.EloquaCustom_CrushMembers cm WITH (NOLOCK) INNER JOIN dbo.vwdimcustomer_modacctid dc
ON cm.EmailAddress = dc.EmailPrimary) crush ON mcr.SSB_CRMSYSTEM_CONTACT_ID = crush.CrushMember

LEFT JOIN (						--Child is Broncos Bunch Member Status
SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID AS BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList bb WITH (NOLOCK) INNER JOIN dbo.vwdimcustomer_modacctid dc
ON bb.Parents_Email_Address1 = dc.EmailPrimary) bbunch ON mcr.SSB_CRMSYSTEM_CONTACT_ID = bbunch.BunchMember

LEFT JOIN (						--EMail Group subscription flags
SELECT
ssbid.SSB_CRMSYSTEM_CONTACT_ID,
SUM(CASE WHEN egm.EmailGroup = 'OrangeJuice' THEN 1 ELSE 0 END) OrangeJuice, 
SUM(CASE WHEN egm.EmailGroup = 'SurveyPanel' THEN 1 ELSE 0 END) SUrveyPanel, 
SUM(CASE WHEN egm.EmailGroup = 'BroncosPromos' THEN 1 ELSE 0 END) BroncosPromos, 
SUM(CASE WHEN egm.EmailGroup = 'Stadium' THEN 1 ELSE 0 END) Stadium, 
SUM(CASE WHEN egm.EmailGroup = 'OrangeHerd' THEN 1 ELSE 0 END) OrangeHerd, 
SUM(CASE WHEN egm.EmailGroup = 'ICYMI' THEN 1 ELSE 0 END) ICYMI, 
SUM(CASE WHEN egm.EmailGroup = 'Outlaws' THEN 1 ELSE 0 END) Outlaws
FROM ods.EloquaCustom_EmailGroupMembers egm WITH (NOLOCK)
LEFT JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON CAST(egm.ContactID AS NVARCHAR(200)) = ssbid.ssid --AND ssbid.SourceSystem = 'Eloqua Broncos'-- AND ssbid.sourcesystem = 'Fancentric'
WHERE ETL_IsDeleted = 0 AND ssbid.SourceSystem = 'Eloqua Broncos'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
) emg ON emg.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID

LEFT JOIN						--Email opens, from Eloqua
(SELECT dc.SSB_CRMSYSTEM_CONTACT_ID AS EmailOpened, MAX(o.CreatedAt) AS MostRecentOpen, COUNT(*) AS NumberEmailOpens				
FROM ods.Eloqua_ActivityEmailOpen o WITH (NOLOCK)
INNER JOIN dbo.dimcustomerssbid dc ON CAST(o.ContactId AS NVARCHAR(200)) =  dc.SSID  AND dc.SourceSystem = 'Eloqua Broncos'			
GROUP BY dc.SSB_CRMSYSTEM_CONTACT_ID) 
eo ON eo.EmailOpened = mcr.SSB_CRMSYSTEM_CONTACT_ID
--
LEFT JOIN 						--Online form submits, from Eloqua							
(SELECT dc.SSB_CRMSYSTEM_CONTACT_ID AS FormSubmit, COUNT(*) AS NumberFormsSubmitted FROM ods.Eloqua_ActivityFormSubmit f WITH (NOLOCK)
INNER JOIN dbo.vwdimcustomer_modacctid dc ON CAST(f.ContactId AS NVARCHAR(200)) = dc.SSID AND dc.SourceSystem = 'Eloqua Broncos'
GROUP BY dc.SSB_CRMSYSTEM_CONTACT_ID) 
fs ON fs.FormSubmit = mcr.SSB_CRMSYSTEM_CONTACT_ID

/*  Need to load historical data, limit to Broncos seasons based on event  */
LEFT JOIN(						--Game attendance within the last three years
SELECT x.SSB_CRMSYSTEM_CONTACT_ID, MAX(x.AttendedThreeYears) AttendedThreeYears, MAX(x.MaxAttended) MaxAttended
FROM (
SELECT dc.ssb_crmsystem_contact_id, CASE WHEN ScanDateTime > DATEADD(YEAR,-3,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedThreeYears'
, ScanDateTime AS 'MaxAttended'
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
INNER JOIN dbo.dimseason ds WITH (NOLOCK) ON de.DimSeasonId = ds.DimSeasonId
WHERE ds.DimSeasonId IN (4,22,50,77)
) x
GROUP BY x.ssb_crmsystem_contact_id
) dsa
ON dsa.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID

LEFT JOIN(					--Game attendance within the last year
SELECT y.SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT CASE WHEN y.AttendedOneYear = 1 THEN y.DimEventId ELSE NULL END) attendedoneyear
FROM (
SELECT dc.ssb_crmsystem_contact_id, de.dimeventid, CASE WHEN ScanDateTime > DATEADD(YEAR,-1,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedOneYear' 
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
INNER JOIN dbo.dimseason ds WITH (NOLOCK) ON de.DimSeasonId = ds.DimSeasonId
WHERE ds.DimSeasonId IN (4,22,50,77)
) y
GROUP BY y.SSB_CRMSYSTEM_CONTACT_ID
) dsa2
ON dsa2.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID


LEFT JOIN(						--trick or treat event attendance
SELECT y.SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT CASE WHEN y.AttendedTrickOrTreat = 1 THEN y.DimEventId ELSE NULL END) attendedtrickortreat
FROM (
SELECT dc.ssb_crmsystem_contact_id, de.dimeventid, CASE WHEN ScanDateTime > DATEADD(YEAR,-1,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedTrickOrTreat' 
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
WHERE de.DimEventId IN (344, 345, 346)
) y
GROUP BY y.SSB_CRMSYSTEM_CONTACT_ID
) tot
ON dsa2.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID

LEFT JOIN(					--TD HOF celebration attendance
SELECT y.SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT CASE WHEN y.AttendedTDHOF = 1 THEN y.DimEventId ELSE NULL END) attendedTDHOF
FROM (
SELECT dc.ssb_crmsystem_contact_id, de.dimeventid, CASE WHEN ScanDateTime > DATEADD(YEAR,-1,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedTDHOF' 
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
WHERE de.DimEventId IN (352)
) y
GROUP BY y.SSB_CRMSYSTEM_CONTACT_ID
) tdhof
ON dsa2.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID

LEFT JOIN(						--Holiday Photos attendance
SELECT y.SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT CASE WHEN y.AttendedHolidayPicture = 1 THEN y.DimEventId ELSE NULL END) attendedHolidayPicture
FROM (
SELECT dc.ssb_crmsystem_contact_id, de.dimeventid, CASE WHEN ScanDateTime > DATEADD(YEAR,-1,GETDATE()) THEN 1 ELSE 0 END AS 'AttendedHolidayPicture' 
FROM dbo.FactAttendance fa WITH (NOLOCK)
INNER JOIN dbo.dimevent de WITH (NOLOCK) ON fa.DimEventId = de.DimEventId --AND de.DimEventId IN (SELECT DimEventId FROM dbo.DimEvent WHERE EventCode LIKE 'GAME%') --This ensures that it is only for Football Games
INNER JOIN dbo.dimcustomerssbid dc  WITH (NOLOCK) ON fa.DimCustomerId = dc.DimCustomerId
WHERE de.DimEventId IN (353, 354, 355,356)
) y
GROUP BY y.SSB_CRMSYSTEM_CONTACT_ID
) holp
ON dsa2.ssb_crmsystem_contact_id = mcr.SSB_CRMSYSTEM_CONTACT_ID

LEFT JOIN (SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, SUM(CASE WHEN f.DTV_SUNDAY_TICKET_ACTIVE_FLG = 'Y' THEN 1 ELSE 0 END) Sunday_ticket, --Information on NFL Fantasy and NFL Sunday Ticket subscriptions
SUM(CASE WHEN LEFT(f.FANTASY_LST_VST_DT,4) >= 2017 THEN 1 ELSE 0 END) Fantasy
, SUM(CASE WHEN LEFT(f.LST_PICKEM_SSN_REG_DT,4) >= 2017 THEN 1 ELSE 0 END) Pickem FROM ods.FanCentric_Customers  f WITH (NOLOCK)
LEFT JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON f.cust_id = ssbid.ssid AND ssbid.sourcesystem = 'Fancentric'
WHERE ETL_IsDeleted = 0
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
) fc ON fc.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID


LEFT JOIN (		--Contest indices, flag 1 for participation. List of desired contests came from Broncos, data found in custom Eloqua object
SELECT
ssbid.SSB_CRMSYSTEM_CONTACT_ID,
SUM(CASE WHEN ecsd.Source1 = 'Arcade' THEN 1 ELSE 0 END) Arcade, 
SUM(CASE WHEN ecsd.Source1 = 'Barclays 2016' THEN 1 ELSE 0 END) Barclays_2016, 
SUM(CASE WHEN ecsd.Source1 = 'Best Seats in the House' THEN 1 ELSE 0 END) Best_Seats_in_the_House, 
SUM(CASE WHEN ecsd.Source1 = 'Bike to Work' THEN 1 ELSE 0 END) Bike_to_Work, 
SUM(CASE WHEN ecsd.Source1 = 'BMW' THEN 1 ELSE 0 END) BMW, 
SUM(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light' THEN 1 ELSE 0 END) Broncos_Bud_Light, 
SUM(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light -  Ring of Fame Contest' THEN 1  WHEN ecsd.Source1 = 'Broncos and Bud Light.com - Ring of Fame Contest' THEN 1 ELSE 0 END) Broncos_Bud_Light__Ring_of_Fame_Contest,
SUM(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light Facebook' THEN 1 ELSE 0 END) Broncos_Bud_Light_Facebook, 
SUM(CASE WHEN ecsd.Source1 = 'Broncos and Bud Light Ticket Giveaway' THEN 1 ELSE 0 END) Broncos_Bud_Light_Ticket_Giveaway, 
SUM(CASE WHEN ecsd.Source1 = 'Broncos and Budlight.com Various Contests' THEN 1 ELSE 0 END) Broncos_Budlight_Various_Contests, 
SUM(CASE WHEN ecsd.Source1 = 'Broncos Fanaticos' THEN 1 ELSE 0 END) Broncos_Fanaticos, 
SUM(CASE WHEN ecsd.Source1 = 'Bud Light Draft' THEN 1 ELSE 0 END) Bud_Light_Draft, 
SUM(CASE WHEN ecsd.Source1 = 'Bud Light Up for Whatever Contest' THEN 1 ELSE 0 END) Bud_Light_Up_for_Whatever_Contest, 
SUM(CASE WHEN ecsd.Source1 = 'BWW' THEN 1 ELSE 0 END) BWW, 
SUM(CASE WHEN ecsd.Source1 = 'Canon Shoot Like a Pro Contests' THEN 1 ELSE 0 END) Canon_Shoot_Like_a_Pro_Contests, 
SUM(CASE WHEN ecsd.Source1 = 'Carmax 2017' THEN 1 ELSE 0 END) Carmax_2017, 
SUM(CASE WHEN ecsd.Source1 = 'Carmax VIP' THEN 1 ELSE 0 END) Carmax_VIP, 
SUM(CASE WHEN ecsd.Source1 = 'CenturyLink 2017' THEN 1 ELSE 0 END) CenturyLink_2017, 
SUM(CASE WHEN ecsd.Source1 = 'CenturyLink Dinner with a Draft Pick' THEN 1 ELSE 0 END) CenturyLink_Dinner_with_a_Draft_Pick,  
SUM(CASE WHEN ecsd.Source1 = 'Denver Broncos Kickoff Kid' THEN 1 ELSE 0 END)	Denver_Broncos_Kickoff_Kid   ,
SUM(CASE WHEN ecsd.Source1 = 'Dia del Nino' THEN 1 ELSE 0 END)	 Dia_del_Nino  ,
SUM(CASE WHEN ecsd.Source1 = 'DirecTV Fan Fly In' THEN 1 ELSE 0 END)	DirecTV_Fan_Fly_In   ,
SUM(CASE WHEN ecsd.Source1 = 'DirecTV Fantasy Football Party' THEN 1 ELSE 0 END)	DirecTV_Fantasy_Football_Party   ,
SUM(CASE WHEN ecsd.Source1 = 'DirecTV Fly In' THEN 1 ELSE 0 END)	DirecTV_Fly_In   ,
SUM(CASE WHEN ecsd.Source1 = 'DirecTV Fly In 2015' THEN 1 ELSE 0 END)	DirecTV_Fly_In_2015   ,
SUM(CASE WHEN ecsd.Source1 = 'En tu Casa' THEN 1 ELSE 0 END)	En_tu_Casa   ,
SUM(CASE WHEN ecsd.Source1 = 'Espanol Prize Registration' THEN 1 ELSE 0 END)	Espanol_Prize_Registration   ,
SUM(CASE WHEN ecsd.Source1 = 'Facebook Ticket Giveaway - Broncos vs Colts Sept 2014' THEN 1 ELSE 0 END) Facebook_Ticket_Giveaway_Broncos_vs_Colts,
SUM(CASE WHEN ecsd.Source1 = 'Famous Dave''s Mini Miles Entries' THEN 1 ELSE 0 END)	Famous_Daves_Mini_Miles_Entries	,
SUM(CASE WHEN ecsd.Source1 = 'Fan Pack' THEN 1 ELSE 0 END) Fan_Pack,
SUM(CASE WHEN ecsd.Source1 = 'Fanaticos Fathers Day' THEN 1 ELSE 0 END)Fanaticos_Fathers_Day,
SUM(CASE WHEN ecsd.Source1 = 'Fanaticos Giveaway' THEN 1 ELSE 0 END)Fanaticos_Giveaway,
SUM(CASE WHEN ecsd.Source1 = 'Fast Dash' THEN 1 ELSE 0 END)Fast_Dash,
SUM(CASE WHEN ecsd.Source1 = 'Free Tickets' THEN 1 ELSE 0 END)Free_Tickets,
SUM(CASE WHEN ecsd.Source1 = 'Gameday 2016 Season' THEN 1 ELSE 0 END)Gameday_2016_Season,
SUM(CASE WHEN ecsd.Source1 = 'Gameday Preview' THEN 1 ELSE 0 END)Gameday_Preview,
SUM(CASE WHEN ecsd.Source1 = 'Grease Monkey 2017' THEN 1 ELSE 0 END)Grease_Monkey_2017,
SUM(CASE WHEN ecsd.Source1 = 'Guess the Schedule' THEN 1 ELSE 0 END)Guess_the_Schedule,
SUM(CASE WHEN ecsd.Source1 = 'Hackathon' THEN 1 ELSE 0 END)Hackathon,
SUM(CASE WHEN ecsd.Source1 = 'HelmetForHelmet' THEN 1 ELSE 0 END)HelmetForHelmet,
SUM(CASE WHEN ecsd.Source1 = 'Indi.com' THEN 1 ELSE 0 END) [Indi.com],
SUM(CASE WHEN ecsd.Source1 = 'Jack Black' THEN 1 ELSE 0 END)Jack_Black,
SUM(CASE WHEN ecsd.Source1 = 'Kickoff Kid' THEN 1 WHEN ecsd.Source1 = 'Kickoff Kid, presented by Nationwide' THEN 1 ELSE 0 END)Kickoff_Kid,
SUM(CASE WHEN ecsd.Source1 = 'King Soopers' THEN 1 ELSE 0 END)King_Soopers,
SUM(CASE WHEN ecsd.Source1 = 'Kwal Paint Winner' THEN 1 ELSE 0 END)Kwal_Paint_Winner,
SUM(CASE WHEN ecsd.Source1 = 'Levi''s' THEN 1 ELSE 0 END) Levis ,
SUM(CASE WHEN ecsd.Source1 = 'mcdonald''s key tag' THEN 1 ELSE 0 END)	Mcdonalds_key_tag   ,
SUM(CASE WHEN ecsd.Source1 = 'McDonald''s Playoffs' THEN 1 ELSE 0 END)McDonalds_Playoffs,
SUM(CASE WHEN ecsd.Source1 = 'Panini' THEN 1 ELSE 0 END)Panini,
SUM(CASE WHEN ecsd.Source1 = 'Papa johns' THEN 1 ELSE 0 END)Papa_johns,
SUM(CASE WHEN ecsd.Source1 = 'Playoff Tickets' THEN 1 ELSE 0 END)Playoff_Tickets,
SUM(CASE WHEN ecsd.Source1 = 'Posada' THEN 1 ELSE 0 END)Posada,
SUM(CASE WHEN ecsd.Source1 = 'Salute to Fans Vote' THEN 1 ELSE 0 END)Salute_to_Fans_Vote,
SUM(CASE WHEN ecsd.Source1 = 'SB50 Ring Digital' THEN 1 ELSE 0 END)SB50_Ring_Digital,
SUM(CASE WHEN ecsd.Source1 = 'SB50 Tickets' THEN 1 ELSE 0 END)SB50_Tickets,
SUM(CASE WHEN ecsd.Source1 = 'SB50 VIP' THEN 1 ELSE 0 END)SB50_VIP,
SUM(CASE WHEN ecsd.Source1 = 'social' THEN 1 ELSE 0 END)social,
SUM(CASE WHEN ecsd.Source1 = 'thankyoufans' THEN 1 ELSE 0 END)thankyoufans,
SUM(CASE WHEN ecsd.Source1 = 'United in Orange Helmet Hunt' THEN 1 ELSE 0 END)United_in_OrangeHelmet_Hunt,
SUM(CASE WHEN ecsd.Source1 = 'Von Miller Contest' THEN 1 ELSE 0 END)Von_Miller_Contest,
SUM(CASE WHEN ecsd.Source1 = 'Web Contest' THEN 1 ELSE 0 END)Web_Contest,
SUM(CASE WHEN ecsd.Source1 = 'Westrock' THEN 1 ELSE 0 END)Westrock,
SUM(CASE WHEN ecsd.Source1 = 'What Would You Do for Broncos Playoff Tickets' THEN 1 ELSE 0 END)What_Would_You_Do_for_Broncos_Playoff_Tickets,
SUM(CASE WHEN ecsd.Source1 = 'Xcel Energy - Draft' THEN 1 ELSE 0 END)Xcel_Energy_Draft,
SUM(CASE WHEN ecsd.Source1 = 'Xome Playoffs' THEN 1 ELSE 0 END)Xome_Playoffs,
SUM(CASE WHEN ecsd.Source1 = 'Yahoo Fantasy' THEN 1 ELSE 0 END)Yahoo_Fantasy
FROM ods.EloquaCustom_SourceDetail ecsd WITH (NOLOCK)
LEFT JOIN dbo.vwdimcustomer_ModAcctId ssbid WITH (NOLOCK) ON ecsd.Email_Address1 = ssbid.EmailPrimary			--ID is not an identifier for the individual and does not join back clean, only good identifier is Email
WHERE ETL_IsDeleted = 0 AND ssbid.SourceSystem = 'Eloqua Broncos'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
) esdc ON emg.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID


/*
Select count(*) from ods.EloquaCustom_SourceDetail

Select count(distinct ID) from ods.EloquaCustom_SourceDetail

Select count(distinct email_Address1) from ods.EloquaCustom_SourceDetail
*/


LEFT JOIN (  --Non-Game events, Flag 1 for participation. Event list came from Broncos, data came from custom Eloqua object.
SELECT
ssbid.SSB_CRMSYSTEM_CONTACT_ID,
SUM(CASE WHEN ecsd.Source1 = '45 day challenge' THEN 1 ELSE 0 END )AS [45_day_challenge]
,SUM(CASE WHEN ecsd.Source1 = '45 Day Fitness Fall 2016' THEN 1 ELSE 0 END )AS [45_Day_Fitness_Fall_2016]
,SUM(CASE WHEN ecsd.Source1 = 'All You Can Eat Tailgate' THEN 1 ELSE 0 END )AS All_You_Can_Eat_Tailgate
,SUM(CASE WHEN ecsd.Source1 = 'Broadnet 2017' THEN 1 ELSE 0 END )AS Broadnet_2017
,SUM(CASE WHEN ecsd.Source1 = 'Broncos 7K 2015' THEN 1 ELSE 0 END )AS Broncos_7K_2015
,SUM(CASE WHEN ecsd.Source1 = 'Broncos 7K Registration 2014' THEN 1 ELSE 0 END) AS Broncos_7K_Registration_2014
,SUM(CASE WHEN ecsd.Source1 = 'Broncos Bunch Movie Night' THEN 1 ELSE 0 END) AS Broncos_Bunch_Movie_Night
,SUM(CASE WHEN ecsd.Source1 = 'Broncos Bunch Trick-or-Treat RS' THEN 1 ELSE 0 END) AS Broncos_Bunch_Trick_or_Treat
,SUM(CASE WHEN ecsd.Source1 = 'Bunch Kids Day' THEN 1 ELSE 0 END) AS Bunch_Kids_Day
,SUM(CASE WHEN ecsd.Source1 = 'Bunch Movie Night RSVP' THEN 1 ELSE 0 END) AS Bunch_Movie_Night_RSVP
,SUM(CASE WHEN ecsd.Source1 = 'Bunch Movie Night RSVP - 2016' THEN 1 ELSE 0 END) AS Bunch_Movie_Night_RSVP_2016
,SUM(CASE WHEN ecsd.Source1 = 'Bunch Summer Kickoff RSVP' THEN 1 ELSE 0 END )AS Bunch_Summer_Kickoff_RSVP
,SUM(CASE WHEN ecsd.Source1 = 'Bunch training camp' THEN 1 ELSE 0 END )AS Bunch_training_camp
,SUM(CASE WHEN ecsd.Source1 = 'Bunch trick of treat' THEN 1 ELSE 0 END )AS Bunch_trick_of_treat
,SUM(CASE WHEN ecsd.Source1 = 'Carne Asada Flea Market 2017' THEN 1 ELSE 0 END) AS Carne_Asada_Flea_Market_2017
,SUM(CASE WHEN ecsd.Source1 = 'Carne Asada Greeley 2017' THEN 1 ELSE 0 END )AS Carne_Asada_Greeley_2017
,SUM(CASE WHEN ecsd.Source1 = 'Crush Night Out' THEN 1 ELSE 0 END )AS Crush_Night_Out
,SUM(CASE WHEN ecsd.Source1 = 'Denver 7K 2017' THEN 1 ELSE 0 END) AS Denver_7K_2017
,SUM(CASE WHEN ecsd.Source1 = 'Espanol' THEN 1 ELSE 0 END )AS Espanol
,SUM(CASE WHEN ecsd.Source1 = 'Espanol 2017' THEN 1 ELSE 0 END) AS Espanol_2017
,SUM(CASE WHEN ecsd.Source1 = 'Expo 2016' THEN 1 ELSE 0 END )AS Expo_2016
,SUM(CASE WHEN ecsd.Source1 = 'Expo 2017' THEN 1 ELSE 0 END )AS Expo_2017
,SUM(CASE WHEN ecsd.Source1 = 'Expo Survey collect' THEN 1 ELSE 0 END) AS Expo_Survey_collect
,SUM(CASE WHEN ecsd.Source1 = 'Fan Forum' THEN 1 ELSE 0 END )AS Fan_Forum
,SUM(CASE WHEN ecsd.Source1 = 'Greeley - Salute to Fans' THEN 1 ELSE 0 END) AS Greeley_Salute_to_Fans
,SUM(CASE WHEN ecsd.Source1 = 'Mountain Village 2016' THEN 1 ELSE 0 END) AS Mountain_Village_2016
,SUM(CASE WHEN ecsd.Source1 = 'Mountain Village 2017' THEN 1 ELSE 0 END )AS Mountain_Village_2017
,SUM(CASE WHEN ecsd.Source1 = 'Orange County' THEN 1 ELSE 0 END )AS Orange_County
,SUM(CASE WHEN ecsd.Source1 = 'Philadelphia' THEN 1 ELSE 0 END )AS Philadelphia
,SUM(CASE WHEN ecsd.Source1 = 'Salute to Fans' THEN 1 ELSE 0 END) AS Salute_to_Fans
,SUM(CASE WHEN ecsd.Source1 = 'Salute to Fans 2016' THEN 1 ELSE 0 END) AS Salute_to_Fans_2016
,SUM(CASE WHEN ecsd.Source1 = 'Training Camp 2016' THEN 1 ELSE 0 END )AS Training_Camp_2016
,SUM(CASE WHEN ecsd.Source1 = 'Training Camp 2017' THEN 1 ELSE 0 END )AS Training_Camp_2017
FROM ods.EloquaCustom_SourceDetail ecsd WITH (NOLOCK)
LEFT JOIN dbo.vwdimcustomer_ModAcctId ssbid WITH (NOLOCK) ON ecsd.Email_Address1 = ssbid.EmailPrimary
WHERE ETL_IsDeleted = 0 AND ssbid.SourceSystem = 'Eloqua Broncos'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
) nge ON emg.SSB_CRMSYSTEM_CONTACT_ID = mcr.SSB_CRMSYSTEM_CONTACT_ID



GO
