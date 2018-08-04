SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Documentation for this whole process




CREATE VIEW [ro].[vw_FanFactors_StandardizedRank] AS (

/*


SELECT ssb_crmsystem_contact_Id
FROM ro.[vw_FanFactors_StandardizedRank]
GROUP BY  ssb_crmsystem_contact_id
HAVING COUNT(*) > 1

*/

SELECT  
ROW_NUMBER() OVER(ORDER BY Total_Points DESC) AS Points_Rank, cf.DimcustomerId, cf.SourceSystem, cf.SSID, cf.SSB_CRMSYSTEM_CONTACT_ID, cf.FirstName, cf.LastName, cf.Birthday, TRY_CAST(cf.AddressPrimaryZip AS INT) AS AddressPrimaryZip, cf.AddressPrimaryState
, x.Tickets_DaysSince_LastPurchase, x.Tickets_TotalPaid AS Tickets_Paid_Total
, x.Merch_TotalSpent_LifeTime AS Merch_SpentLifetime_Total, x.Merch_TotalSpent_Year AS Merch_SpentYear_Total
, x.Waitlist_Flag, x.CrushMember_Flag, x.AddressPrimary_Colorado_Flag
, x.Email_Open_Qty
, x.Form_Submit_Qty
, x.BunchMember_Flag
, x.ICYMI AS ICYMI_Flag
, x.OJ AS OJ_Flag
, x.Promos AS Promos_Flag
, x.EmailGroup_OrangeHerd
, x.NonGameEvents_Total
, x.ContestsEntered_Total
, x.EmailGroup_Membeerships_total AS EmailGroup_Memberships_Total
, x.Attendance_total
, x.Value_Total
, x.Marketing_Total
, x.Digital_Total
, Total_Points AS Points_Total
FROM (SELECT  DimCustomerId, SSB_CRMSYSTEM_CONTACT_ID 
        , Tickets_DaysSince_LastPurchase
		, Tickets_TotalPaid
		, Merch_TotalSpent_LifeTime
		, Merch_TotalSpent_Year
		, Waitlist_Flag
		, CrushMember_Flag 
		, AddressPrimary_Colorado_Flag
		, Email_Open_Qty
		, Form_Submit_Qty
		, BunchMember_Flag
		, EmailGroup_OrangeHerd
		, NonGameEvents_Total
		, ICYMI
		, OJ
		, Promos
		, ContestsEntered_Total
		, EmailGroup_Membeerships_total
		, (Tickets_Attendance_One_Year) AS Attendance_total
		, (Merch_TotalSpent_Year + Tickets_TotalPaid) AS Value_Total
		, (BunchMember_Flag + CrushMember_Flag + EmailGroup_OrangeHerd + WaitList_Flag + AddressPrimary_Colorado_Flag + NonGameEvents_Total) AS Marketing_Total
		, (Email_Open_Qty + Form_Submit_Qty + CASE WHEN Fantasy IS NULL THEN 0 ELSE 1 END + ICYMI + OJ + Promos + ContestsEntered_total +
		CASE WHEN Pickem IS NULL THEN 0 ELSE 1 END + CASE WHEN Sunday_Ticket IS NULL THEN 0 ELSE 1 END) AS Digital_Total
		, (Tickets_Attendance_One_Year*.4 + (Merch_TotalSpent_Year + Tickets_TotalPaid)*.3 + 
		(BunchMember_Flag + CrushMember_Flag + EmailGroup_OrangeHerd + WaitList_Flag + AddressPrimary_Colorado_Flag + NonGameEvents_Total)*.2 + 
		(Email_Open_Qty + ContestsEntered_total + ICYMI + PROMOS + Form_Submit_Qty + CASE WHEN Fantasy IS NULL THEN 0 ELSE 1 END + CASE WHEN Pickem IS NULL THEN 0 ELSE 1 END + CASE WHEN Sunday_Ticket IS NULL THEN 0 ELSE 1 END)*.1) AS Total_Points
		FROM [dbo].[FanFactors_StandardizedScoresOutput] WITH (NOLOCK)
	) x
INNER JOIN mdm.compositerecord cf WITH (NOLOCK) ON x.SSB_CRMSYSTEM_CONTACT_ID = cf.SSB_CRMSYSTEM_CONTACT_ID

) 

GO
