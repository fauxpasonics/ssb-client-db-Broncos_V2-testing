SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create View [dbo].[vw_TurnkeySurveyPivot_2016] as
Select Q3_8 SectionName, Q3_9 RowName, cast(right(Q3_10, 2) as int) Seat , Q3_7 Tenure, Q4 Ticket_Type, Q41 Household_Income, Q140 Entry_Gate, left(Q21_A_5, 2) Staff, left(Q22_A_6, 2) In_Game_Enahancements, left(Q23_A_13,2) Game_Entertainment, left(Q25_A_9,2) Food, Q8 Game, left(Q183, 4) Season
from TurnkeySurveyPivot_2016
where Q3_10 not like'%U%' and Q3_10 <> ''
GO
