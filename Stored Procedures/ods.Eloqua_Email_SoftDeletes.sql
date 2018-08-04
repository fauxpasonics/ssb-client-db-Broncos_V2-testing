SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE PROC [ods].[Eloqua_Email_SoftDeletes]
AS



IF OBJECT_ID('tempdb.dbo.#temp', 'U') IS NOT NULL
  DROP TABLE #temp;
SELECT ETL_CreatedDate, EmailAddress, IsBounceback, IsSubscribed, Id, ETL_ID, CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END AS SeasonTicket INTO #temp
FROM ods.Eloqua_Contact
where ETL_IsDeleted = 0   -- Find the records that are not already deleted, also create a flag for season ticket holders. This will be used later as the initial sort. 
--There are over 790,000 records in here

--Now these queries look for the other attributes and put them into buckets, so that only record with that attribute ends up in the bucket.
IF OBJECT_ID('tempdb.dbo.#count', 'U') IS NOT NULL
  DROP TABLE #count;
select t.EMailAddress, count(*) as GroupCount, MAX(CASE WHEN EmailGroup = 'Outlaws' THEN 1 ELSE 0 END) Outlaws  into #count from #temp t
INNER JOIN ods.EloquaCustom_EmailGroupMembers e on t.EmailAddress = e.EmailAddress
Group by t.EmailAddress
order by count(*)   -- Find the records that have email subscriptions in any of the requested email subscription lists

--All of the following queries are just to show what the bucket sizes are for each of the parameters requested.
select t.EmailAddress, t.Id, c.GroupCount from #temp t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
WHERE c.GroupCount IS NOT NULL  -- only 210,000 records in some email group

select t.EmailAddress, t.Id, b.BunchMember from #temp t
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
WHERE b.BunchMember IS NOT NULL -- only 7,825 distinct records that are Bunch members

select t.EmailAddress, t.Id, cm.CrushMember from #temp t
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
WHERE cm.CrushMember IS NOT NULL -- just under 17,000 records that are Crush embers

select t.EmailAddress, t.Id, op.OpenLastYear from #temp t
LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
Group BY ContactId) op ON t.Id = op.ContactId
WHERE op.OpenLastYear IS NOT NULL -- about 366,000 records have opened an email in the last year, need more

select t.EmailAddress, t.Id, f.MerchCount from #temp t
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
WHERE f.MerchCount IS NOT NULL -- about 84,000 have opened in the last year, need more

select t.EmailAddress, t.Id, ct.ClickThroughYear from #temp t
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE ct.ClickThroughYear IS NOT NULL --about 215,000 records have clicked through, need more. 

--There is no easy answer to that, so I am going to see how many records have any of the desired attributes but unioning them into one table.
/*
select t.EmailAddress, t.Id, c.GroupCount, f.MerchCount, op.OpenLastYear, b.BunchMember, cm.CrushMember from ods.Eloqua_Contact t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
Group BY ContactId) op ON t.Id = op.ContactId
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
WHERE t.ETL_IsDeleted = 0
AND c.GroupCount IS NOT NULL   -- union all of the records
OR b.BunchMember IS NOT NULL
OR cm.CrushMember IS NOT NULL
OR op.OpenLastYear IS NOT NULL
OR f.Client_Email IS NOT NULL
*/
--total number of records at this point is 474,047, which is close to what we want but we still want to delete some of them.
-- The following query ranks them by how important they are.

select ROW_NUMBER() OVER (Order by CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END DESC, 
(CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END+CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END +CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END+CASE WHEN f.merchCount IS NULL THEN 0 ELSE f.merchCount END+
CASE WHEN op6.Open6Month IS NULL THEN 0 ELSE op6.Open6Month END+CASE WHEN ct.ClickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END) DESC,
CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END DESC, CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END DESC, CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END DESC,
IsBounceBack, CASE WHEN f.MerchCount IS NULL THEN 0 ELSE f.MerchCount END DESC, CASE WHEN ct.CLickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END DESC,
IsSubscribed DESC, op6.Open6Month) AS RANK,
t.Id, (CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END+CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END +CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END+CASE WHEN f.merchCount IS NULL THEN 0 ELSE f.merchCount END+
CASE WHEN op6.Open6Month IS NULL THEN 0 ELSE op6.Open6Month END+CASE WHEN ct.ClickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END) AS TotalActivity, CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END AS GroupCount, 
f.MerchCount, op6.Open6Month, b.BunchMember, cm.CrushMember, ct.ClickThroughYear, CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END AS SeasonTicket,
t.IsBounceback, t.IsSubscribed, c.Outlaws, t.EmailAddress INTO #ContactRank from ods.Eloqua_Contact t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
--LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
--WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
--Group BY ContactId) op ON t.Id = op.ContactId
LEFT JOIN (SELECT ContactId, count(*) Open6Month from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(MONTH,-6,GETDATE())
Group BY ContactId) op6 ON t.Id = op6.ContactId
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE t.ETL_IsDeleted = 0-- AND IsBounceback = 0 AND IsSubscribed = 1--can be added in case there are no BounceBcaks that need to be kept, check for season ticket holders with bounceback flags.


/********************************************BOUNCE BACK TABLE***************************************************************/

select t.Id from ods.Eloqua_Contact t 
WHERE t.ETL_IsDeleted = 0 AND IsBounceback = 1 AND C_Season_Ticket_Account_Number1 IS NOT NULL

/********************************************NOT BOUNCE BACK TABLE*********************************************/
Select * from #ContactRank WHERE IsBounceback = 0 ORDER BY RANK

/*******************************************WATERFALL BUCKETS******************************************************
--All of the following queries are just to show what the bucket sizes are for each of the parameters requested.
select t.EmailAddress, t.Id, c.GroupCount from #temp t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
WHERE c.GroupCount IS NOT NULL  -- only 210,000 records in some email group

select t.EmailAddress, t.Id, b.BunchMember from #temp t
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
WHERE b.BunchMember IS NOT NULL -- only 7,825 distinct records that are Bunch members

select t.EmailAddress, t.Id, cm.CrushMember from #temp t
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
WHERE cm.CrushMember IS NOT NULL -- just under 17,000 records that are Crush embers

select t.EmailAddress, t.Id, op.OpenLastYear from #temp t
LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
Group BY ContactId) op ON t.Id = op.ContactId
WHERE op.OpenLastYear IS NOT NULL -- about 366,000 records have opened an email in the last year, need more

select t.EmailAddress, t.Id, f.MerchCount from #temp t
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
WHERE f.MerchCount IS NOT NULL -- about 84,000 have opened in the last year, need more

select t.EmailAddress, t.Id, ct.ClickThroughYear from #temp t
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE ct.ClickThroughYear IS NOT NULL --about 215,000 records have clicked through, need more. 

*****************************************************************************************************************************************/




/*
IF OBJECT_ID('tempdb.dbo.#GoodContact', 'U') IS NOT NULL
  DROP TABLE #GoodContact;
select TOP 424300 ROW_NUMBER() OVER (Order by t.SeasonTicket DESC, c.GroupCount DESC, b.BunchMember DESC, cm.CrushMember DESC, f.MerchCount DESC, op.OpenLastYear DESC, ct.CLickThroughYear DESC, op6.Open6Month DESC) AS RANK,
t.Id, c.GroupCount, f.MerchCount, op.OpenLastYear, b.BunchMember, cm.CrushMember, ct.ClickThroughYear, op6.Open6Month, t.SeasonTicket, t.EmailAddress INTO #GoodContact from #tmp1 t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
Group BY ContactId) op ON t.Id = op.ContactId
LEFT JOIN (SELECT ContactId, count(*) Open6Month from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(MONTH,-6,GETDATE())
Group BY ContactId) op6 ON t.Id = op6.ContactId
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE c.GroupCount IS NOT NULL   -- union all of the records
OR b.BunchMember IS NOT NULL
OR cm.CrushMember IS NOT NULL
OR op.OpenLastYear IS NOT NULL
OR f.Client_Email IS NOT NULL  --Did not include click through because click through is not possible without opening  --Try to rank by most recent open


SELECT EmailAddress FROM #GoodContact Order BY Rank --These are good emails. 


--add ranking field

SELECT c.EmailAddress FROM ods.Eloqua_Contact c
LEFT JOIN #GoodContact g on c.EmailAddress = g.EmailAddress
WHERE g.EmailAddress IS NULL AND c.ETL_IsDeleted = 0
--All of the emails that come up here should be deletable. They are the emails that I deemed not to be important


Select EmailAddress, count(*) from #GoodContact
GROUP BY EmailAddress order by 2 desc  --no duplicate records, that's a good thing

select ROW_NUMBER() OVER (Order by CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END DESC, 
(CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END+CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END +CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END+CASE WHEN f.merchCount IS NULL THEN 0 ELSE f.merchCount END+
CASE WHEN op.OpenLastYear IS NULL THEN 0 ELSE op.OpenLastYear END+CASE WHEN ct.ClickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END) DESC,
CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END DESC, CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END DESC, CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END DESC,
IsBounceBack, CASE WHEN f.MerchCount IS NULL THEN 0 ELSE f.MerchCount END DESC, CASE WHEN op.OpenLastYear IS NULL THEN 0 ELSE op.OpenLastYear END DESC, CASE WHEN ct.CLickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END DESC,
IsSubscribed DESC, op6.Open6Month) AS RANK,
t.Id, (CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END+CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END +CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END+CASE WHEN f.merchCount IS NULL THEN 0 ELSE f.merchCount END+
CASE WHEN op.OpenLastYear IS NULL THEN 0 ELSE op.OpenLastYear END+CASE WHEN ct.ClickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END) AS TotalActivity, CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END AS GroupCount, 
f.MerchCount, op.OpenLastYear, b.BunchMember, cm.CrushMember, ct.ClickThroughYear, op6.Open6Month, CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END AS SeasonTicket,
t.IsBounceback, t.IsSubscribed, c.Outlaws, t.EmailAddress from ods.Eloqua_Contact t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
Group BY ContactId) op ON t.Id = op.ContactId
LEFT JOIN (SELECT ContactId, count(*) Open6Month from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(MONTH,-6,GETDATE())
Group BY ContactId) op6 ON t.Id = op6.ContactId
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE t.ETL_IsDeleted = 0 AND IsBounceback = 0

select top 467488 ROW_NUMBER() OVER (Order by CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END DESC, 
(CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END+CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END +CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END+CASE WHEN f.merchCount IS NULL THEN 0 ELSE f.merchCount END+
CASE WHEN op6.Open6Month IS NULL THEN 0 ELSE op6.Open6Month END+CASE WHEN ct.ClickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END) DESC,
CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END DESC, CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END DESC, CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END DESC,
IsBounceBack, CASE WHEN f.MerchCount IS NULL THEN 0 ELSE f.MerchCount END DESC, CASE WHEN ct.CLickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END DESC,
IsSubscribed DESC, op6.Open6Month) AS RANK,
t.Id, (CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END+CASE WHEN b.BunchMember IS NULL THEN 0 ELSE b.BunchMember END +CASE WHEN cm.CrushMember IS NULL THEN 0 ELSE cm.CrushMember END+CASE WHEN f.merchCount IS NULL THEN 0 ELSE f.merchCount END+
CASE WHEN op6.Open6Month IS NULL THEN 0 ELSE op6.Open6Month END+CASE WHEN ct.ClickThroughYear IS NULL THEN 0 ELSE ct.ClickThroughYear END) AS TotalActivity, CASE WHEN c.GroupCount IS NULL THEN 0 ELSE c.GroupCount END AS GroupCount, 
f.MerchCount, op6.Open6Month, b.BunchMember, cm.CrushMember, ct.ClickThroughYear, CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END AS SeasonTicket,
t.IsBounceback, t.IsSubscribed, c.Outlaws, t.EmailAddress INTO #GoodContact from ods.Eloqua_Contact t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
--LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
--WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
--Group BY ContactId) op ON t.Id = op.ContactId
LEFT JOIN (SELECT ContactId, count(*) Open6Month from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(MONTH,-6,GETDATE())
Group BY ContactId) op6 ON t.Id = op6.ContactId
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE t.ETL_IsDeleted = 0 AND IsBounceback = 0 AND IsSubscribed = 1

SELECT * FROM #GoodContact ORDER BY RANK

select ROW_NUMBER() OVER (Order by t.IsBounceBack, t.IsSubscribed DESC, CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END DESC,
c.GroupCount DESC, b.BunchMember DESC, cm.CrushMember DESC, f.MerchCount DESC, op.OpenLastYear DESC, ct.CLickThroughYear DESC, op6.Open6Month DESC) AS RANK,
t.Id, c.GroupCount, f.MerchCount, op.OpenLastYear, b.BunchMember, cm.CrushMember, ct.ClickThroughYear, op6.Open6Month,
CASE WHEN C_Season_Ticket_Account_Number1 IS NOT NULL THEN 1 ELSE 0 END AS SeasonTicket, t.IsBounceback, t.IsSubscribed, c.outlaws, t.EmailAddress from ods.Eloqua_Contact t 
LEFT JOIN #count c on t.EmailAddress = c.EmailAddress
LEFT JOIN (SELECT Parents_Email_Address1, COUNT(*) As BunchMember FROM ods.EloquaCustom_BroncosBunchMasterList  --Find records that have kids that are Bunch memebers
GROUP BY Parents_Email_Address1) b ON t.EmailAddress = b.Parents_Email_Address1
LEFT JOIN (SELECT EmailAddress, Count(*) AS CrushMember FROM ods.EloquaCustom_CrushMembers --Find records that are crush members
GROUP BY EmailAddress) cm on t.EmailAddress = cm.EmailAddress
LEFT JOIN (SELECT ContactId, count(*) OpenLastYear from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(YEAR,-1,GETDATE())
Group BY ContactId) op ON t.Id = op.ContactId
LEFT JOIN (SELECT ContactId, count(*) Open6Month from ods.Eloqua_ActivityEmailOpen --Find all records that have an email open within the last year
WHERE ETL_IsDeleted = 0 AND CreatedAt > DATEADD(MONTH,-6,GETDATE())
Group BY ContactId) op6 ON t.Id = op6.ContactId
LEFT JOIN (Select Client_Email, Count(*) MerchCount FROM ods.Fanatics_Orders  --find all orders that have merch purchases
GROUP BY Client_Email) f ON t.EmailAddress = f.Client_Email
LEFT JOIN(SELECT ContactId, Count(*) ClickThroughYear FROM ods.Eloqua_ActivityEmailClickThrough
GROUP BY ContactId) ct ON t.Id = ct.ContactId
WHERE t.ETL_IsDeleted = 0 AND t.Id NOT IN (SELECT Id FROM #GoodContact) AND t.id NOT IN (select t.Id from ods.Eloqua_Contact t 
WHERE t.ETL_IsDeleted = 0 AND IsBounceback = 1 AND C_Season_Ticket_Account_Number1 IS NOT NULL)


*/

GO
