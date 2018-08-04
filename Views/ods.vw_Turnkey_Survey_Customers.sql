SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ods].[vw_Turnkey_Survey_Customers]
AS

SELECT MAX(x.AccountID) AS AccountID, REPLACE(x.Email, '%40','@') AS Email, MAX(firstname) AS FirstName, MAX(lastname) AS LastName, MAX(phonenumber) AS PhoneNumber
FROM (
SELECT TRY_CAST([AccountID] AS INT) AS AccountID, MAX(p.[Email]) AS Email, MAX(p.[First Name]) AS FirstName, MAX(p.[Last Name]) AS LastName, MAX(p.[Phone Number]) AS PhoneNumber -- 28341 before group by, 13220 after group by
FROM 
	( SELECT recordid, 
	
	CASE WHEN subquestion = 'Email address:' OR subquestion = 'Email address' THEN 'Email'
		 WHEN subquestion = 'Account ID' OR subquestion = 'Account ID:' THEN 'AccountID'
		 WHEN subquestion = 'First Name:' THEN 'First Name'
		 WHEN subquestion = 'Last Name:' THEN 'Last Name'
		 WHEN SubQuestion = 'Phone Number:' THEN 'Phone Number'
		 ELSE subquestion END AS subquestion,
	response
		FROM [ods].[TurnkeySurveyOutput]
		WHERE subquestion IN ('Email address:', 'Email address', 'Email', 'Account ID', 'Account ID:', 
								'First Name:', 'First Name', 'Last Name:', 'Phone Number','Phone Number:')
		) AS source
		PIVOT
		( 
			MAX(Response) 
			FOR Subquestion IN ([AccountID], [Email], [First Name], [Last Name], [Phone Number])
		) AS p
WHERE TRY_CAST(p.[AccountID] AS INT) IS NOT null
--			AND p.Email IS NOT NULL	
GROUP BY TRY_CAST(p.[AccountID] AS INT)


UNION

SELECT MAX(TRY_CAST([AccountID] AS INT)) AS AccountID, p.Email AS Email, MAX(p.[First Name]) AS FirstName, MAX(p.[Last Name]) AS LastName, MAX(p.[Phone Number]) AS PhoneNumber -- 28341 before group by, 13220 after group by
FROM 
	( SELECT recordid, 
	
	CASE WHEN subquestion = 'Email address:' OR subquestion = 'Email address' THEN 'Email'
		 WHEN subquestion = 'Account ID' OR subquestion = 'Account ID:' THEN 'AccountID'
		 WHEN subquestion = 'First Name:' THEN 'First Name'
		 WHEN subquestion = 'Last Name:' THEN 'Last Name'
		 WHEN SubQuestion = 'Phone Number:' THEN 'Phone Number'
		 ELSE subquestion END AS subquestion,
		response
		FROM [ods].[TurnkeySurveyOutput]
		WHERE subquestion IN ('Email address:', 'Email address', 'Email', 'Account ID', 'Account ID:', 
								'First Name:', 'First Name', 'Last Name:', 'Phone Number','Phone Number:')
		) AS source
		PIVOT
		( 
			MAX(Response) 
			FOR Subquestion IN ([AccountID], [Email], [First Name], [Last Name], [Phone Number])
		) AS p
WHERE ISNULL(p.Email, '') <> ''
--			AND p.Email IS NOT NULL	
GROUP BY p.Email
) x
WHERE REPLACE(x.Email, '%40','@') IS NOT NULL
GROUP BY  REPLACE(x.Email, '%40','@') 

UNION



SELECT x.AccountID AS AccountID, MAX(REPLACE(x.Email, '%40','@')) AS Email, MAX(firstname) AS FirstName, MAX(lastname) AS LastName, MAX(phonenumber) AS PhoneNumber
FROM (
SELECT TRY_CAST([AccountID] AS INT) AS AccountID, MAX(p.[Email]) AS Email, MAX(p.[First Name]) AS FirstName, MAX(p.[Last Name]) AS LastName, MAX(p.[Phone Number]) AS PhoneNumber -- 28341 before group by, 13220 after group by
FROM 
	( SELECT recordid, 
	
	CASE WHEN subquestion = 'Email address:' OR subquestion = 'Email address' THEN 'Email'
		 WHEN subquestion = 'Account ID' OR subquestion = 'Account ID:' THEN 'AccountID'
		 WHEN subquestion = 'First Name:' THEN 'First Name'
		 WHEN subquestion = 'Last Name:' THEN 'Last Name'
		 WHEN SubQuestion = 'Phone Number:' THEN 'Phone Number'
		 ELSE subquestion END AS subquestion,
	response
		FROM [ods].[TurnkeySurveyOutput]
		WHERE subquestion IN ('Email address:', 'Email address', 'Email', 'Account ID', 'Account ID:', 
								'First Name:', 'First Name', 'Last Name:', 'Phone Number','Phone Number:')
		) AS source
		PIVOT
		( 
			MAX(Response) 
			FOR Subquestion IN ([AccountID], [Email], [First Name], [Last Name], [Phone Number])
		) AS p
WHERE TRY_CAST(p.[AccountID] AS INT) IS NOT null
--			AND p.Email IS NOT NULL	
GROUP BY TRY_CAST(p.[AccountID] AS INT)


UNION

SELECT MAX(TRY_CAST([AccountID] AS INT)) AS AccountID, p.Email AS Email, MAX(p.[First Name]) AS FirstName, MAX(p.[Last Name]) AS LastName, MAX(p.[Phone Number]) AS PhoneNumber -- 28341 before group by, 13220 after group by
FROM 
	( SELECT recordid, 
	
	CASE WHEN subquestion = 'Email address:' OR subquestion = 'Email address' THEN 'Email'
		 WHEN subquestion = 'Account ID' OR subquestion = 'Account ID:' THEN 'AccountID'
		 WHEN subquestion = 'First Name:' THEN 'First Name'
		 WHEN subquestion = 'Last Name:' THEN 'Last Name'
		 WHEN SubQuestion = 'Phone Number:' THEN 'Phone Number'
		 ELSE subquestion END AS subquestion,
		response
		FROM [ods].[TurnkeySurveyOutput]
		WHERE subquestion IN ('Email address:', 'Email address', 'Email', 'Account ID', 'Account ID:', 
								'First Name:', 'First Name', 'Last Name:', 'Phone Number','Phone Number:')
		) AS source
		PIVOT
		( 
			MAX(Response) 
			FOR Subquestion IN ([AccountID], [Email], [First Name], [Last Name], [Phone Number])
		) AS p
WHERE ISNULL(p.Email, '') <> ''
--			AND p.Email IS NOT NULL	
GROUP BY p.Email
) x
WHERE REPLACE(x.Email, '%40','@') IS NULL
GROUP BY x.AccountID 
GO
