SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[TM_vw_MergedAccountLog] 
as 
(
	SELECT tn.add_datetime
	, (SELECT MergedAccount FROM [Master].dbo.GetMergedAccountFromNoteText(tn.text)) AS MergedAccount
	, (SELECT MergedAccountWinner FROM [Master].dbo.GetMergedAccountFromNoteTextWinner(tn.text)) AS MergedAccountWinner
	FROM ods.TM_Note tn
	WHERE tn.text like 'Merged account %'	
)

GO
