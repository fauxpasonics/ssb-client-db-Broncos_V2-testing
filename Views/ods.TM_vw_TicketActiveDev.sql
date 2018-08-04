SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[TM_vw_TicketActiveDev] AS (

SELECT tkt.*, 'tkt' SourceTable
FROM ods.tm_tkt (NOLOCK) tkt
WHERE tkt.ticket_status <> 'R'

UNION ALL

SELECT plans.*, 'plan' SourceTable
FROM ods.tm_plans (NOLOCK) plans 
LEFT OUTER JOIN ods.tm_tkt (NOLOCK) tkt
	ON plans.acct_id = tkt.acct_id 
	AND plans.ticket_status = tkt.ticket_status
	AND plans.plan_event_id = tkt.plan_event_id
	AND plans.section_id = tkt.section_id
	AND plans.row_id = tkt.row_id
	AND plans.seat_num = tkt.seat_num
	--AND plans.num_seats = tkt.num_seats
WHERE tkt.id IS NULL AND plans.ticket_status <> 'R'

)

GO
