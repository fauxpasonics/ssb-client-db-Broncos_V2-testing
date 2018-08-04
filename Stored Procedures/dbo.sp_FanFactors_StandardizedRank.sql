SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













CREATE PROC [dbo].[sp_FanFactors_StandardizedRank]
AS 
BEGIN 

IF OBJECT_ID ('[dbo].[FanFactors_StandardizedScoresOutput]','U') IS NOT NULL DROP TABLE [dbo].[FanFactors_StandardizedScoresOutput]

IF OBJECT_ID(N'tempdb..#BaseSet','U') IS NOT NULL DROP TABLE #BaseSet
--- 2:28
SELECT *	
INTO #BaseSet
FROM dbo.TempFanFactors

--Data in this #Numeric temp table supplies the average/std dev calc
IF OBJECT_ID(N'tempdb..#Numeric','U') IS NOT NULL DROP TABLE #Numeric
--- 0:27 seconds
	SELECT			--Summing every field so that the fields that need to be aggregated can be
		cf.DimCustomerId,
		cf.SSB_CRMSYSTEM_CONTACT_ID,

		cf.Tickets_DaysSince_LastPurchase,
        cf.Tickets_TotalPaid + cf.ResalePrice_Total AS Tickets_TotalPaid,
		cf.Tickets_Attendance_One_Year,

		cf.Fanatics_TotalSpent_LifeTime + cf.WooCommerce_TotalSpent_Lifetime AS Merch_TotalSpent_Lifetime,
		cf.Fanatics_TotalSpent_Year + cf.WooCommerce_TotalSpent_Year AS Merch_TotalSpent_Year,

		cf.WaitList_Flag,
		cf.CrushMember_Flag,
		cf.BunchMember_Flag,
		cf.AddressPrimary_Colorado_Flag,
		cf.EmailGroup_OrangeHerd, 
		cf.Email_Open_Qty,
		cf.Form_Submit_Qty,
		cf.NonGameEvents_Total,
		cf.ContestsEntered_Total,
		cf.EmailGroup_Memberships_Total,
		cf.Fantasy, cf.Sunday_ticket, cf.Pickem, cf.EmailGroup_ICYMI,
		cf.EmailGroup_BroncosPromos, cf.EmailGroup_OrangeJuice

		


	INTO #Numeric
	FROM #BaseSet cf

--INSERT INTO [dbo].[FanFactors_StandardizedScoresOutput]

--Output points
SELECT z.DimCustomerID
, z.SSB_CRMSYSTEM_CONTACT_ID
, z.AddressPrimary_Colorado_Flag
, CASE WHEN z.Tickets_DaysSince_LastPurchase =z.Tickets_DaysSince_LastPurchase_Avg THEN -1 ELSE (z.[Tickets_DaysSince_LastPurchase]-z.[Tickets_DaysSince_LastPurchase_Avg])/z.[Tickets_DaysSince_LastPurchase_STDEV] END AS [Tickets_DaysSince_LastPurchase]
, CASE WHEN z.Tickets_TotalPaid = z.Tickets_TotalPaid_Avg THEN -1 ELSE (z.[Tickets_TotalPaid]-z.[Tickets_TotalPaid_Avg])/z.[Tickets_TotalPaid_STDEV] END AS [Tickets_TotalPaid]
, CASE WHEN z.Merch_TotalSpent_Lifetime = z.Merch_TotalSpent_Lifetime_Avg THEN -1 ELSE (z.[Merch_TotalSpent_LifeTime]-z.[Merch_TotalSpent_LifeTime_Avg])/z.[Merch_TotalSpent_LifeTime_STDEV] END AS [Merch_TotalSpent_LifeTime]
, CASE WHEN z.Merch_TotalSpent_Year = z.Merch_TotalSpent_Year_Avg THEN -1 ELSE (z.[Merch_TotalSpent_Year]-z.[Merch_TotalSpent_Year_Avg])/z.[Merch_TotalSpent_Year_STDEV] END AS [Merch_TotalSpent_Year]
, z.WaitList_Flag
, z.CrushMember_Flag
, z.BunchMember1 AS BunchMember_Flag
, z.Fantasy
, z.Sunday_ticket
, z.Pickem
, z.EmailGroup_ICYMI AS ICYMI
, z.EmailGroup_BroncosPromos AS Promos
, z.EmailGroup_OrangeJuice AS OJ
, CASE WHEN z.Email_Open_Qty1 = 0 THEN -1 ELSE (z.[Email_Open_Qty1]-z.[Email_Open_Qty_Avg])/z.[Email_Open_Qty_Stdev] END AS Email_Open_Qty
, CASE WHEN z.Form_Submit_Qty1 = 0 THEN -1 ELSE (z.[Form_Submit_Qty1]-z.[Form_Submit_Qty_Avg])/z.[Form_Submit_Qty_Stdev] END AS Form_Submit_Qty
, CASE WHEN z.NonGameEvents_Total1 = 0 THEN -1 ELSE (z.[NonGameEvents_Total1]-z.[NonGameEvents_Total_Avg])/z.[NonGameEvents_Total_Stdev] END AS NonGameEvents_Total
, CASE WHEN z.ContestsEntered_Total1 = 0 THEN -1 ELSE (z.[ContestsEntered_Total1]-z.[ContestsEntered_Total_Avg])/z.[ContestsEntered_Total_Stdev] END AS ContestsEntered_Total
, CASE WHEN z.EmailGroup_Memberships_Total1 = 0 THEN -1 ELSE (z.[EmailGroup_Memberships_Total1]-z.[EmailGroup_Memberships_Total_Avg])/z.[EmailGroup_Memberships_Total_Stdev] END AS EmailGroup_Membeerships_total
, CASE WHEN z.Tickets_Attendance_One_Year = 0 THEN 0 ELSE ((z.Tickets_Attendance_One_Year-z.Tickets_Attendance_One_Year_Avg)/z.Tickets_Attendance_One_Year_Stdev)+1 END AS Tickets_Attendance_One_Year
, z.EmailGroup_OrangeHerd
INTO [dbo].[FanFactors_StandardizedScoresOutput]
FROM (

--Input variable to calculate points
SELECT DimCustomerID
, SSB_CRMSYSTEM_CONTACT_ID
, CASE WHEN [Tickets_DaysSince_LastPurchase] IS NULL THEN n.Tickets_DaysSince_LastPurchase_Avg ELSE [Tickets_DaysSince_LastPurchase] END [Tickets_DaysSince_LastPurchase]
, CASE WHEN [Tickets_TotalPaid] IS NULL THEN n.Tickets_TotalPaid_Avg  ELSE [Tickets_TotalPaid] END [Tickets_TotalPaid] 
, CASE WHEN Merch_TotalSpent_Lifetime IS NULL THEN n.Merch_TotalSpent_LifeTime_Avg ELSE Merch_TotalSpent_Lifetime END [Merch_TotalSpent_LifeTime]
, CASE WHEN [Merch_TotalSpent_Year] IS NULL THEN n.Merch_TotalSpent_Year_Avg ELSE [Merch_TotalSpent_Year] END [Merch_TotalSpent_Year] 
, WaitList_Flag
, CrushMember_Flag
, AddressPrimary_Colorado_Flag
, Pickem
, Fantasy
, Sunday_ticket
, EmailGroup_ICYMI
, EmailGroup_BroncosPromos
, EmailGroup_OrangeJuice
, CASE WHEN [Email_Open_Qty] IS NULL THEN 0 ELSE [Email_Open_Qty] END [Email_Open_Qty1] 
, CASE WHEN b.Form_Submit_Qty IS NULL THEN 0 ELSE b.Form_Submit_Qty END Form_Submit_Qty1
, CASE WHEN b.BunchMember_Flag >= 1 then 1 else 0 end as BunchMember1
, CASE WHEN b.NonGameEvents_Total IS NULL THEN 0 ELSE b.NonGameEvents_Total END NonGameEvents_Total1
, CASE WHEN b.ContestsEntered_Total IS NULL THEN 0 ELSE b.ContestsEntered_Total END ContestsEntered_Total1 
, CASE WHEN b.EmailGroup_Memberships_Total IS NULL THEN 0 ELSE b.EmailGroup_Memberships_Total END EmailGroup_Memberships_Total1
, CASE WHEN b.Tickets_Attendance_One_Year IS NULL THEN 0 ELSE b.Tickets_Attendance_One_Year END Tickets_Attendance_One_Year 
, CASE WHEN b.EmailGroup_OrangeHerd IS NULL THEN 0 ELSE b.EmailGroup_OrangeHerd END EmailGroup_OrangeHerd 
, n.*
 FROM 
   ( SELECT *
	FROM #Numeric
	) b 
CROSS JOIN (
	--average/stddev calculations
	SELECT 

	 AVG([Tickets_DaysSince_LastPurchase]) as [Tickets_DaysSince_LastPurchase_Avg]
	, STDEV([Tickets_DaysSince_LastPurchase]) as [Tickets_DaysSince_LastPurchase_Stdev]
	, AVG([Tickets_TotalPaid]) as [Tickets_TotalPaid_Avg]
	, STDEV([Tickets_TotalPaid]) as [Tickets_TotalPaid_Stdev]
	, AVG(Merch_TotalSpent_Lifetime) as [Merch_TotalSpent_LifeTime_Avg]
	, STDEV(Merch_TotalSpent_Lifetime) as [Merch_TotalSpent_LifeTime_Stdev]
	, AVG([Merch_TotalSpent_Year]) as [Merch_TotalSpent_Year_Avg]
	, STDEV([Merch_TotalSpent_Year]) as [Merch_TotalSpent_Year_Stdev]
	, AVG([Email_Open_Qty]) AS [Email_Open_Qty_Avg]
	, STDEV([Email_Open_Qty]) AS [Email_Open_Qty_Stdev]
	, AVG(Form_Submit_Qty) AS [Form_Submit_Qty_Avg]
	, STDEV(Form_Submit_Qty) AS [Form_Submit_Qty_Stdev]
	, AVG([NonGameEvents_Total]) AS [NonGameEvents_Total_Avg]
	, STDEV([NonGameEvents_Total]) AS [NonGameEvents_Total_Stdev]
	, AVG([ContestsEntered_Total]) AS [ContestsEntered_Total_Avg]
	, STDEv([ContestsEntered_Total]) AS [ContestsEntered_Total_Stdev]
	, AVG([EmailGroup_Memberships_Total]) AS [EmailGroup_Memberships_Total_Avg]
	, STDEV([EmailGroup_Memberships_Total]) AS [EmailGroup_Memberships_Total_Stdev]
	, AVG(Tickets_Attendance_One_Year) AS Tickets_Attendance_One_Year_Avg
	, STDEV(Tickets_Attendance_One_Year) AS Tickets_Attendance_One_Year_Stdev
	FROM #Numeric
	) n 

	) z

	


END 


GO
