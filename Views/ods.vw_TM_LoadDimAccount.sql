SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[vw_TM_LoadDimAccount] as (

	select *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(FirstName),'DBNULL_TEXT') + ISNULL(RTRIM(LastName),'DBNULL_TEXT') + ISNULL(RTRIM(MiddleName),'DBNULL_TEXT') + ISNULL(RTRIM(Prefix),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_acct_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_cust_name_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(Suffix),'DBNULL_TEXT') + ISNULL(RTRIM(Title),'DBNULL_TEXT')) DeltaHashKey
	from (
		SELECT 
			null as [Prefix]
			, c.name_first as [FirstName]
			, c.name_mi as [MiddleName]
			, c.name_last as [LastName]
			, null as [Suffix]
			, c.name_title as Title
			, c.add_user [SSCreatedBy]
			, c.upd_user [SSUpdatedBy]
			, c.add_date [SSCreatedDate]
			, c.upd_date [SSUpdatedDate]
			, cast(c.acct_id as nvarchar(25)) + CAST(c.cust_name_id as nvarchar(25)) [SSID]
			, c.acct_id SSID_acct_id
			, c.cust_name_id SSID_cust_name_id
			, 'TM' as [SourceSystem]

		FROM ods.TM_Cust c
		WHERE primary_code = 'Primary'
		and updatedate > (getdate() - 2)
		--INNER JOIN (
		--	select acct_id, max(updatedate) as maxdate, min(cust_name_id) as minctct
		--	from ods.TM_Cust
		--	group by acct_id
		--) x on x.acct_id = c.acct_id and x.maxdate = c.UpdateDate and c.cust_name_id = x.minctct
	) a

)









GO
