SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [rpt].[eloqua_tm_changes] AS

IF OBJECT_ID('tempdb..#tmpTM') IS NOT NULL
DROP TABLE #tmpTM
IF OBJECT_ID('tempdb..#tmpeloqua') IS NOT NULL
DROP TABLE #tmpeloqua
IF OBJECT_ID('tempdb..#tmpeloqua2') IS NOT NULL
DROP TABLE #tmpeloqua2
IF OBJECT_ID('tempdb..#tmptmsecondary') IS NOT NULL
DROP TABLE #tmptmsecondary
IF OBJECT_ID('tempdb..#tmpmdm') IS NOT NULL
DROP TABLE #tmpmdm
IF OBJECT_ID('tempdb..#tm1') IS NOT NULL
DROP TABLE #tm1
IF OBJECT_ID('tempdb..#e1') IS NOT NULL
DROP TABLE #e1
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL
DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL
DROP TABLE #temp2
IF OBJECT_ID('tempdb..#CYFact') IS NOT NULL
DROP TABLE #CYFact
IF OBJECT_ID('tempdb..#Bucket1') IS NOT NULL
DROP TABLE #Bucket1




/*  Pick up all primary TM records  */
SELECT  CAST('TM' AS VARCHAR(500)) Sourcesystem ,
        CAST(cust.acct_id AS VARCHAR(500)) acct_id ,
        CAST(name_title AS VARCHAR(500)) name_title ,
        CAST(name_first AS VARCHAR(500)) name_first ,
        CAST(name_last AS VARCHAR(500)) name_last ,
        CAST(company_name AS VARCHAR(500)) company_name ,
        CASE WHEN CAST(birth_date AS VARCHAR(500)) = '1900-01-01' THEN '' ELSE birth_date END AS birth_date ,
        CAST(gender AS VARCHAR(500)) gender ,
        CAST(street_addr_1 AS VARCHAR(500)) street_addr_1 ,
        CAST(street_addr_2 AS VARCHAR(500)) street_addr_2 ,
        CAST(cust.city AS VARCHAR(500)) city ,
        CAST(state AS VARCHAR(500)) state ,
        CAST(LEFT(zip, 5) AS VARCHAR(500)) Zip ,
        CAST(cust.country AS VARCHAR(500)) country ,
        CAST(email_addr AS VARCHAR(500)) email_addr ,
        CAST(fan_loyalty_id AS VARCHAR(500)) fan_loyalty_id ,
        CAST(CASE WHEN ISNULL(phone_day, '') <> '' THEN phone_day
                  WHEN ISNULL(phone_eve, '') <> '' THEN phone_eve
                  WHEN ISNULL(phone_cell, '') <> '' THEN phone_cell
                  ELSE NULL
             END AS VARCHAR(500)) phone_cell ,
        CAST(UpdateDate AS VARCHAR(500)) UpdateDate ,
        CAST(cust_name_id AS VARCHAR(500)) cust_name_id,
		'' AS SeasonTicketHolder
INTO    #tmpTM
FROM    ods.TM_Cust cust WITH (NOLOCK) --look at primary only
        --INNER JOIN ( SELECT DISTINCT
        --                    C_Season_Ticket_Account_Number1
        --             FROM   ods.Eloqua_Contact WITH (NOLOCK)
        --             WHERE  ETL_IsDeleted = 0
        --                    --AND UpdatedAt > GETDATE() - 30
        --           ) ec ON CAST(cust.acct_id AS NVARCHAR(200)) = ec.C_Season_Ticket_Account_Number1
WHERE   1 = 1
--AND acct_id = '703801'
        --AND UpdateDate > GETDATE() - 30
        AND cust.Primary_code = 'Primary';

/*  Pick up only Eloqua records that are marked as STH (have a season ticket ID and are still in Eloqua)  */
SELECT  ISNULL(CAST('Eloqua' AS VARCHAR(500)),'') sourcesystem ,
        ISNULL(CAST(C_Season_Ticket_Account_Number1 AS VARCHAR(500)),'') C_Season_Ticket_Account_Number1 ,
        ISNULL(CAST(Title AS VARCHAR(500)),'') Title ,
        ISNULL(CAST(FirstName AS VARCHAR(500)),'') FirstName ,
        ISNULL(CAST(LastName AS VARCHAR(500)),'') LastName ,
        ISNULL(CAST(Company AS VARCHAR(500)),'') Company ,
        ISNULL(CAST(C_Date_of_Birth1 AS VARCHAR(500)),'') C_Date_of_Birth1 ,
        ISNULL(CAST(C_Gender1 AS VARCHAR(500)),'') C_Gender1 ,
        ISNULL(CAST(Address1 AS VARCHAR(500)),'') Address1 ,
        ISNULL(CAST(Address2 AS VARCHAR(500)),'') Address2 ,
        ISNULL(CAST(ec.City AS VARCHAR(500)),'') City ,
        ISNULL(CAST(ec.Province AS VARCHAR(500)),'') Province ,
        ISNULL(CAST(ec.PostalCode AS VARCHAR(500)),'') PostalCode ,
        ISNULL(CAST(CASE WHEN ec.Country = 'US' THEN 'USA' ELSE ec.country END AS VARCHAR(500)),'') Country ,
        ISNULL(CAST(EmailAddress AS VARCHAR(500)),'') EmailAddress ,
        ISNULL(CAST('c_experience_id' AS VARCHAR(500)),'') AS fan_loyalty_id ,
        ISNULL(CAST(MobilePhone AS VARCHAR(500)),'') MobilePhone ,
        ISNULL(CAST(UpdatedAt AS VARCHAR(500)),'') UpdatedAt ,
        ISNULL(CAST(ec.ContactIDExt AS VARCHAR(500)),'') AS cust_name_id,
		ISNULL(CAST(ec.C_Season_Ticket_Holder1 AS NVARCHAR(100)), '') AS SeasonTicketHolder
INTO    #tmpEloqua
FROM    ods.Eloqua_Contact ec WITH (NOLOCK)
        --INNER JOIN ( SELECT acct_id
        --             FROM   ods.TM_Cust WITH (NOLOCK)
        --             WHERE  Primary_code = 'Primary'
        --             --AND  UpdateDate > GETDATE() - 30
        --           ) cust ON CAST(cust.acct_id AS NVARCHAR(200)) = ec.C_Season_Ticket_Account_Number1
WHERE   1=1
AND ISNULL(ec.EmailAddress, '') <> ''



/*  Pick up all non-primary TM records  */
SELECT  CAST('TM Non Primary' AS VARCHAR(500)) Sourcesystem ,
        CAST(cust.acct_id AS VARCHAR(500)) acct_id ,
        CAST(name_title AS VARCHAR(500)) name_title ,
        CAST(name_first AS VARCHAR(500)) name_first ,
        CAST(name_last AS VARCHAR(500)) name_last ,
        CAST(company_name AS VARCHAR(500)) company_name ,
        CAST(birth_date AS VARCHAR(500)) birth_date ,
        CAST(gender AS VARCHAR(500)) gender ,
        CAST(street_addr_1 AS VARCHAR(500)) street_addr_1 ,
        CAST(street_addr_2 AS VARCHAR(500)) street_addr_2 ,
        CAST(cust.city AS VARCHAR(500)) city ,
        CAST(state AS VARCHAR(500)) state ,
        CAST(LEFT(zip, 5) AS VARCHAR(500)) Zip ,
        CAST(cust.country AS VARCHAR(500)) country ,
        CAST(email_addr AS VARCHAR(500)) email_addr ,
        CAST(fan_loyalty_id AS VARCHAR(500)) fan_loyalty_id ,
        CAST(CASE WHEN ISNULL(phone_day, '') <> '' THEN phone_day
                  WHEN ISNULL(phone_eve, '') <> '' THEN phone_eve
                  WHEN ISNULL(phone_cell, '') <> '' THEN phone_cell
                  ELSE NULL
             END AS VARCHAR(500)) phone_cell ,
        CAST(UpdateDate AS VARCHAR(500)) UpdateDate ,
        CAST(cust_name_id AS VARCHAR(500)) cust_name_id,
		'' AS SeasonTicketHolder
INTO    #tmpTMSecondary
FROM    ods.TM_Cust cust WITH (NOLOCK) --look at primary only
        --INNER JOIN ods.Eloqua_Contact ec WITH (NOLOCK) ON CAST(cust.acct_id AS NVARCHAR(200)) = ec.C_Season_Ticket_Account_Number1
WHERE   1 = 1
--AND acct_id = '703801'
        --AND UpdateDate > GETDATE() - 30
        AND cust.Primary_code <> 'Primary';

/*  Pick up all primary TM MDM records  */
SELECT  CAST('MDM' AS VARCHAR(500)) Sourcesystem ,
        CAST(accountid AS VARCHAR(500)) accountid ,
        CAST(prefix AS VARCHAR(500)) prefix ,
        CAST(firstname AS VARCHAR(500)) firstname ,
        CAST(lastname AS VARCHAR(500)) lastname ,
        CAST(companyname AS VARCHAR(500)) companyname ,
        CAST(dc.Birthday AS VARCHAR(500)) Birthday ,
        CAST(dc.Gender AS VARCHAR(500)) gender ,
        CAST(dc.AddressPrimaryStreet AS VARCHAR(500)) AddressPrimaryStreet ,
        CAST(dc.AddressPrimarySuite AS VARCHAR(500)) AddressPrimarySuite ,
        CAST(dc.AddressPrimaryCity AS VARCHAR(500)) AddressPrimaryCity ,
        CAST(dc.AddressPrimaryState AS VARCHAR(500)) AddressPrimaryState ,
        CAST(LEFT(dc.AddressPrimaryZip, 5) AS VARCHAR(500)) AddressPrimaryZip ,
        CAST(dc.AddressPrimaryCountry AS VARCHAR(500)) AddressPrimaryCountry ,
        CAST(dc.EmailPrimary AS VARCHAR(500)) EmailPrimary ,
        CAST('No Match' AS VARCHAR(500)) fan_loyalty_id ,
        CAST(phoneprimary as VARCHAR(500)) phoneprimary ,
        CAST(dc.UpdatedDate AS VARCHAR(500)) UpdatedDate ,
        CAST(dc.SSID AS VARCHAR(500)) SSID,
		'' AS SeasonTicketHolder
              INTO #tmpMDM
FROM dbo.vwdimcustomer_modacctid dc
INNER JOIN #tmpTM tm ON dc.accountid = tm.acct_id
WHERE dc.sourcesystem = 'TM' AND customertype = 'Primary'     
--SELECT * FROM ods.tm_cust


/*  Only keep Eloqua records that match up against current TM plans - switch over to dim/fact in future.  */
SELECT DISTINCT 
e.C_Season_Ticket_Account_Number1, e.EmailAddress
--e.*, p.event_name
INTO #e1 
FROM #tmpEloqua e
JOIN dbo.FactTicketSales f ON CAST(f.SSID_acct_id AS NVARCHAR(500)) = e.C_Season_Ticket_Account_Number1
JOIN dbo.DimPlan p ON p.DimPlanId = f.DimPlanId 
--JOIN ods.TM_Plans p ON CAST(p.acct_id AS NVARCHAR(500)) = e.C_Season_Ticket_Account_Number1
WHERE p.PlanCode IN ('17FS', '17FSCLUB')
-- 22,283 records for eloqua '17 season



/*  Narrow down TM primary records to only those in a current plan  */

SELECT	DISTINCT 
tm.acct_id, tm.email_addr
--tm.*, p.event_name
INTO #tm1
FROM #tmpTM tm 
JOIN dbo.FactTicketSales f ON f.SSID_acct_id = tm.acct_id
JOIN dbo.DimPlan p ON p.DimPlanId = f.DimPlanId
--JOIN ods.TM_Plans p ON p.acct_id = tm.acct_id
WHERE p.PlanCode IN ('17FS', '17FSCLUB')
---- 24,045 records for tm '17 season


SELECT DISTINCT C_Season_Ticket_Account_Number1, EmailAddress
INTO #tmpEloqua2
FROM #tmpEloqua


CREATE INDEX idx_eloqua ON #tmpEloqua (C_Season_Ticket_Account_Number1, EmailAddress)
CREATE INDEX idx_mdm ON #tmpMDM (accountid, EmailPrimary)
CREATE INDEX idx_tm1 ON #tm1 (acct_id, email_addr)
CREATE INDEX idx_tm2 ON #tmpTMSecondary (acct_id, email_addr)
CREATE INDEX idx_tm ON #tmpTM (acct_id, email_addr)
CREATE INDEX idx_e1 ON #e1 (C_Season_Ticket_Account_Number1, EmailAddress) 
--CREATE INDEX idx_e2 ON #tmpEloqua2 (C_Season_Ticket_Account_Number1, EmailAddress)


--  ============================================================================
--  Bucket 1: TM not in Eloqua
--  ============================================================================

--SELECT DISTINCT fact.SSID_acct_id
--INTO #CYFact
--FROM dbo.FactTicketSales fact (NOLOCK)
--JOIN dbo.DimPlan p ON p.DimPlanId = fact.DimPlanId 
--WHERE p.PlanCode IN ('17FS', '17FSCLUB')

--CREATE INDEX idx_index1 ON #CYFact (SSID_acct_id)

--SELECT DISTINCT tm.acct_id
--INTO #Bucket1
--FROM #tm1 tm
--LEFT JOIN #tmpEloqua2 e ON e.C_Season_Ticket_Account_Number1 = CAST(tm.acct_id AS NVARCHAR(255))
--						OR e.EmailAddress = tm.email_addr
----JOIN #CYFact fact ON fact.SSID_acct_id = tm.acct_id
--where e.C_Season_Ticket_Account_Number1 IS NULL

SELECT * 
INTO #Bucket1
FROM (
SELECT acct_id
FROM #tm1
WHERE email_addr NOT IN (SELECT EmailAddress FROM #tmpEloqua)

EXCEPT	

SELECT acct_id
FROM #tm1
WHERE acct_id IN (SELECT C_Season_Ticket_Account_Number1 FROM #tmpEloqua)
) b



SELECT *
FROM (
SELECT 'TM - Not in Eloqua' AS Category, tm.*
FROM #tmpTM tm
JOIN #Bucket1 b ON b.acct_id = tm.acct_id

UNION
	
SELECT 'MDM' AS Category, mdm.*
FROM #tmpMDM mdm
JOIN #Bucket1 b ON mdm.accountid = b.acct_id
) x ORDER BY 3,1

/*  All TM records with a plan, narrow down to records that aren't marked in Eloqua as STH  */
--SELECT 'TM Plan - No eloqua' AS category, * 
--FROM #tmpTM
--WHERE acct_id IN (
--SELECT acct_id
--FROM #e1 e
--FULL JOIN #tm1 t ON e.C_Season_Ticket_Account_Number1 = t.acct_id OR e.EmailAddress = t.email_addr
--WHERE C_Season_Ticket_Account_Number1 IS NULL
--AND email_addr <> ''
--)
--UNION
--SELECT 'MDM' AS category, *
--FROM #tmpMDM
--WHERE accountid IN 
--(
--SELECT acct_id
--FROM #e1 
--FULL JOIN #tm1 ON C_Season_Ticket_Account_Number1 = acct_id OR EmailAddress = email_addr
--WHERE C_Season_Ticket_Account_Number1 IS NULL
--AND EmailPrimary <> ''
--)
--ORDER BY 3,1


--  ============================================================================
--  Bucket 2: Eloqua not in TM
--  ============================================================================

/*  All records marked as STH in Eloqua narrowed down to any that aren't part of a current TM plan  */
SELECT 'Eloqua STH - No plan' AS category, *
FROM #e1 
FULL JOIN #tm1 ON C_Season_Ticket_Account_Number1 = acct_id
WHERE acct_id IS NULL
--  0 records that are in Eloqua that are not in TM for 17FS



--  ============================================================================
--  Bucket 3: Mismatching Emails
--  ============================================================================



SELECT  DISTINCT tm.acct_id
INTO #bucket3
 FROM #e1 e1
JOIN #tmpEloqua e ON e.C_Season_Ticket_Account_Number1 = e1.C_Season_Ticket_Account_Number1
JOIN #tm1 tm1 ON CAST(tm1.acct_id AS NVARCHAR(100)) = e.C_Season_Ticket_Account_Number1
JOIN #tmpTM tm ON tm.acct_id = tm1.acct_id
WHERE e.EmailAddress <> tm.email_addr 
OR (ISNULL(e.EmailAddress, '') = '' AND ISNULL(tm.email_addr, '') <> '')
OR (ISNULL(e.EmailAddress, '') <> '' AND ISNULL(tm.email_addr, '') = '')
-----------------------------------------------------------------------------------------------------
SELECT duplicates.C_Season_Ticket_Account_Number1 
INTO #eDuplicates 
FROM 
(
SELECT x.sourcesystem, x.C_Season_Ticket_Account_Number1, COUNT(*) AS count
FROM (
SELECT * FROM #tmpEloqua WHERE C_Season_Ticket_Account_Number1 IN (SELECT acct_id FROM #bucket3)
UNION 
SELECT * FROM #tmpTM WHERE acct_id IN (SELECT acct_id FROM #bucket3)
UNION
SELECT * FROM #tmpMDM WHERE accountid IN (SELECT acct_id FROM #bucket3)
) x
GROUP BY x.sourcesystem ,
         x.C_Season_Ticket_Account_Number1
HAVING COUNT(*) > 1 AND x.sourcesystem = 'Eloqua'
--ORDER BY 2,1
) duplicates
----------------------------------------------------------------------------------------------------
--  ============================================================================
--  Bucket 3: Mismatching non duplicate emails
--  ============================================================================


SELECT * FROM #tmpEloqua WHERE C_Season_Ticket_Account_Number1 IN (SELECT acct_id FROM #bucket3)
AND C_Season_Ticket_Account_Number1 NOT IN (SELECT C_Season_Ticket_Account_Number1 FROM #eDuplicates)
UNION 
SELECT * FROM #tmpTM WHERE acct_id IN (SELECT acct_id FROM #bucket3)
AND acct_id NOT IN (SELECT C_Season_Ticket_Account_Number1 FROM #eDuplicates)
UNION
SELECT * FROM #tmpMDM WHERE accountid IN (SELECT acct_id FROM #bucket3)
AND accountid NOT IN (SELECT C_Season_Ticket_Account_Number1 FROM #eDuplicates)
ORDER BY 2,1

--  ============================================================================
--  Bucket 4: Mismatching duplicate emails
--  ============================================================================

SELECT * FROM #tmpEloqua WHERE C_Season_Ticket_Account_Number1 IN (SELECT acct_id FROM #bucket3)
AND C_Season_Ticket_Account_Number1 IN (SELECT C_Season_Ticket_Account_Number1 FROM #eDuplicates)
UNION 
SELECT * FROM #tmpTM WHERE acct_id IN (SELECT acct_id FROM #bucket3)
AND acct_id IN (SELECT C_Season_Ticket_Account_Number1 FROM #eDuplicates)
UNION
SELECT * FROM #tmpMDM WHERE accountid IN (SELECT acct_id FROM #bucket3)
AND accountid  IN (SELECT C_Season_Ticket_Account_Number1 FROM #eDuplicates)
ORDER BY 2,1





--  ============================================================================
--  Bucket 5: Blank Demo Columns
--  ============================================================================
SELECT DISTINCT tm.acct_id
INTO #bucket4
FROM #tmpTM tm
JOIN #tm1 tm1 ON tm1.acct_id = tm.acct_id
JOIN #tmpEloqua e ON e.C_Season_Ticket_Account_Number1 = CAST(tm.acct_id AS NVARCHAR(100))
JOIN #e1 e1 ON e1.C_Season_Ticket_Account_Number1 = e.C_Season_Ticket_Account_Number1
WHERE 1=1 
AND (
   (ISNULL(e.EmailAddress, '') = '' and ISNULL(tm.email_addr, '') <> '') OR (ISNULL(e.EmailAddress, '') <> '' and ISNULL(tm.email_addr, '') = '') -- Emails
OR (ISNULL(e.FirstName, '') = '' and ISNULL(tm.name_first, '') <> '') OR (ISNULL(e.FirstName, '') <> '' and ISNULL(tm.name_first, '') = '') -- First Name
OR (ISNULL(e.LastName, '') = '' and ISNULL(tm.name_last, '') <> '') OR (ISNULL(e.LastName, '') <> '' and ISNULL(tm.name_last, '') = '') -- Last Name
OR (ISNULL(e.Company, '') = '' and ISNULL(tm.company_name, '') <> '') OR (ISNULL(e.Company, '') <> '' and ISNULL(tm.company_name, '') = '') -- Company Name
OR (ISNULL(e.C_Date_of_Birth1, '') = '' and ISNULL(tm.birth_date, '') <> '')  OR (ISNULL(e.C_Date_of_Birth1, '') <> '1900-01-01' OR ISNULL(tm.birth_date, '') = '1900-01-01')
	OR (ISNULL(e.C_Date_of_Birth1, '') <> '' and ISNULL(tm.birth_date, '') = '')  OR (ISNULL(e.C_Date_of_Birth1, '') = '1900-01-01' OR ISNULL(tm.birth_date, '') <> '1900-01-01')	
			 -- Birthday 
--OR (ISNULL(e.C_Gender1, '') = '' and ISNULL(tm.gender, '') <> '') OR (ISNULL(e.C_Gender1, '') <> '' and ISNULL(tm.gender, '') = '') -- Gender
OR (ISNULL(e.Address1, '') = '' and ISNULL(tm.street_addr_1, '') <> '') OR (ISNULL(e.Address1, '') <> '' and ISNULL(tm.street_addr_1, '') = '') -- Street Address 1
OR (ISNULL(e.Address2, '') = '' and ISNULL(tm.street_addr_2, '') <> '') OR (ISNULL(e.Address2, '') <> '' and ISNULL(tm.street_addr_2, '') = '') -- Street Address 2
OR (CONCAT(ISNULL(e.Address1, ''), ISNULL(e.Address2, '')) = '' and CONCAT(ISNULL(tm.street_addr_1, ''), ISNULL(tm.street_addr_2, '')) <> '') 
			OR (CONCAT(ISNULL(e.Address1, ''), ISNULL(e.Address2,'')) <> '' and CONCAT(ISNULL(tm.street_addr_1, ''), ISNULL(tm.street_addr_2,'')) = '') -- Street Address 1 and 2
OR (ISNULL(e.City, '') = '' and ISNULL(tm.city, '') <> '') OR (ISNULL(e.City, '') <> '' and ISNULL(tm.city, '') = '') -- City
OR (ISNULL(e.Province, '') = '' and ISNULL(tm.state, '') <> '') OR (ISNULL(e.Province, '') <> '' and ISNULL(tm.state, '') = '') -- State / Province
OR (ISNULL(e.PostalCode, '') = '' and ISNULL(tm.Zip, '') <> '') OR (ISNULL(e.PostalCode, '') <> '' and ISNULL(tm.Zip, '') = '') -- Zip code
OR (ISNULL(e.Country, '') = '' and ISNULL(tm.country, '') <> '') OR (ISNULL(e.Country, '') <> '' and ISNULL(tm.country, '') = '') -- Country
--OR (ISNULL(e.fan_loyalty_id, '') = '' and ISNULL(tm.fan_loyalty_id, '') <> '') OR (ISNULL(e.fan_loyalty_id, '') <> '' and ISNULL(tm.fan_loyalty_id, '') = '') -- Fan Loyalty ID
OR (ISNULL(e.MobilePhone, '') = '' and ISNULL(tm.phone_cell, '') <> '') OR (ISNULL(e.MobilePhone, '') <> '' and ISNULL(tm.phone_cell, '') = '') -- Phone
)


---------------------------------------------------------------------------------------
SELECT * FROM #tmpEloqua WHERE C_Season_Ticket_Account_Number1 IN (SELECT acct_id FROM #bucket4)
UNION 
SELECT * FROM #tmpTM WHERE acct_id IN (SELECT acct_id FROM #bucket4)
UNION
SELECT * FROM #tmpMDM WHERE accountid IN (SELECT acct_id FROM #bucket4)
ORDER BY 2,1

--  ============================================================================
--  Bucket 5: Secondary TM
--  ============================================================================
SELECT DISTINCT s.acct_id 
FROM #tmpTMSecondary s
JOIN #tmpTM tm ON tm.acct_id = s.acct_id
----------------------------------------------------------------------------------
SELECT * FROM #tmpEloqua WHERE C_Season_Ticket_Account_Number1 IN (SELECT DISTINCT s.acct_id 
FROM #tmpTMSecondary s
JOIN #tmpTM tm ON tm.acct_id = s.acct_id)
UNION 
SELECT * FROM #tmpTM WHERE acct_id IN (SELECT DISTINCT s.acct_id 
FROM #tmpTMSecondary s
JOIN #tmpTM tm ON tm.acct_id = s.acct_id)
UNION
SELECT * FROM #tmpMDM WHERE accountid IN (SELECT DISTINCT s.acct_id 
FROM #tmpTMSecondary s
JOIN #tmpTM tm ON tm.acct_id = s.acct_id)
UNION
SELECT * FROM #tmpTMSecondary WHERE acct_id IN (SELECT DISTINCT s.acct_id 
FROM #tmpTMSecondary s
JOIN #tmpTM tm ON tm.acct_id = s.acct_id)
ORDER BY 2,1

--  ============================================================================
--  Bucket 6: STH Account Number Mismatches
--  ============================================================================
 SELECT C_Season_Ticket_Account_Number1,C_Season_Ticket_Holder1, IsSubscribed, ETL_IsDeleted,
 FirstName,
 LastName,
 Company,
 Address1,
 Address2,
 City,
 Province,
 Country,
 EmailAddress,
 MobilePhone,
 ContactIDExt
  FROM 
 ods.Eloqua_Contact
 WHERE 1=1
 AND (ISNULL(C_Season_Ticket_Account_Number1, '') = '' AND C_Season_Ticket_Holder1 = 'Yes')
 AND ETL_IsDeleted = 0
 --AND IsSubscribed = 1
 UNION
  SELECT C_Season_Ticket_Account_Number1,C_Season_Ticket_Holder1, e.IsSubscribed, e.ETL_IsDeleted, -- tm.acct_id,
 FirstName,
 LastName,
 Company,
 Address1,
 Address2,
 e.City,
 Province,
 e.Country,
 e.EmailAddress,
 MobilePhone,
 ContactIDExt
  FROM 
 ods.Eloqua_Contact e
--left
-- JOIN ods.TM_Cust tm ON e.C_Season_Ticket_Account_Number1 = CAST(tm.acct_id AS NVARCHAR(100))
 WHERE 1=1
 AND (ISNULL(C_Season_Ticket_Account_Number1, '') <> '' AND ISNULL(C_Season_Ticket_Holder1, 'No') = 'No')
 AND ETL_IsDeleted = 0
-- AND IsSubscribed = 1
-- AND tm.acct_id IS NULL
ORDER BY C_Season_Ticket_Account_Number1


--  ============================================================================
--  Bucket 7: MDM Duplicates
--  ============================================================================
SELECT one.* FROM #tmpMDM one
JOIN (
SELECT EmailPrimary, COUNT(*) count
FROM #tmpMDM
GROUP BY EmailPrimary 
HAVING COUNT(*) > 1 ) 
x ON x.EmailPrimary = one.EmailPrimary
WHERE one.EmailPrimary <> ''
--ORDER BY one.EmailPrimary


SELECT DISTINCT one.EmailPrimary FROM #tmpMDM one
JOIN (
SELECT EmailPrimary, COUNT(*) count
FROM #tmpMDM
GROUP BY EmailPrimary 
HAVING COUNT(*) > 1 ) 
x ON x.EmailPrimary = one.EmailPrimary
WHERE one.EmailPrimary <> ''
--ORDER BY one.EmailPrimary
GO
