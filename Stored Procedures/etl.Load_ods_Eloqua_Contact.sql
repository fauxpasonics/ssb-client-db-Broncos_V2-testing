SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Load_ods_Eloqua_Contact]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\shegde
Date:     06/17/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM [src].[Eloqua_Contact]),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)


SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ID, Name, AccountName, BouncebackDate, IsBounceback, IsSubscribed, PostalCode, Province, SubscriptionDate, UnsubscriptionDate, CreatedAt, CreatedBy, AccessedAt, CurrentStatus, Depth, UpdatedAt, UpdatedBy, EmailAddress, FirstName, LastName, Company, Address1, Address2, Address3, City, Country, MobilePhone, BusinessPhone, Fax, Title, SalesPerson, C_EmailDisplayName, C_State_Prov, C_Zip_Postal, C_Salutation, C_SFDCContactID, C_SFDCLeadID, C_DateCreated, C_DateModified, ContactIDExt, C_SFDCAccountID, C_LastModifiedByExtIntegrateSystem, C_SFDCLastCampaignID, C_SFDCLastCampaignStatus, C_Company_Revenue1, C_SFDC_EmailOptOut1, C_Lead_Source___Most_Recent1, C_Lead_Source___Original1, C_Industry1, C_Annual_Revenue1, C_Lead_Status1, C_Job_Role1, C_LS___High_Value_Website_Content1, C_Lead_Score_Date___Most_Recent1, C_Integrated_Marketing_and_Sales_Funnel_Stage, C_Product_Solution_of_Interest1, C_Region1, C_elqPURLName1, C_Lead_Rating___Combined1, C_EmailAddressDomain, C_FirstAndLastName, C_Company_Size1, C_Lead_Score___Last_High_Touch_Event_Date1, C_Lead_Rating___Explicit1, C_Lead_Rating___Implicit1, C_Lead_Score___Explicit1, C_Lead_Score___Implicit1, C_Lead_Score_Date___Profile___Most_Recent1, C_Employees1, C_Territory, C_MD5HashedEmailAddress, C_SHA256HashedEmailAddress, C_MD5HashedBusPhone, C_SHA256HashedBusPhone, C_MD5HashedMobilePhone, C_SHA256HashedMobilePhone, C_Lead_Score, C_ElqPURLName, C_Date_of_Birth1, C_Gender1, C_Child_1___First_Name1, C_Child_1___Date_of_Birth1, C_Child_2___Full_Name1, C_Child_2___Date_of_Birth1, C_Child_3___Full_Name1, C_Child_3___Date_of_Birth1, C_Organization_Name1, C_Organization_Type1, C_Tax_Exempt_ID1, C_Survivor1, C_Nominator1, C_Online_Store___Total_Spend1, C_Season_Ticket_Account_Number1, C_Season_Ticket_Holder1, C_Product_Category1, C_Product_Sub_Category1, C_Data_Cleanse___Time_Stamp1, C_Team__Broncos1, C_Team__Outlaws1, C_SkiData___UserID1, C_SkiData___Username1, C_SkiData___TicketAccountID1, C_SkiData___LastActivityDate1, C_SkiData___TotalPointsEarned1, C_SkiData___Rank1, C_SkiData___PointsAvailable1, C_Children_in_Household1, C_Age__2_year_increments_1, C_HHLD_Income1, C_Education1, C_Promo_Code1, C_Gigya_UID1, C_Ticket_Invoice_HTML1, C_PURL1, C_Premium_Seat_Type1, C_Premium___of_Seats1, C_Favorites_Category1, C_Favorites_Interests1, C_Favorites_Type1, C_Likes_Object_ID1, C_Season_Ticket_Type1, C_Price_Code_Description1, C_Birth_Month1, C_Home_Town1, C_Experience_ID1
INTO #SrcData
FROM (
SELECT *
, ROW_NUMBER() OVER	(PARTITION BY ID ORDER BY ETL_ID DESC) RowRank
FROM [src].[Eloqua_Contact]
) a
WHERE a.RowRank = 1


UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),AccessedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(AccountName),'DBNULL_TEXT') + ISNULL(RTRIM(Address1),'DBNULL_TEXT') + ISNULL(RTRIM(Address2),'DBNULL_TEXT') + ISNULL(RTRIM(Address3),'DBNULL_TEXT') + ISNULL(RTRIM(BouncebackDate),'DBNULL_TEXT') + ISNULL(RTRIM(BusinessPhone),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Age__2_year_increments_1)),'DBNULL_NUMBER') + ISNULL(RTRIM(C_Annual_Revenue1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Child_1___Date_of_Birth1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Child_1___First_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Child_2___Date_of_Birth1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Child_2___Full_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Child_3___Date_of_Birth1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Child_3___Full_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Children_in_Household1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Company_Revenue1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Company_Size1),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),C_Data_Cleanse___Time_Stamp1,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),C_Date_of_Birth1,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),C_DateCreated,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),C_DateModified,112)),'DBNULL_DATE') + ISNULL(RTRIM(C_Education1),'DBNULL_TEXT') + ISNULL(RTRIM(C_ElqPURLName),'DBNULL_TEXT') + ISNULL(RTRIM(C_elqPURLName1),'DBNULL_TEXT') + ISNULL(RTRIM(C_EmailAddressDomain),'DBNULL_TEXT') + ISNULL(RTRIM(C_EmailDisplayName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Employees1)),'DBNULL_NUMBER') + ISNULL(RTRIM(C_FirstAndLastName),'DBNULL_TEXT') + ISNULL(RTRIM(C_Gender1),'DBNULL_TEXT') + ISNULL(RTRIM(C_HHLD_Income1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Industry1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Integrated_Marketing_and_Sales_Funnel_Stage),'DBNULL_TEXT') + ISNULL(RTRIM(C_Job_Role1),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),C_LastModifiedByExtIntegrateSystem,112)),'DBNULL_DATE') + ISNULL(RTRIM(C_Lead_Rating___Combined1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Lead_Rating___Explicit1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Lead_Rating___Implicit1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Lead_Score),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Lead_Score___Explicit1)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),C_Lead_Score___Implicit1)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),C_Lead_Score___Last_High_Touch_Event_Date1,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),C_Lead_Score_Date___Most_Recent1,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),C_Lead_Score_Date___Profile___Most_Recent1,112)),'DBNULL_DATE') + ISNULL(RTRIM(C_Lead_Source___Most_Recent1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Lead_Source___Original1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Lead_Status1),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_LS___High_Value_Website_Content1)),'DBNULL_NUMBER') + ISNULL(RTRIM(C_MD5HashedBusPhone),'DBNULL_TEXT') + ISNULL(RTRIM(C_MD5HashedEmailAddress),'DBNULL_TEXT') + ISNULL(RTRIM(C_MD5HashedMobilePhone),'DBNULL_TEXT') + ISNULL(RTRIM(C_Nominator1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Online_Store___Total_Spend1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Organization_Name1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Organization_Type1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Product_Category1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Product_Solution_of_Interest1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Product_Sub_Category1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Region1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Salutation),'DBNULL_TEXT') + ISNULL(RTRIM(C_Season_Ticket_Account_Number1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Season_Ticket_Holder1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SFDC_EmailOptOut1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SFDCAccountID),'DBNULL_TEXT') + ISNULL(RTRIM(C_SFDCContactID),'DBNULL_TEXT') + ISNULL(RTRIM(C_SFDCLastCampaignID),'DBNULL_TEXT') + ISNULL(RTRIM(C_SFDCLastCampaignStatus),'DBNULL_TEXT') + ISNULL(RTRIM(C_SFDCLeadID),'DBNULL_TEXT') + ISNULL(RTRIM(C_SHA256HashedBusPhone),'DBNULL_TEXT') + ISNULL(RTRIM(C_SHA256HashedEmailAddress),'DBNULL_TEXT') + ISNULL(RTRIM(C_SHA256HashedMobilePhone),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___LastActivityDate1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___PointsAvailable1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___Rank1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___TicketAccountID1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___TotalPointsEarned1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___UserID1),'DBNULL_TEXT') + ISNULL(RTRIM(C_SkiData___Username1),'DBNULL_TEXT') + ISNULL(RTRIM(C_State_Prov),'DBNULL_TEXT') + ISNULL(RTRIM(C_Survivor1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Tax_Exempt_ID1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Team__Broncos1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Team__Outlaws1),'DBNULL_TEXT') + ISNULL(RTRIM(C_Territory),'DBNULL_TEXT') + ISNULL(RTRIM(C_Zip_Postal),'DBNULL_TEXT') + ISNULL(RTRIM(City),'DBNULL_TEXT') + ISNULL(RTRIM(Company),'DBNULL_TEXT') + ISNULL(RTRIM(ContactIDExt),'DBNULL_TEXT') + ISNULL(RTRIM(Country),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CurrentStatus),'DBNULL_TEXT') + ISNULL(RTRIM(Depth),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddress),'DBNULL_TEXT') + ISNULL(RTRIM(Fax),'DBNULL_TEXT') + ISNULL(RTRIM(FirstName),'DBNULL_TEXT') + ISNULL(RTRIM(ID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsBounceback)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsSubscribed)),'DBNULL_BIT') + ISNULL(RTRIM(LastName),'DBNULL_TEXT') + ISNULL(RTRIM(MobilePhone),'DBNULL_TEXT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(PostalCode),'DBNULL_TEXT') + ISNULL(RTRIM(Province),'DBNULL_TEXT') + ISNULL(RTRIM(SalesPerson),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SubscriptionDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(Title),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),UnsubscriptionDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(UpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Promo_Code1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Gigya_UID1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Ticket_Invoice_HTML1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_PURL1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Premium_Seat_Type1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Premium___of_Seats1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Favorites_Category1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Favorites_Interests1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Favorites_Type1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Likes_Object_ID1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Season_Ticket_Type1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Price_Code_Description1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Birth_Month1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Home_Town1)),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),C_Experience_ID1)),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)


MERGE [ods].[Eloqua_Contact] AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.ID = mySource.ID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ID] = mySource.[ID]
     ,myTarget.[Name] = mySource.[Name]
     ,myTarget.[AccountName] = mySource.[AccountName]
     ,myTarget.[BouncebackDate] = mySource.[BouncebackDate]
     ,myTarget.[IsBounceback] = mySource.[IsBounceback]
     ,myTarget.[IsSubscribed] = mySource.[IsSubscribed]
     ,myTarget.[PostalCode] = mySource.[PostalCode]
     ,myTarget.[Province] = mySource.[Province]
     ,myTarget.[SubscriptionDate] = mySource.[SubscriptionDate]
     ,myTarget.[UnsubscriptionDate] = mySource.[UnsubscriptionDate]
     ,myTarget.[CreatedAt] = mySource.[CreatedAt]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[AccessedAt] = mySource.[AccessedAt]
     ,myTarget.[CurrentStatus] = mySource.[CurrentStatus]
     ,myTarget.[Depth] = mySource.[Depth]
     ,myTarget.[UpdatedAt] = mySource.[UpdatedAt]
     ,myTarget.[UpdatedBy] = mySource.[UpdatedBy]
     ,myTarget.[EmailAddress] = mySource.[EmailAddress]
     ,myTarget.[FirstName] = mySource.[FirstName]
     ,myTarget.[LastName] = mySource.[LastName]
     ,myTarget.[Company] = mySource.[Company]
     ,myTarget.[Address1] = mySource.[Address1]
     ,myTarget.[Address2] = mySource.[Address2]
     ,myTarget.[Address3] = mySource.[Address3]
     ,myTarget.[City] = mySource.[City]
     ,myTarget.[Country] = mySource.[Country]
     ,myTarget.[MobilePhone] = mySource.[MobilePhone]
     ,myTarget.[BusinessPhone] = mySource.[BusinessPhone]
     ,myTarget.[Fax] = mySource.[Fax]
     ,myTarget.[Title] = mySource.[Title]
     ,myTarget.[SalesPerson] = mySource.[SalesPerson]
     ,myTarget.[C_EmailDisplayName] = mySource.[C_EmailDisplayName]
     ,myTarget.[C_State_Prov] = mySource.[C_State_Prov]
     ,myTarget.[C_Zip_Postal] = mySource.[C_Zip_Postal]
     ,myTarget.[C_Salutation] = mySource.[C_Salutation]
     ,myTarget.[C_SFDCContactID] = mySource.[C_SFDCContactID]
     ,myTarget.[C_SFDCLeadID] = mySource.[C_SFDCLeadID]
     ,myTarget.[C_DateCreated] = mySource.[C_DateCreated]
     ,myTarget.[C_DateModified] = mySource.[C_DateModified]
     ,myTarget.[ContactIDExt] = mySource.[ContactIDExt]
     ,myTarget.[C_SFDCAccountID] = mySource.[C_SFDCAccountID]
     ,myTarget.[C_LastModifiedByExtIntegrateSystem] = mySource.[C_LastModifiedByExtIntegrateSystem]
     ,myTarget.[C_SFDCLastCampaignID] = mySource.[C_SFDCLastCampaignID]
     ,myTarget.[C_SFDCLastCampaignStatus] = mySource.[C_SFDCLastCampaignStatus]
     ,myTarget.[C_Company_Revenue1] = mySource.[C_Company_Revenue1]
     ,myTarget.[C_SFDC_EmailOptOut1] = mySource.[C_SFDC_EmailOptOut1]
     ,myTarget.[C_Lead_Source___Most_Recent1] = mySource.[C_Lead_Source___Most_Recent1]
     ,myTarget.[C_Lead_Source___Original1] = mySource.[C_Lead_Source___Original1]
     ,myTarget.[C_Industry1] = mySource.[C_Industry1]
     ,myTarget.[C_Annual_Revenue1] = mySource.[C_Annual_Revenue1]
     ,myTarget.[C_Lead_Status1] = mySource.[C_Lead_Status1]
     ,myTarget.[C_Job_Role1] = mySource.[C_Job_Role1]
     ,myTarget.[C_LS___High_Value_Website_Content1] = mySource.[C_LS___High_Value_Website_Content1]
     ,myTarget.[C_Lead_Score_Date___Most_Recent1] = mySource.[C_Lead_Score_Date___Most_Recent1]
     ,myTarget.[C_Integrated_Marketing_and_Sales_Funnel_Stage] = mySource.[C_Integrated_Marketing_and_Sales_Funnel_Stage]
     ,myTarget.[C_Product_Solution_of_Interest1] = mySource.[C_Product_Solution_of_Interest1]
     ,myTarget.[C_Region1] = mySource.[C_Region1]
     ,myTarget.[C_elqPURLName1] = mySource.[C_elqPURLName1]
     ,myTarget.[C_Lead_Rating___Combined1] = mySource.[C_Lead_Rating___Combined1]
     ,myTarget.[C_EmailAddressDomain] = mySource.[C_EmailAddressDomain]
     ,myTarget.[C_FirstAndLastName] = mySource.[C_FirstAndLastName]
     ,myTarget.[C_Company_Size1] = mySource.[C_Company_Size1]
     ,myTarget.[C_Lead_Score___Last_High_Touch_Event_Date1] = mySource.[C_Lead_Score___Last_High_Touch_Event_Date1]
     ,myTarget.[C_Lead_Rating___Explicit1] = mySource.[C_Lead_Rating___Explicit1]
     ,myTarget.[C_Lead_Rating___Implicit1] = mySource.[C_Lead_Rating___Implicit1]
     ,myTarget.[C_Lead_Score___Explicit1] = mySource.[C_Lead_Score___Explicit1]
     ,myTarget.[C_Lead_Score___Implicit1] = mySource.[C_Lead_Score___Implicit1]
     ,myTarget.[C_Lead_Score_Date___Profile___Most_Recent1] = mySource.[C_Lead_Score_Date___Profile___Most_Recent1]
     ,myTarget.[C_Employees1] = mySource.[C_Employees1]
     ,myTarget.[C_Territory] = mySource.[C_Territory]
     ,myTarget.[C_MD5HashedEmailAddress] = mySource.[C_MD5HashedEmailAddress]
     ,myTarget.[C_SHA256HashedEmailAddress] = mySource.[C_SHA256HashedEmailAddress]
     ,myTarget.[C_MD5HashedBusPhone] = mySource.[C_MD5HashedBusPhone]
     ,myTarget.[C_SHA256HashedBusPhone] = mySource.[C_SHA256HashedBusPhone]
     ,myTarget.[C_MD5HashedMobilePhone] = mySource.[C_MD5HashedMobilePhone]
     ,myTarget.[C_SHA256HashedMobilePhone] = mySource.[C_SHA256HashedMobilePhone]
     ,myTarget.[C_Lead_Score] = mySource.[C_Lead_Score]
     ,myTarget.[C_ElqPURLName] = mySource.[C_ElqPURLName]
     ,myTarget.[C_Date_of_Birth1] = mySource.[C_Date_of_Birth1]
     ,myTarget.[C_Gender1] = mySource.[C_Gender1]
     ,myTarget.[C_Child_1___First_Name1] = mySource.[C_Child_1___First_Name1]
     ,myTarget.[C_Child_1___Date_of_Birth1] = mySource.[C_Child_1___Date_of_Birth1]
     ,myTarget.[C_Child_2___Full_Name1] = mySource.[C_Child_2___Full_Name1]
     ,myTarget.[C_Child_2___Date_of_Birth1] = mySource.[C_Child_2___Date_of_Birth1]
     ,myTarget.[C_Child_3___Full_Name1] = mySource.[C_Child_3___Full_Name1]
     ,myTarget.[C_Child_3___Date_of_Birth1] = mySource.[C_Child_3___Date_of_Birth1]
     ,myTarget.[C_Organization_Name1] = mySource.[C_Organization_Name1]
     ,myTarget.[C_Organization_Type1] = mySource.[C_Organization_Type1]
     ,myTarget.[C_Tax_Exempt_ID1] = mySource.[C_Tax_Exempt_ID1]
     ,myTarget.[C_Survivor1] = mySource.[C_Survivor1]
     ,myTarget.[C_Nominator1] = mySource.[C_Nominator1]
     ,myTarget.[C_Online_Store___Total_Spend1] = mySource.[C_Online_Store___Total_Spend1]
     ,myTarget.[C_Season_Ticket_Account_Number1] = mySource.[C_Season_Ticket_Account_Number1]
     ,myTarget.[C_Season_Ticket_Holder1] = mySource.[C_Season_Ticket_Holder1]
     ,myTarget.[C_Product_Category1] = mySource.[C_Product_Category1]
     ,myTarget.[C_Product_Sub_Category1] = mySource.[C_Product_Sub_Category1]
     ,myTarget.[C_Data_Cleanse___Time_Stamp1] = mySource.[C_Data_Cleanse___Time_Stamp1]
     ,myTarget.[C_Team__Broncos1] = mySource.[C_Team__Broncos1]
     ,myTarget.[C_Team__Outlaws1] = mySource.[C_Team__Outlaws1]
     ,myTarget.[C_SkiData___UserID1] = mySource.[C_SkiData___UserID1]
     ,myTarget.[C_SkiData___Username1] = mySource.[C_SkiData___Username1]
     ,myTarget.[C_SkiData___TicketAccountID1] = mySource.[C_SkiData___TicketAccountID1]
     ,myTarget.[C_SkiData___LastActivityDate1] = mySource.[C_SkiData___LastActivityDate1]
     ,myTarget.[C_SkiData___TotalPointsEarned1] = mySource.[C_SkiData___TotalPointsEarned1]
     ,myTarget.[C_SkiData___Rank1] = mySource.[C_SkiData___Rank1]
     ,myTarget.[C_SkiData___PointsAvailable1] = mySource.[C_SkiData___PointsAvailable1]
     ,myTarget.[C_Children_in_Household1] = mySource.[C_Children_in_Household1]
     ,myTarget.[C_Age__2_year_increments_1] = mySource.[C_Age__2_year_increments_1]
     ,myTarget.[C_HHLD_Income1] = mySource.[C_HHLD_Income1]
     ,myTarget.[C_Education1] = mySource.[C_Education1]
     ,myTarget.[C_Promo_Code1] = mySource.[C_Promo_Code1]
     ,myTarget.[C_Gigya_UID1] = mySource.[C_Gigya_UID1]
     ,myTarget.[C_Ticket_Invoice_HTML1] = mySource.[C_Ticket_Invoice_HTML1]
     ,myTarget.[C_PURL1] = mySource.[C_PURL1]
     ,myTarget.[C_Premium_Seat_Type1] = mySource.[C_Premium_Seat_Type1]
     ,myTarget.[C_Premium___of_Seats1] = mySource.[C_Premium___of_Seats1]
     ,myTarget.[C_Favorites_Category1] = mySource.[C_Favorites_Category1]
     ,myTarget.[C_Favorites_Interests1] = mySource.[C_Favorites_Interests1]
     ,myTarget.[C_Favorites_Type1] = mySource.[C_Favorites_Type1]
     ,myTarget.[C_Likes_Object_ID1] = mySource.[C_Likes_Object_ID1]
     ,myTarget.[C_Season_Ticket_Type1] = mySource.[C_Season_Ticket_Type1]
     ,myTarget.[C_Price_Code_Description1] = mySource.[C_Price_Code_Description1]
     ,myTarget.[C_Birth_Month1] = mySource.[C_Birth_Month1]
     ,myTarget.[C_Home_Town1] = mySource.[C_Home_Town1]
     ,myTarget.[C_Experience_ID1] = mySource.[C_Experience_ID1]

     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[Name]
     ,[AccountName]
     ,[BouncebackDate]
     ,[IsBounceback]
     ,[IsSubscribed]
     ,[PostalCode]
     ,[Province]
     ,[SubscriptionDate]
     ,[UnsubscriptionDate]
     ,[CreatedAt]
     ,[CreatedBy]
     ,[AccessedAt]
     ,[CurrentStatus]
     ,[Depth]
     ,[UpdatedAt]
     ,[UpdatedBy]
     ,[EmailAddress]
     ,[FirstName]
     ,[LastName]
     ,[Company]
     ,[Address1]
     ,[Address2]
     ,[Address3]
     ,[City]
     ,[Country]
     ,[MobilePhone]
     ,[BusinessPhone]
     ,[Fax]
     ,[Title]
     ,[SalesPerson]
     ,[C_EmailDisplayName]
     ,[C_State_Prov]
     ,[C_Zip_Postal]
     ,[C_Salutation]
     ,[C_SFDCContactID]
     ,[C_SFDCLeadID]
     ,[C_DateCreated]
     ,[C_DateModified]
     ,[ContactIDExt]
     ,[C_SFDCAccountID]
     ,[C_LastModifiedByExtIntegrateSystem]
     ,[C_SFDCLastCampaignID]
     ,[C_SFDCLastCampaignStatus]
     ,[C_Company_Revenue1]
     ,[C_SFDC_EmailOptOut1]
     ,[C_Lead_Source___Most_Recent1]
     ,[C_Lead_Source___Original1]
     ,[C_Industry1]
     ,[C_Annual_Revenue1]
     ,[C_Lead_Status1]
     ,[C_Job_Role1]
     ,[C_LS___High_Value_Website_Content1]
     ,[C_Lead_Score_Date___Most_Recent1]
     ,[C_Integrated_Marketing_and_Sales_Funnel_Stage]
     ,[C_Product_Solution_of_Interest1]
     ,[C_Region1]
     ,[C_elqPURLName1]
     ,[C_Lead_Rating___Combined1]
     ,[C_EmailAddressDomain]
     ,[C_FirstAndLastName]
     ,[C_Company_Size1]
     ,[C_Lead_Score___Last_High_Touch_Event_Date1]
     ,[C_Lead_Rating___Explicit1]
     ,[C_Lead_Rating___Implicit1]
     ,[C_Lead_Score___Explicit1]
     ,[C_Lead_Score___Implicit1]
     ,[C_Lead_Score_Date___Profile___Most_Recent1]
     ,[C_Employees1]
     ,[C_Territory]
     ,[C_MD5HashedEmailAddress]
     ,[C_SHA256HashedEmailAddress]
     ,[C_MD5HashedBusPhone]
     ,[C_SHA256HashedBusPhone]
     ,[C_MD5HashedMobilePhone]
     ,[C_SHA256HashedMobilePhone]
     ,[C_Lead_Score]
     ,[C_ElqPURLName]
     ,[C_Date_of_Birth1]
     ,[C_Gender1]
     ,[C_Child_1___First_Name1]
     ,[C_Child_1___Date_of_Birth1]
     ,[C_Child_2___Full_Name1]
     ,[C_Child_2___Date_of_Birth1]
     ,[C_Child_3___Full_Name1]
     ,[C_Child_3___Date_of_Birth1]
     ,[C_Organization_Name1]
     ,[C_Organization_Type1]
     ,[C_Tax_Exempt_ID1]
     ,[C_Survivor1]
     ,[C_Nominator1]
     ,[C_Online_Store___Total_Spend1]
     ,[C_Season_Ticket_Account_Number1]
     ,[C_Season_Ticket_Holder1]
     ,[C_Product_Category1]
     ,[C_Product_Sub_Category1]
     ,[C_Data_Cleanse___Time_Stamp1]
     ,[C_Team__Broncos1]
     ,[C_Team__Outlaws1]
     ,[C_SkiData___UserID1]
     ,[C_SkiData___Username1]
     ,[C_SkiData___TicketAccountID1]
     ,[C_SkiData___LastActivityDate1]
     ,[C_SkiData___TotalPointsEarned1]
     ,[C_SkiData___Rank1]
     ,[C_SkiData___PointsAvailable1]
     ,[C_Children_in_Household1]
     ,[C_Age__2_year_increments_1]
     ,[C_HHLD_Income1]
     ,[C_Education1]
	 ,[C_Promo_Code1]
	 ,[C_Gigya_UID1]
	 ,[C_Ticket_Invoice_HTML1]
	 ,[C_PURL1]
	 ,[C_Premium_Seat_Type1]
	 ,[C_Premium___of_Seats1]
	 ,[C_Favorites_Category1]
	 ,[C_Favorites_Interests1]
	 ,[C_Favorites_Type1]
	 ,[C_Likes_Object_ID1]
	 ,[C_Season_Ticket_Type1]
	 ,[C_Price_Code_Description1]
	 ,[C_Birth_Month1]
	 ,[C_Home_Town1]
	 ,[C_Experience_ID1]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[Name]
     ,mySource.[AccountName]
     ,mySource.[BouncebackDate]
     ,mySource.[IsBounceback]
     ,mySource.[IsSubscribed]
     ,mySource.[PostalCode]
     ,mySource.[Province]
     ,mySource.[SubscriptionDate]
     ,mySource.[UnsubscriptionDate]
     ,mySource.[CreatedAt]
     ,mySource.[CreatedBy]
     ,mySource.[AccessedAt]
     ,mySource.[CurrentStatus]
     ,mySource.[Depth]
     ,mySource.[UpdatedAt]
     ,mySource.[UpdatedBy]
     ,mySource.[EmailAddress]
     ,mySource.[FirstName]
     ,mySource.[LastName]
     ,mySource.[Company]
     ,mySource.[Address1]
     ,mySource.[Address2]
     ,mySource.[Address3]
     ,mySource.[City]
     ,mySource.[Country]
     ,mySource.[MobilePhone]
     ,mySource.[BusinessPhone]
     ,mySource.[Fax]
     ,mySource.[Title]
     ,mySource.[SalesPerson]
     ,mySource.[C_EmailDisplayName]
     ,mySource.[C_State_Prov]
     ,mySource.[C_Zip_Postal]
     ,mySource.[C_Salutation]
     ,mySource.[C_SFDCContactID]
     ,mySource.[C_SFDCLeadID]
     ,mySource.[C_DateCreated]
     ,mySource.[C_DateModified]
     ,mySource.[ContactIDExt]
     ,mySource.[C_SFDCAccountID]
     ,mySource.[C_LastModifiedByExtIntegrateSystem]
     ,mySource.[C_SFDCLastCampaignID]
     ,mySource.[C_SFDCLastCampaignStatus]
     ,mySource.[C_Company_Revenue1]
     ,mySource.[C_SFDC_EmailOptOut1]
     ,mySource.[C_Lead_Source___Most_Recent1]
     ,mySource.[C_Lead_Source___Original1]
     ,mySource.[C_Industry1]
     ,mySource.[C_Annual_Revenue1]
     ,mySource.[C_Lead_Status1]
     ,mySource.[C_Job_Role1]
     ,mySource.[C_LS___High_Value_Website_Content1]
     ,mySource.[C_Lead_Score_Date___Most_Recent1]
     ,mySource.[C_Integrated_Marketing_and_Sales_Funnel_Stage]
     ,mySource.[C_Product_Solution_of_Interest1]
     ,mySource.[C_Region1]
     ,mySource.[C_elqPURLName1]
     ,mySource.[C_Lead_Rating___Combined1]
     ,mySource.[C_EmailAddressDomain]
     ,mySource.[C_FirstAndLastName]
     ,mySource.[C_Company_Size1]
     ,mySource.[C_Lead_Score___Last_High_Touch_Event_Date1]
     ,mySource.[C_Lead_Rating___Explicit1]
     ,mySource.[C_Lead_Rating___Implicit1]
     ,mySource.[C_Lead_Score___Explicit1]
     ,mySource.[C_Lead_Score___Implicit1]
     ,mySource.[C_Lead_Score_Date___Profile___Most_Recent1]
     ,mySource.[C_Employees1]
     ,mySource.[C_Territory]
     ,mySource.[C_MD5HashedEmailAddress]
     ,mySource.[C_SHA256HashedEmailAddress]
     ,mySource.[C_MD5HashedBusPhone]
     ,mySource.[C_SHA256HashedBusPhone]
     ,mySource.[C_MD5HashedMobilePhone]
     ,mySource.[C_SHA256HashedMobilePhone]
     ,mySource.[C_Lead_Score]
     ,mySource.[C_ElqPURLName]
     ,mySource.[C_Date_of_Birth1]
     ,mySource.[C_Gender1]
     ,mySource.[C_Child_1___First_Name1]
     ,mySource.[C_Child_1___Date_of_Birth1]
     ,mySource.[C_Child_2___Full_Name1]
     ,mySource.[C_Child_2___Date_of_Birth1]
     ,mySource.[C_Child_3___Full_Name1]
     ,mySource.[C_Child_3___Date_of_Birth1]
     ,mySource.[C_Organization_Name1]
     ,mySource.[C_Organization_Type1]
     ,mySource.[C_Tax_Exempt_ID1]
     ,mySource.[C_Survivor1]
     ,mySource.[C_Nominator1]
     ,mySource.[C_Online_Store___Total_Spend1]
     ,mySource.[C_Season_Ticket_Account_Number1]
     ,mySource.[C_Season_Ticket_Holder1]
     ,mySource.[C_Product_Category1]
     ,mySource.[C_Product_Sub_Category1]
     ,mySource.[C_Data_Cleanse___Time_Stamp1]
     ,mySource.[C_Team__Broncos1]
     ,mySource.[C_Team__Outlaws1]
     ,mySource.[C_SkiData___UserID1]
     ,mySource.[C_SkiData___Username1]
     ,mySource.[C_SkiData___TicketAccountID1]
     ,mySource.[C_SkiData___LastActivityDate1]
     ,mySource.[C_SkiData___TotalPointsEarned1]
     ,mySource.[C_SkiData___Rank1]
     ,mySource.[C_SkiData___PointsAvailable1]
     ,mySource.[C_Children_in_Household1]
     ,mySource.[C_Age__2_year_increments_1]
     ,mySource.[C_HHLD_Income1]
     ,mySource.[C_Education1]
	 ,mySource.[C_Promo_Code1]
	 ,mySource.[C_Gigya_UID1]
	 ,mySource.[C_Ticket_Invoice_HTML1]
	 ,mySource.[C_PURL1]
	 ,mySource.[C_Premium_Seat_Type1]
	 ,mySource.[C_Premium___of_Seats1]
	 ,mySource.[C_Favorites_Category1]
	 ,mySource.[C_Favorites_Interests1]
	 ,mySource.[C_Favorites_Type1]
	 ,mySource.[C_Likes_Object_ID1]
	 ,mySource.[C_Season_Ticket_Type1]
	 ,mySource.[C_Price_Code_Description1]
	 ,mySource.[C_Birth_Month1]
	 ,mySource.[C_Home_Town1]
	 ,mySource.[C_Experience_ID1]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_Contact] WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM [ods].[Eloqua_Contact] WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END



GO
