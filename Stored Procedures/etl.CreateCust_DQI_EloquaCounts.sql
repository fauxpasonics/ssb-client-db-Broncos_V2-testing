SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [etl].[CreateCust_DQI_EloquaCounts] AS
    DECLARE @DateOffset INT = (
                                SELECT  UTCOffset
                                FROM    dbo.DimDate
                                WHERE   CalDate = CAST(GETDATE() AS DATE)
                              );

-- ===================e======================
-- Creating BaseSet of Distinct Email Addresses with most recent CreatedAt and EloquaID
-- =========================================

--DROP TABLE #BaseSet
--DROP TABLE #Seasons
--DROP TABLE #stage

DELETE FROM rpt.Cust_DQI_EloquaCounts

	select emailaddress, createdat,Id, C_Season_Ticket_Account_Number1
	INTO   #BaseSet_a
    FROM    ods.Eloqua_Contact WITH ( NOLOCK )
    

	
	select  EmailAddress
          , MAX(CreatedAt) AS CreatedAt
          , MAX(ID) AS ID
          , MAX(C_Season_Ticket_Account_Number1) AS AcctId
	INTO   #BaseSet
    FROM    #BaseSet_a WITH ( NOLOCK )
    GROUP BY EmailAddress;


	drop table #baseset_a


CREATE TABLE #seasons ( AcctId VARCHAR(200) );

--IF ( @ReportType = 'Season' )
--BEGIN
INSERT  #seasons
SELECT  dc.AccountId
FROM    rpt.vw_FactTicketSales f WITH ( NOLOCK )
INNER JOIN dbo.DimCustomer dc WITH ( NOLOCK ) ON f.DimCustomerId = dc.DimCustomerId
--INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON dc.DimCustomerId = ssbid.DimCustomerId
INNER JOIN rpt.vw_DimPlan dpl WITH ( NOLOCK ) ON f.DimPlanId = dpl.DimPlanId
WHERE   f.DimSeasonId IN ( 50 )
        AND dpl.PlanClass = 'FS'
GROUP BY dc.AccountId;
--END;



/*SELECT
o.ContactId, o.CreatedAt
INTO #Open
FROM    ods.Eloqua_ActivityEmailOpen o WITH ( NOLOCK )*/


INSERT rpt.Cust_DQI_EloquaCounts
SELECT *
--INTO  rpt.Cust_DQI_EloquaCounts
FROM
(

    SELECT  'Broncos KPI' ReportName
          , '1' ClientID
          , 'Contacts' KPIDisplayName
--, KPIID
          , DATEADD(DAY, -1, GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
          , 0 KPIExportEnable
          , 1 AS displayrownumber
          , 1 AS displaycolnumber
          , 'Past 7 Days' KpiPrevLabel
          , ISNULL(SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                           AND
                                                              CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                            THEN 1
                            ELSE 0
                       END), 0) AS KpiPrev
          , 'Past 14 Days' KpiLabel2
          , ISNULL(SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                           AND
                                                              CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                            THEN 1
                            ELSE 0
                       END), 0) AS Kpi2
          , 'Past 30 Days' KpiLabel3
          , ISNULL(SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                           AND
                                                              CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                            THEN 1
                            ELSE 0
                       END), 0) AS Kpi3
          , 'To Date' KpiLabel4
          , ISNULL(COUNT(*), 0) AS Kpi4
          , 'Past 7 Days' SeasonKpiPrevLabel
		   , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpiPrev
          , 'Past 14 Days' SeasonKpiLabel2
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi2
          , 'Past 30 Days' SeasonKpiLabel3
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi3
          , 'To Date' SeasonKpiLabel4
          , sum(case when coalesce(s.AcctId, '') <> '' then 1 else 0 end) AS SeasonKpi4
          		  , NULL KpiPrevThirty
          , 'Box' WidgetType
    FROM    #BaseSet o WITH ( NOLOCK )
    LEFT JOIN #seasons s WITH ( NOLOCK ) ON o.AcctId = s.AcctId
   /* WHERE   (
             not coalesce(s.AcctId, @ReportType) = 'Season'
             -- OR @ReportType = 'All'
            )*/

    UNION

	-- =========================================
	-- Opens
	-- =========================================

    SELECT  'Broncos KPI' ReportName
          , '1' ClientID
          , 'Opens' KPIDisplayName
--, KPIID
          , DATEADD(DAY, -1, GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
          , 0 KPIExportEnable
          , 1 AS displayrownumber
          , 2 AS displaycolnumber
          , 'Past 7 Days' KpiPrevLabel
          , ISNULL(SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                           AND
                                                              CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                            THEN 1
                            ELSE 0
                       END), 0) AS KpiPrev
          , 'Past 14 Days' KpiLabel2
          , ISNULL(SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                           AND
                                                              CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                            THEN 1
                            ELSE 0
                       END), 0) AS Kpi2
          , 'Past 30 Days' KpiLabel3
          , ISNULL(SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                           AND
                                                              CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                            THEN 1
                            ELSE 0
                       END), 0) AS Kpi3
          , 'To Date' KpiLabel4
          , ISNULL(COUNT(*), 0) AS Kpi4
          , 'Past 7 Days' SeasonKpiPrevLabel
		   , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpiPrev
          , 'Past 14 Days' SeasonKpiLabel2
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi2
          , 'Past 30 Days' SeasonKpiLabel3
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi3
          , 'To Date' SeasonKpiLabel4
          , sum(case when coalesce(s.AcctId, '') <> '' then 1 else 0 end) AS SeasonKpi4
            , NULL KpiPrevThirty
          , 'Box' WidgetType
    
	FROM ods.Eloqua_ActivityEmailOpen o WITH ( NOLOCK )
    JOIN   #BaseSet b WITH ( NOLOCK ) ON o.ContactId = b.ID
    LEFT JOIN #seasons s WITH ( NOLOCK ) ON b.AcctId = s.AcctId
    /*WHERE   (
              not coalesce(s.AcctId, @ReportType) = 'Season'
             -- OR @ReportType = 'All'
            )*/
    UNION

	-- =========================================
	-- Clickthrough
	-- =========================================

    SELECT  'Broncos KPI' ReportName
          , '1' ClientID
          , 'Click Through' KPIDisplayName
--, KPIID
          , DATEADD(DAY, -1, GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
          , 0 KPIExportEnable
          , 1 AS displayrownumber
          , 3 AS displaycolnumber
          , 'Past 7 Days' KpiPrevLabel
          , SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS KpiPrev
          , 'Past 14 Days' KpiLabel2
          , SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS Kpi2
          , 'Past 30 Days' KpiLabel3
          , SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS Kpi3
          , 'To Date' KpiLabel4
          , COUNT(*) AS Kpi4
		  , 'Past 7 Days' SeasonKpiPrevLabel
		   , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpiPrev
          , 'Past 14 Days' SeasonKpiLabel2
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi2
          , 'Past 30 Days' SeasonKpiLabel3
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi3
          , 'To Date' SeasonKpiLabel4
          , sum(case when coalesce(s.AcctId, '') <> '' then 1 else 0 end) AS SeasonKpi4
          , NULL KpiPrevThirty
          , 'Box' WidgetType
    FROM    ods.Eloqua_ActivityEmailClickThrough o WITH ( NOLOCK )
    JOIN    #BaseSet b WITH ( NOLOCK ) ON o.ContactId = b.ID
    LEFT JOIN #seasons s WITH ( NOLOCK ) ON b.AcctId = s.AcctId
    /*WHERE   (
              coalesce(s.AcctId, @ReportType) <> 'Season'
             -- OR @ReportType = 'All'
            )*/
    UNION

	-- =========================================
	-- Pageviews
	-- =========================================

    SELECT  'Broncos KPI' ReportName
          , '1' ClientID
          , 'Page Views' KPIDisplayName
--, KPIID
          , DATEADD(DAY, -1, GETDATE()) Date
--,[dc].[KPIValue]
--,KPIDetail_Query
          , 0 KPIExportEnable
          , 2 AS displayrownumber
          , 1 AS displaycolnumber
          , 'Past 7 Days' KpiPrevLabel
          , SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS KpiPrev
          , 'Past 14 Days' KpiLabel2
          , SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS Kpi2
          , 'Past 30 Days' KpiLabel3
          , SUM(CASE WHEN CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS Kpi3
          , 'To Date' KpiLabel4
          , COUNT(*) AS Kpi4
		  , 'Past 7 Days' SeasonKpiPrevLabel
		   , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 7 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpiPrev
          , 'Past 14 Days' SeasonKpiLabel2
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 14 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi2
          , 'Past 30 Days' SeasonKpiLabel3
          , SUM(CASE WHEN coalesce(s.AcctId, '') <> '' and CAST(o.CreatedAt AS DATE) BETWEEN CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) - 30 AS DATE)
                                                    AND     CAST(DATEADD(HOUR,
                                                              @DateOffset,
                                                              GETDATE()) AS DATE)
                     THEN 1
                     ELSE 0
                END) AS SeasonKpi3
          , 'To Date' SeasonKpiLabel4
          , sum(case when coalesce(s.AcctId, '') <> '' then 1 else 0 end) AS SeasonKpi4
          , NULL KpiPrevThirty
          , 'Box' WidgetType
    FROM    ods.Eloqua_ActivityPageView o WITH ( NOLOCK )
    JOIN    #BaseSet b WITH ( NOLOCK ) ON o.ContactId = b.ID
    LEFT JOIN #seasons s WITH ( NOLOCK ) ON b.AcctId = s.AcctId
    /*WHERE   (
              coalesce(s.AcctId, @ReportType) <> 'Season'
             -- OR @ReportType = 'All'
            )*/
    
	)a




	
GO
