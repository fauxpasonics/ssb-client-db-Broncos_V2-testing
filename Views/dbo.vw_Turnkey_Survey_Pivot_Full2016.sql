SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_Turnkey_Survey_Pivot_Full2016] 
AS
SELECT dc.SSID, a.* FROM (SELECT  
 RecordID
, 'Response' Response
, SurveyName
,Q12      AS 'How SATISFIED are you with your overall experience as a %[152]Q4LBL%?'
,Q120     AS  'Please tell us why you selected "%[15]Q12LBL%" in the previous question. (Optional)'
,Q121     AS  'To what extent does being a %[2]Q2LBL% %[152]Q4LBL% meet your EXPECTATIONS?'
,Q122     AS  'How likely are you to renew your season tickets for next season?'
,Q123     AS  'Please tell us why you selected "%[18]Q122LBL%" in the previous question. (Optional)'
,Q126     AS  'Please tell us what one thing the %[2]Q2LBL% do that makes you feel most valued as a%[152]Q4LBL%. (Optional)'
,Q132_A_1 AS  'How often do you engage with the&nbsp;%[2]Q2LBL% in the following ways during the season?  Visit team’s social media pages'
,Q132_A_2 AS 'How often do you engage with the&nbsp;%[2]Q2LBL% in the following ways during the season? Customer Service'
,Q132_A_3 AS 'How often do you engage with the&nbsp;%[2]Q2LBL% in the following ways during the season? Team Website'
,Q132_A_4 AS 'How often do you engage with the&nbsp;%[2]Q2LBL% in the following ways during the season?  Mobile App'
,Q134     AS 'How, if at all, would you prefer the %[2]Q2LBL% engage Season Ticket Members like yourself in the offseason? (Optional)'
,Q156     AS 'WAVE'
,Q157     AS 'STADIUM'
,Q159     AS 'Please tell us one thing that can be done to improve your customer service experience with the %[2]Q2LBL%. (Optional)'
,Q160_1   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)1'
,Q160_2   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)2'
,Q160_3   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)3'
,Q160_4   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)4'
,Q160_5   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)5'
,Q160_6   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)6'
,Q160_7   AS ' On which platforms do you follow the %[2]Q2LBL%? (Please select all that apply)7'
,Q171_A_1 AS ' To what extent do each of the following benefits make you feel valued?  Special Events for Season Ticket Members  '
,Q171_A_2 AS ' To what extent do each of the following benefits make you feel valued?  Season Ticket Member Gifts '
,Q171_A_3 AS ' To what extent do each of the following benefits make you feel valued?  Team Communication '
,Q171_A_4 AS ' To what extent do each of the following benefits make you feel valued?  Personalized Communication from Service Represetatives '
,Q171_A_5 AS ' To what extent do each of the following benefits make you feel valued?  Discounts on Merchandise '
,Q171_A_6 AS ' To what extent do each of the following benefits make you feel valued?  Seat Upgrades '
,Q171_A_7 AS ' To what extent do each of the following benefits make you feel valued?  Customer Service '
,Q171_A_8 AS ' To what extent do each of the following benefits make you feel valued?  Loyalty Program '
,Q172_A_1 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Win/Loss Record '
,Q172_A_2 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Playoff Chances '
,Q172_A_3 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Player Performance '
,Q172_A_4 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Improvement in Team Performance '
,Q172_A_5 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Coaching Staff '
,Q172_A_6 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Players Aquired by Team '
,Q172_A_7 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Confidence in Owners and Executives '
,Q172_A_8 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Visibility of Team Beyond Gameday '
,Q172_A_9 AS ' Thinking about the direction the team is heading, rate your satisfaction regarding Team Involvement in Community '
,Q173_A_1 AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Playoff Chances '
,Q173_A_2 AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Player Performance '
,Q173_A_3 AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Notable Past Teams '
,Q173_A_4 AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Specific Past Players '
,Q173_A_5 AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Percetion of the Team '
,Q173_A_6 AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Fan Traditions '
,Q175_1   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 1'
,Q175_2   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 2'
,Q175_3   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 3'
,Q175_4   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 4'
,Q175_5   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 5'
,Q175_6   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 6'
,Q175_7   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 7'
,Q175_8   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 8'
,Q175_9   AS ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel? 9'
,Q176_A_1 AS   ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Direction of Team '
,Q176_A_2 AS   ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Sense that You are Valued '
,Q176_A_3 AS   ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Customer Service '
,Q176_A_4 AS   ' As a fan of the %[2]Q2LBL%, how do each of the following make you feel?  Frequent Communications '
,Q177	  AS   ' ticket type wording '
,Q183	  AS   ' Year '
,Q2		  AS   ' Team '
,Q3_1	  AS   ' OID  '
,Q3_10	  AS   ' Seat Number '
,Q3_11	  AS   ' Seat Section '
,Q3_12	  AS   ' Customer Key '
,Q3_2	  AS   ' First Name '
,Q3_3	  AS   ' Last Name '
,Q3_4	  AS   ' Email '
,Q3_5	  AS   ' Ticket Type '
,Q3_6	  AS   ' Account ID '
,Q3_7	  AS   ' Tenure '
,Q3_8	  AS   ' Section Number '
,Q3_9	  AS   ' Row Number '
,Q36	  AS   ' Are You...? '
,Q37	  AS   ' Age '
,Q38_1	  AS   ' Do you have any children under the age of 18 currently living in your household? (Please select all that apply)1 '
,Q38_2	  AS   ' Do you have any children under the age of 18 currently living in your household? (Please select all that apply)2 '
,Q38_3	  AS   ' Do you have any children under the age of 18 currently living in your household? (Please select all that apply)3 '
,Q38_4	  AS   ' Do you have any children under the age of 18 currently living in your household? (Please select all that apply)4 '
,Q38_5	  AS   ' Do you have any children under the age of 18 currently living in your household? (Please select all that apply)5 '
,Q38_6	  AS   ' Do you have any children under the age of 18 currently living in your household? (Please select all that apply)6 '
,Q4		  AS   ' Which type of 2016 %[2]Q2LBL% Ticket Member best describes you? '
,Q41	  AS   ' Annual Household Income Before Taxes '
,Q42_1	  AS   ' ZIP Code '
,Q52_1	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?1'
,Q52_10	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?2'
,Q52_11	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?3'
,Q52_12	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?4'
,Q52_13	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?5'
,Q52_14	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?6'
,Q52_15	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?7'
,Q52_16	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?8'
,Q52_17	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?9'
,Q52_2	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?10'
,Q52_3	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?11'
,Q52_4	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?12'
,Q52_5	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?13'
,Q52_6	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?14'
,Q52_7	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?15'
,Q52_8	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?16'
,Q52_9	  AS   ' Aside from on-field performance, what are the reasons you may not renew your season ticket plan for next season?17'
,Q53_A_1  AS   ' How SATISFIED are you with the following aspects? Affordability/Cost of attending a game '
,Q53_A_2  AS   ' How SATISFIED are you with the following aspects? Playoff Ticket Priority '
,Q53_A_3  AS   ' How SATISFIED are you with the following aspects? Exclusive perks, benefits, and events '
,Q53_A_4  AS   ' How SATISFIED are you with the following aspects? Flexible payment options '
,Q53_A_5  AS   ' How SATISFIED are you with the following aspects? Season ticket discount '
,Q53_A_6  AS   ' How SATISFIED are you with the following aspects? Sense that you are valued '
,Q53_A_7  AS   ' How SATISFIED are you with the following aspects? Value meets or exceeds price paid '
,Q53_A_8  AS   ' How SATISFIED are you with the following aspects? Overall gameday experience '
,Q53_A_9  AS   ' How SATISFIED are you with the following aspects? Prestige of being a CLub Seat Member '
,Q54_A_1  AS   ' How SATISFIED are you with the following aspects? Team is headed in the right direction '
,Q54_A_10 AS   ' How SATISFIED are you with the following aspects? Exclusive concession locations '
,Q54_A_2  AS   ' How SATISFIED are you with the following aspects? Team"s win/loss record '
,Q54_A_3  AS   ' How SATISFIED are you with the following aspects? Location of your seats '
,Q54_A_4  AS   ' How SATISFIED are you with the following aspects? Seat relocation process '
,Q54_A_5  AS   ' How SATISFIED are you with the following aspects? Ability to use tickets when not attending game '
,Q54_A_6  AS   ' How SATISFIED are you with the following aspects? Frequent communications '
,Q54_A_7  AS   ' How SATISFIED are you with the following aspects? Ability to entertain for business purposes '
,Q54_A_8  AS   ' How SATISFIED are you with the following aspects? Ability to watch game from a comfortable location '
,Q54_A_9  AS   ' How SATISFIED are you with the following aspects? Access to premium parking '
,Q55	  AS   ' Something we can do to make you feel more valued '
,Q63	  AS   ' Who would you contact with a question? '
,Q65_A_1  AS   ' Thinking of the ticketing account servicing team or representative, how would you rate the…  Responsiveness  '
,Q65_A_2  AS   ' Thinking of the ticketing account servicing team or representative, how would you rate the…  Communication skills  '
,Q65_A_3  AS   ' Thinking of the ticketing account servicing team or representative, how would you rate the…  Ability to resolve issues  '
,Q65_A_4  AS   ' Thinking of the ticketing account servicing team or representative, how would you rate the…  Personalized service  '
,Q65_A_5  AS   ' Thinking of the ticketing account servicing team or representative, how would you rate the…  Professionalism  '
,Q65_A_6  AS   ' Thinking of the ticketing account servicing team or representative, how would you rate the…  Overall customer Experience  '
,Q7		  AS   ' Including games you’ve already attended, how many regular season home games do you personally plan to attend this season? '
,Q76_1	  AS   ' Do you consider yourself to be…? (Please select all that apply)1 '
,Q76_2	  AS   ' Do you consider yourself to be…? (Please select all that apply)2 '
,Q76_3	  AS   ' Do you consider yourself to be…? (Please select all that apply)3 '
,Q76_4	  AS   ' Do you consider yourself to be…? (Please select all that apply)4 '
,Q76_5	  AS   ' Do you consider yourself to be…? (Please select all that apply)5 '
,Q76_6	  AS   ' Do you consider yourself to be…? (Please select all that apply)6 '
,Q76_7	  AS   ' Do you consider yourself to be…? (Please select all that apply)7 '
,Q80	  AS   ' Please provide any additional feedback to help us improve your gameday and&nbsp;%[152]Q4LBL% experience. (Optional) '
,Q83	  AS   ' May we follow up with you in order to continue to provide you a high level of fan satisfaction? '
FROM
(SELECT RecordID, Response, KeyId, SurveyName
    FROM ods.TurnkeySurveyOutput with (nolock)
	where SurveyName like '2016 Denver Broncos VOF Ticket Member Survey') AS SourceTable
PIVOT
(
max(Response)
FOR Keyid IN (
Q12
,Q120
,Q121
,Q122
,Q123
,Q126
,Q132_A_1
,Q132_A_2
,Q132_A_3
,Q132_A_4
,Q134
,Q156
,Q157
,Q159
,Q160_1
,Q160_2
,Q160_3
,Q160_4
,Q160_5
,Q160_6
,Q160_7
,Q171_A_1
,Q171_A_2
,Q171_A_3
,Q171_A_4
,Q171_A_5
,Q171_A_6
,Q171_A_7
,Q171_A_8
,Q172_A_1
,Q172_A_2
,Q172_A_3
,Q172_A_4
,Q172_A_5
,Q172_A_6
,Q172_A_7
,Q172_A_8
,Q172_A_9
,Q173_A_1
,Q173_A_2
,Q173_A_3
,Q173_A_4
,Q173_A_5
,Q173_A_6
,Q175_1
,Q175_2
,Q175_3
,Q175_4
,Q175_5
,Q175_6
,Q175_7
,Q175_8
,Q175_9
,Q176_A_1
,Q176_A_2
,Q176_A_3
,Q176_A_4
,Q177
,Q183
,Q2
,Q3_1
,Q3_10
,Q3_11
,Q3_12
,Q3_2
,Q3_3
,Q3_4
,Q3_5
,Q3_6
,Q3_7
,Q3_8
,Q3_9
,Q36
,Q37
,Q38_1
,Q38_2
,Q38_3
,Q38_4
,Q38_5
,Q38_6
,Q4
,Q41
,Q42_1
,Q52_1
,Q52_10
,Q52_11
,Q52_12
,Q52_13
,Q52_14
,Q52_15
,Q52_16
,Q52_17
,Q52_2
,Q52_3
,Q52_4
,Q52_5
,Q52_6
,Q52_7
,Q52_8
,Q52_9
,Q53_A_1
,Q53_A_2
,Q53_A_3
,Q53_A_4
,Q53_A_5
,Q53_A_6
,Q53_A_7
,Q53_A_8
,Q53_A_9
,Q54_A_1
,Q54_A_10
,Q54_A_2
,Q54_A_3
,Q54_A_4
,Q54_A_5
,Q54_A_6
,Q54_A_7
,Q54_A_8
,Q54_A_9
,Q55
,Q63
,Q65_A_1
,Q65_A_2
,Q65_A_3
,Q65_A_4
,Q65_A_5
,Q65_A_6
,Q7
,Q76_1
,Q76_2
,Q76_3
,Q76_4
,Q76_5
,Q76_6
,Q76_7
,Q80
,Q83 )
) AS PivotTable

)a
LEFT JOIN dbo.DimCustomer dc on
a.[ Customer Key ] = dc.EmailPrimary AND a.[ First Name ] = dc.FirstName AND a.[ Last Name ] = dc.LastName

GO
