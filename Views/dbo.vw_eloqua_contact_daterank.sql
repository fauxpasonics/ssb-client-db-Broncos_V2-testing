SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vw_eloqua_contact_daterank] AS 


SELECT  *
FROM    (
          SELECT    ec.ETL_ID
                  , ec.ETL_CreatedDate
                  , ec.ETL_UpdatedDate
                  , ec.ETL_IsDeleted
                  , ec.ETL_DeletedDate
                  , ec.ETL_DeltaHashKey
                  , ec.ID
                  , ec.Name
                  , ec.AccountName
                  , ec.BouncebackDate
                  , ec.IsBounceback
                  , ec.IsSubscribed
                  , ec.PostalCode
                  , ec.Province
                  , ec.SubscriptionDate
                  , ec.UnsubscriptionDate
                  , ec.CreatedAt
                  , ec.CreatedBy
                  , ec.AccessedAt
                  , ec.CurrentStatus
                  , ec.Depth
                  , ec.UpdatedAt
                  , ec.UpdatedBy
                  , ec.EmailAddress
                  , ec.FirstName
                  , ec.LastName
                  , ec.Company
                  , ec.Address1
                  , ec.Address2
                  , ec.Address3
                  , ec.City
                  , ec.Country
                  , ec.MobilePhone
                  , ec.BusinessPhone
                  , ec.Fax
                  , ec.Title
                  , ec.SalesPerson
                  , ec.C_EmailDisplayName
                  , ec.C_State_Prov
                  , ec.C_Zip_Postal
                  , ec.C_Salutation
                  , ec.C_SFDCContactID
                  , ec.C_SFDCLeadID
                  , ec.C_DateCreated
                  , ec.C_DateModified
                  , ec.ContactIDExt
                  , ec.C_SFDCAccountID
                  , ec.C_LastModifiedByExtIntegrateSystem
                  , ec.C_SFDCLastCampaignID
                  , ec.C_SFDCLastCampaignStatus
                  , ec.C_Company_Revenue1
                  , ec.C_SFDC_EmailOptOut1
                  , ec.C_Lead_Source___Most_Recent1
                  , ec.C_Lead_Source___Original1
                  , ec.C_Industry1
                  , ec.C_Annual_Revenue1
                  , ec.C_Lead_Status1
                  , ec.C_Job_Role1
                  , ec.C_LS___High_Value_Website_Content1
                  , ec.C_Lead_Score_Date___Most_Recent1
                  , ec.C_Integrated_Marketing_and_Sales_Funnel_Stage
                  , ec.C_Product_Solution_of_Interest1
                  , ec.C_Region1
                  , ec.C_elqPURLName1
                  , ec.C_Lead_Rating___Combined1
                  , ec.C_EmailAddressDomain
                  , ec.C_FirstAndLastName
                  , ec.C_Company_Size1
                  , ec.C_Lead_Score___Last_High_Touch_Event_Date1
                  , ec.C_Lead_Rating___Explicit1
                  , ec.C_Lead_Rating___Implicit1
                  , ec.C_Lead_Score___Explicit1
                  , ec.C_Lead_Score___Implicit1
                  , ec.C_Lead_Score_Date___Profile___Most_Recent1
                  , ec.C_Employees1
                  , ec.C_Territory
                  , ec.C_MD5HashedEmailAddress
                  , ec.C_SHA256HashedEmailAddress
                  , ec.C_MD5HashedBusPhone
                  , ec.C_SHA256HashedBusPhone
                  , ec.C_MD5HashedMobilePhone
                  , ec.C_SHA256HashedMobilePhone
                  , ec.C_Lead_Score
                  , ec.C_ElqPURLName
                  , ec.C_Date_of_Birth1
                  , ec.C_Gender1
                  , ec.C_Child_1___First_Name1
                  , ec.C_Child_1___Date_of_Birth1
                  , ec.C_Child_2___Full_Name1
                  , ec.C_Child_2___Date_of_Birth1
                  , ec.C_Child_3___Full_Name1
                  , ec.C_Child_3___Date_of_Birth1
                  , ec.C_Organization_Name1
                  , ec.C_Organization_Type1
                  , ec.C_Tax_Exempt_ID1
                  , ec.C_Survivor1
                  , ec.C_Nominator1
                  , ec.C_Online_Store___Total_Spend1
                  , ec.C_Season_Ticket_Account_Number1
                  , ec.C_Season_Ticket_Holder1
                  , ec.C_Product_Category1
                  , ec.C_Product_Sub_Category1
                  , ec.C_Data_Cleanse___Time_Stamp1
                  , ec.C_Team__Broncos1
                  , ec.C_Team__Outlaws1
                  , ec.C_SkiData___UserID1
                  , ec.C_SkiData___Username1
                  , ec.C_SkiData___TicketAccountID1
                  , ec.C_SkiData___LastActivityDate1
                  , ec.C_SkiData___TotalPointsEarned1
                  , ec.C_SkiData___Rank1
                  , ec.C_SkiData___PointsAvailable1
                  , ec.C_Children_in_Household1
                  , ec.C_Age__2_year_increments_1
                  , ec.C_HHLD_Income1
                  , ec.C_Education1
                  , ROW_NUMBER() OVER ( PARTITION BY ec.EmailAddress ORDER BY ec.ETL_UpdatedDate DESC ) AS row_rank
          FROM      ods.Eloqua_Contact AS ec WITH (NOLOCK)
        ) updated_email
WHERE   updated_email.row_rank = 1;


GO
