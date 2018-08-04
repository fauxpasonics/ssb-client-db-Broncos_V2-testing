CREATE TABLE [zzz].[archive__TM_Note_bkp_700Rollout]
(
[ETL__ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NULL,
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__BatchId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__ExecutionId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reminder_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[category_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subcategory_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[response_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[response] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_type_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_status_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alert_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alert_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[icon_file_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner_user_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_owner_on_chg] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[duration] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[solicitation_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[solicitation_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[end_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[all_day_event] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_time_as] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[added_to_outlook] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_type_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assigned_to_user_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_seq_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_activity_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_result_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_status_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_result] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_assigned_to_user_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_assigned_to_dept_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_dept_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_assignee_notified] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_duration] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_start_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_end_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_probability_to_close] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_probability_to_close_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[org_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[org_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[teamname] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[export_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_subcategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_response] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [zzz].[archive__TM_Note_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Note__C4EA2445D9A7CA2B] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO