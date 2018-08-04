SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROC [rpt].[Cust_EloquaLocations] --(@ReportType VARCHAR(10) = 'All')
    WITH RECOMPILE
AS


    SELECT  CASE grouping_id(City)
              WHEN 0 THEN 'Detail'
              ELSE 'State'
            END AS RowType
          , 'Season' AS ReportType
          , StateCode
          , StateName
          , ISNULL(City, 'None Given') AS City
          , COUNT(*) RecordCount
    FROM    
	(
		SELECT  dc.AccountId AS AccountId
          , dc.AddressPrimaryCity AS City
          , dc.AddressPrimaryState AS Province
		FROM    rpt.vw_FactTicketSales f ( NOLOCK )
		INNER JOIN dbo.DimCustomer dc ( NOLOCK ) ON f.DimCustomerId = dc.DimCustomerId
		--INNER JOIN dbo.dimcustomerssbid ssbid ( NOLOCK ) ON dc.DimCustomerId = ssbid.DimCustomerId
		INNER JOIN rpt.vw_DimPlan dpl ( NOLOCK ) ON f.DimPlanId = dpl.DimPlanId
		WHERE   f.DimSeasonId = 50
				AND dpl.PlanCode LIKE '17FS%'
		GROUP BY dc.AccountId
			  , dc.AddressPrimaryCity
			  , dc.AddressPrimaryState
	) a
    JOIN    rpt.USStates b ( NOLOCK ) ON a.Province = b.StateCode
    GROUP BY GROUPING SETS((
                             StateCode
                           , StateName
                           , City
                           ),
                           (
                             StateCode
                           , b.StateName
                           ))
    UNION
    SELECT  CASE grouping_id(City)
              WHEN 0 THEN 'Detail'
              ELSE 'State'
            END AS RowType
          , 'All' AS ReportType
          , StateCode
          , StateName
          , ISNULL(City, 'None Given') AS City
          , COUNT(*) RecordCount
    FROM    
	(
		SELECT CAST(a.city AS VARCHAR(200)) city, statename , b.statecode 
		FROM  ods.Eloqua_Contact a ( NOLOCK )
		INNER JOIN rpt.usstates b ON a.province = b.statecode
	) a
    GROUP BY GROUPING SETS((
                             StateCode
                           , StateName
                           , City
                           ),
                           (
                             StateCode
                           , StateName
                           ))
    ORDER BY ReportType
          , RecordCount DESC;


GO
