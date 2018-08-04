SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--[api].[cust_CustomerLookupSearch] 'booth'

CREATE PROC [api].[cust_CustomerLookupSearch_20170424] (@SearchCriteria VARCHAR(200))
AS
BEGIN

	-- Init for response
	DECLARE @totalCount    INT,
		@xmlDataNode       XML,
		@rootNodeName      NVARCHAR(100),
		@responseInfoNode  NVARCHAR(MAX),
		@finalXml          XML
		
	-- Init for data
	DECLARE @returnData TABLE(
		SourceSystem           NVARCHAR(50),
		FirstName              NVARCHAR(100),
		MiddleName             NVARCHAR(100),
		LastName               NVARCHAR(100),
		AddressPrimaryStreet   NVARCHAR(500),
		AddressPrimaryCity     NVARCHAR(200),
		AddressPrimaryState    NVARCHAR(100),
		AddressPrimaryZip      NVARCHAR(25),
		[DimCustomerId]  varchar(50),
		SSID NVARCHAR(100)
	)
	--DECLARE @searchcriteria VARCHAR(100)
	--SET @searchcriteria = 'Brian'
	--single name search
	--first and last name search
	--SSID search
	DECLARE @searchpart1 VARCHAR(100)
	DECLARE @searchpart2 VARCHAR(100)
	DECLARE @ResultsCount int
	DECLARE @IsIdSearch BIT
    
	set @SearchCriteria = replace(@SearchCriteria,'(p)','.')
	
	--select * from rpt.TempDeleteMe

	SELECT @IsIdSearch = CASE WHEN @SearchCriteria LIKE '%[0-9]%' THEN 1 ELSE 0 end

	SET @SearchCriteria = REPLACE(REPLACE(@SearchCriteria,',',''),'!','')

	IF (CHARINDEX(' ',@SearchCriteria,0) > 0)
	BEGIN
		SELECT @searchpart1 = SUBSTRING(@SearchCriteria,1,CHARINDEX(' ',@SearchCriteria,0)-1),@searchpart2 = SUBSTRING(@SearchCriteria,CHARINDEX(' ',@SearchCriteria,0)+1,1000) 
	end

	
	IF (LEN(@SearchCriteria) > 0 AND @searchpart2 IS NULL AND @IsIdSearch = 0)
	begin
		
	-- Main query - insert results into the @returnData variable
	INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
	SELECT TOP 100 SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip , DimCustomerId,case when SourceSystem = 'TM' then SUBSTRING(ssid,1,CHARINDEX(':',ssid,1)-1) else SSID end
		FROM dbo.dimcustomer --[dbo].[DimCustomer]
		WHERE LastName LIKE @SearchCriteria + '%' --OR emailprimary LIKE @Searchpart1 + '%'
		ORDER BY FirstName, LastName


		
	SELECT @ResultsCount = COUNT(*) FROM @returnData

	IF (@ResultsCount<100 AND @IsIdSearch = 0) 
	BEGIN
		INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
		SELECT TOP 100 SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip , DimCustomerId,case when SourceSystem = 'TM' then SUBSTRING(ssid,1,CHARINDEX(':',ssid,1)-1) else SSID end
		FROM dbo.dimcustomer --[dbo].[DimCustomer]
		WHERE FirstName LIKE @SearchCriteria + '%' --OR emailprimary LIKE @SearchCriteria + '%'
		ORDER BY FirstName, LastName

		SELECT @ResultsCount = COUNT(*) FROM @returnData

		IF (@ResultsCount<100 AND @IsIdSearch = 0) 
		BEGIN
		INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
		SELECT TOP 100 SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip , DimCustomerId,CASE WHEN SourceSystem = 'TM' THEN SUBSTRING(ssid,1,CHARINDEX(':',ssid,1)-1) ELSE SSID END
		FROM dbo.dimcustomer --[dbo].[DimCustomer]
		WHERE emailprimary LIKE @SearchCriteria + '%'
		ORDER BY FirstName, LastName
		END 
	

	

	END

	END

	IF (LEN(@SearchCriteria) > 0 AND @searchpart2 IS NOT NULL AND @IsIdSearch = 0)
	begin
	
	
	-- Main query - insert results into the @returnData variable
	INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
	SELECT TOP 100 SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip , DimCustomerId,case when SourceSystem = 'TM' then SUBSTRING(ssid,1,CHARINDEX(':',ssid,1)-1) else SSID end
		FROM dbo.dimcustomer --[dbo].[DimCustomer]
		WHERE (FirstName LIKE @SearchPart1 + '%' AND lastname LIKE @searchpart2 + '%') --OR emailprimary LIKE @Searchpart1 + '%'
		ORDER BY FirstName, LastName
		
		

	end


	IF (@IsIdSearch = 1)
	BEGIN
	INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
	SELECT TOP 100 SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip , DimCustomerId,case when SourceSystem = 'TM' then SUBSTRING(ssid,1,CHARINDEX(':',ssid,1)-1) else SSID end
		FROM dbo.dimcustomer dc --[dbo].[DimCustomer]
		WHERE dc.SSID LIKE @SearchCriteria+'%'  
		ORDER BY CASE WHEN  case when sourcesystem = 'TM' then SUBSTRING(ssid,1,CHARINDEX(':',ssid,1)-1) else SSID end = @searchcriteria THEN 1 ELSE 0 END DESC,FirstName, LastName

		SELECT @ResultsCount = COUNT(*)
		FROM @returnData

		IF (@ResultsCount < 100) 
		BEGIN 
			INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
				SELECT TOP 100 dc.SourceSystem, dc.FirstName, dc.MiddleName, dc.LastName, dc.AddressPrimaryStreet, dc.AddressPrimaryCity, dc.AddressPrimaryState,dc.AddressPrimaryZip , dc.DimCustomerId,case when dc.SourceSystem = 'TM' then SUBSTRING(dc.ssid,1,CHARINDEX(':',dc.ssid,1)-1) else dc.SSID end
				FROM dbo.dimcustomer dc JOIN [dbo].[DimCustomerSSBID] ds ON dc.DimCustomerId = ds.DimCustomerId
				WHERE ds.SSB_CRMSYSTEM_CONTACT_ID like @SearchCriteria+'%'
				ORDER BY dc.FirstName,dc.LastName

		end

		IF (@ResultsCount < 100) 
		BEGIN 
			INSERT INTO @returnData (SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,DimCustomerId,SSID)
				SELECT TOP 100 dc.SourceSystem, dc.FirstName, dc.MiddleName, dc.LastName, dc.AddressPrimaryStreet, dc.AddressPrimaryCity, dc.AddressPrimaryState,dc.AddressPrimaryZip , dc.DimCustomerId,CASE WHEN dc.SourceSystem = 'TM' THEN SUBSTRING(dc.ssid,1,CHARINDEX(':',dc.ssid,1)-1) ELSE dc.SSID END
				FROM dbo.dimcustomer dc JOIN [dbo].[DimCustomerSSBID] ds ON dc.DimCustomerId = ds.DimCustomerId
				WHERE ds.SSB_CRMSYSTEM_ACCT_ID LIKE @SearchCriteria+'%'
				ORDER BY dc.FirstName,dc.LastName

		END

	

	END
		

	-- Set total count
	SELECT @totalCount = COUNT(*) FROM @returnData

	-- Format data for output
	SET @xmlDataNode = (
		SELECT SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,[DimCustomerId],SSID
			FROM @returnData
			--ORDER BY FirstName, LastName
			FOR XML PATH ('Customer'), ROOT ('Customers'))
	
	-- Track the root node name
	SET @rootNodeName = 'Customers'
	
	-- Create response info node
	SET @responseInfoNode = ('<ResponseInfo>'
		+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
		+ '<RemainingCount>0</RemainingCount>'  -- No paging = remaining count = 0
		+ '<RecordsInResponse>' + CAST(@totalCount AS NVARCHAR(20)) + '</RecordsInResponse>'  -- No paging = remaining count = total count
		+ '<PagedResponse>false</PagedResponse>'
		+ '<RowsPerPage />'
		+ '<PageNumber />'
		+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
		+ '</ResponseInfo>')

		
	-- Wrap response info and data, then return	
	IF @xmlDataNode IS NULL
	BEGIN
		SET @xmlDataNode = '<' + @rootNodeName + ' />'  -- Handle if no data
	END		
	SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'
	SELECT CAST(@finalXml AS XML)

END

GO
