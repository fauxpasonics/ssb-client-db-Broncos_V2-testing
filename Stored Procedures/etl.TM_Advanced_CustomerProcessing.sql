SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_Advanced_CustomerProcessing] 

as
BEGIN

--select * From dbo.DimCustomerStaging

declare @RunTime datetime = getdate()

/*********************************************************************************************************************************************************************************************
Recognize accounts where the primary name has changed
*********************************************************************************************************************************************************************************************/

INSERT INTO etl.TM_Cust_AdvancedProcessingQueue (ETL_CreatedDate, ETL_ProcessedDate, acct_id, Orig_CustNameId, Orig_SSID, New_CustNameId, New_SSID, Orig_NameCurrentPrimaryCode, Orig_NameNewPrimaryCode)

SELECT @RunTime ETL_CreatedDate, NULL ETL_ProcessedDate
, o.acct_id, o.cust_name_id Orig_CustNameId, CONVERT(NVARCHAR(25), o.acct_id) + ':' + CONVERT(NVARCHAR(25), o.cust_name_id) Orig_SSID
, dan.cust_name_id NewCustNameId, CONVERT(NVARCHAR(25), dan.acct_id) + ':' + CONVERT(NVARCHAR(25), dan.cust_name_id) NewSSID, o.Primary_code OrigNameCurrentPrimaryCode, s.Primary_code OrigNameNewPrimaryCode 
--SELECT *
FROM ods.TM_Cust o
--INNER JOIN (SELECT DISTINCT acct_id FROM #src WHERE Primary_code = 'Primary') da ON o.acct_id = da.acct_id
INNER JOIN (SELECT DISTINCT CAST(acct_id AS INT) acct_id, CAST(cust_name_id AS INT) cust_name_id FROM src.TM_Cust WHERE Primary_code = 'Primary') dan ON o.acct_id = dan.acct_id
LEFT OUTER JOIN src.TM_Cust s ON CAST(s.acct_id AS INT) = o.acct_id AND CAST(s.cust_name_id AS INT) = o.cust_name_id 
WHERE o.Primary_code = 'Primary'
AND o.Primary_code <> ISNULL(s.Primary_code,'')



/*********************************************************************************************************************************************************************************************
Delete non primary name records that are no longer active.  Any change to an account in Archtics will send all names through the feed.  If the name no longer exists in the src then it has been deleted.
*********************************************************************************************************************************************************************************************/

SELECT o.id, o.acct_id, o.cust_name_id, CONVERT(NVARCHAR(25), o.acct_id) + ':' + CONVERT(NVARCHAR(25), o.cust_name_id) SSID
INTO #ToBeDeletedNameRecords
FROM ods.TM_Cust o
INNER JOIN (SELECT CAST(acct_id AS INT) acct_id FROM src.TM_Cust) da ON o.acct_id = da.acct_id
LEFT OUTER JOIN src.TM_Cust s ON s.acct_id = o.acct_id AND s.cust_name_id = o.cust_name_id
WHERE s.acct_id IS NULL
AND o.Primary_code <> 'Primary'

UPDATE dc
SET dc.IsDeleted = 1
, dc.DeleteDate = GETDATE()
, dc.UpdatedDate = GETDATE()
FROM dbo.DimCustomer dc
INNER JOIN #ToBeDeletedNameRecords d ON dc.SSID = d.SSID
WHERE dc.SourceSystem = 'TM'

DELETE c
FROM ods.tm_cust c
INNER JOIN #ToBeDeletedNameRecords d ON c.id = c.id
WHERE c.Primary_code <> 'Primary'

END



GO
