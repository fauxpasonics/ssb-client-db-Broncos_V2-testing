SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [segmentation].[vw__Eloqua_Email_Groups_Custom]
AS
    SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
          , eqc.EmailAddress AS G_EmailAddress
          , CAST(eqc.IsBounceback AS BIT) AS G_IsBounceback
          , CAST(eqc.IsSubscribed  AS BIT) AS G_IsSubscribed
          , SUM(CASE WHEN grp.EmailGroup = 'BroncosPromos' THEN 1
                     ELSE 0
                END) AS BroncosPromos
          , SUM(CASE WHEN grp.EmailGroup = 'ICYMI' THEN 1
                     ELSE 0
                END) AS ICYMI
          , SUM(CASE WHEN grp.EmailGroup = 'OrangeHerd' THEN 1
                     ELSE 0
                END) AS OrangeHerd
          , SUM(CASE WHEN grp.EmailGroup = 'OrangeJuice' THEN 1
                     ELSE 0
                END) AS OrangeJuice
          , SUM(CASE WHEN grp.EmailGroup = 'Outlaws' THEN 1
                     ELSE 0
                END) AS Outlaws
          , SUM(CASE WHEN grp.EmailGroup = 'Stadium' THEN 1
                     ELSE 0
                END) AS Stadium
          , SUM(CASE WHEN grp.EmailGroup = 'SurveyPanel' THEN 1
                     ELSE 0
                END) AS SurveyPanel
          ,CASE WHEN NOT crush.EmailAddress IS NULL THEN 1 ELSE 0 END CrushMember
		  ,CASE WHEN NOT safield.Email_Address1 IS NULL THEN 1 ELSE 0 END SAField
		  ,CASE WHEN NOT fanatics.Client_Email IS NULL THEN 1 ELSE 0 END Fanatics
		  ,CASE WHEN NOT bunch.Parents_Email_Address1 IS NULL THEN 1 ELSE 0 END Bunch
		  --COUNT(DISTINCT crush.Email_Address1) AS CrushMember
    --      , COUNT(DISTINCT safield.Email_Address1) AS SAField
    --      , COUNT(DISTINCT fanatics.Client_Email) AS Fanatics
		  , safield.PRIMARY_ACT1
		  , safield._MAJOR_CAT_NAME1	
    FROM    ods.Eloqua_Contact eqc WITH (NOLOCK)
    LEFT JOIN dbo.dimcustomerssbid ssbid  WITH (NOLOCK) ON CAST(eqc.Id AS VARCHAR(200))=ssbid.SSID
    LEFT JOIN ods.EloquaCustom_EmailGroupMembers grp  WITH (NOLOCK) ON eqc.EmailAddress = grp.EmailAddress
    LEFT JOIN ods.EloquaCustom_CrushMembers crush  WITH (NOLOCK) ON eqc.EmailAddress=crush.EmailAddress
    LEFT JOIN ods.EloquaCustom_CustomerDatasportsAuthorityField safield  WITH (NOLOCK) ON eqc.EmailAddress=safield.Email_Address1
    LEFT JOIN ods.Fanatics_Orders fanatics WITH (NOLOCK) ON eqc.EmailAddress=fanatics.Client_Email
	LEFT JOIN [ods].[EloquaCustom_BroncosBunchMasterList] Bunch WITH (NOLOCK) ON eqc.EmailAddress= bunch.Parents_Email_Address1 AND status1 = 'Active'
    GROUP BY  CAST(eqc.IsBounceback AS BIT)
            , CAST(eqc.IsSubscribed AS BIT)
            , ssbid.SSB_CRMSYSTEM_CONTACT_ID
            , eqc.EmailAddress
            , safield.PRIMARY_ACT1
            , safield._MAJOR_CAT_NAME1
			,crush.EmailAddress
			,safield.Email_Address1
			,fanatics.Client_Email
			,bunch.Parents_Email_Address1


GO
