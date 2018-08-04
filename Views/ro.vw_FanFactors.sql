SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













--re-order, make everything pretty, make more readable
--Is emailable, has bought recently

--SELECT TOP 1000 * FROM ro.vw_FanFactors

CREATE VIEW [ro].[vw_FanFactors] AS

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
DimCustomerId, SourceDB, SourceSystem, SSID, SSB_CRMSYSTEM_CONTACT_ID
, SSB_CRMSYSTEM_ACCT_ID, First_Name, Last_Name, Suffix, Birthday
, Gender, AddressPrimary_Zip, AddressPrimary_State
, AddressPrimary_Colorado_Flag, WaitList_Flag, UpdatedDate, IsDeleted
, Email_Opened_Flag, Email_Open_MostRecent, Email_Open_Qty
, Form_Submit_Flag, Form_Submit_Qty, CrushMember_Flag
, BunchMember_Flag, EmailGroup_OrangeJuice, EmailGroup_OrangeHerd
, EmailGroup_ICYMI, EmailGroup_SurveyPanel, EmailGroup_BroncosPromos
, EmailGroup_Stadium, EmailGroup_Outlaws, EmailGroup_Memberships_Total
, NonGameEvents_Total, ContestsEntered_Total, Tickets_LastPurchase_Date
, Tickets_DaysSince_LastPurchase, Tickets_TotalPaid, Tickets_TotalQty
, Tickets_Attendance_Three_Years, Tickets_Attendance_One_Year
, Tickets_Attendance_MostRecent_Date, Attended_TrickOrTreat
, Attended_TD_HOF_Celebration, Attended_HolidayPhoto
, Fanatics_MaxOrderDate, Fanatics_TotalSpent_30Days
, Fanatics_TotalSpent_90Days, Fanatics_TotalSpent_Year
, Fanatics_TotalSpent_LifeTime, WooCommerce_MaxOrderDate
, WooCommerce_TotalSpent_30Days, WooCommerce_TotalSpent_90Days
, WooCommerce_TotalSpent_Year, WooCommerce_TotalSpent_LifeTime
, Sunday_ticket, Fantasy, Pickem
FROM [dbo].[TempFanFactors]
GO
