CREATE TABLE [etl].[AUDIT_TM_Ticket_DeletedDuplicateSeats]
(
[ETL__ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[id] [bigint] NOT NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[num_seats] [int] NULL,
[ticket_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [bigint] NULL,
[upd_datetime] [datetime] NULL,
[block_purchase_price] [decimal] (18, 6) NULL,
[order_num] [bigint] NULL,
[order_line_item] [bigint] NULL,
[order_line_item_seq] [int] NULL,
[info] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_events] [int] NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pricing_method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp_code] [int] NULL,
[comp_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Paid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disc_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disc_amount] [decimal] (18, 6) NULL,
[surchg_amount] [decimal] (18, 6) NULL,
[group_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[class_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sell_location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[full_price] [decimal] (18, 6) NULL,
[purchase_price] [decimal] (18, 6) NULL,
[sales_source_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_source_date] [datetime] NULL,
[Ticket_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_code_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [int] NULL,
[plan_event_id] [int] NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [int] NULL,
[last_Seat] [int] NULL,
[other_info_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_6] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_7] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_8] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_9] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_10] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_Rep_id] [int] NULL,
[acct_rep_full_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tran_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_id] [int] NULL,
[row_id] [int] NULL,
[promo_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_ticket_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_qualifiers] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid_amount] [decimal] (18, 6) NULL,
[owed_amount] [decimal] (18, 6) NULL,
[add_datetime] [datetime] NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[renewal_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[return_reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[return_reason_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expanded] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_method_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_instructions] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_name_first] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_name_last] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_addr1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_addr2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_addr3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_city] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_zip_formatted] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_phone_formatted] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivered_date] [datetime] NULL,
[group_sales_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_id] [int] NULL,
[pc_ticket] [decimal] (18, 6) NULL,
[pc_tax] [decimal] (18, 6) NULL,
[pc_licfee] [decimal] (18, 6) NULL,
[pc_other1] [decimal] (18, 6) NULL,
[pc_other2] [decimal] (18, 6) NULL,
[pc_other3] [decimal] (18, 6) NULL,
[pc_other4] [decimal] (18, 6) NULL,
[pc_other5] [decimal] (18, 6) NULL,
[pc_other6] [decimal] (18, 6) NULL,
[pc_other7] [decimal] (18, 6) NULL,
[pc_other8] [decimal] (18, 6) NULL,
[tax_rate_a] [decimal] (18, 6) NULL,
[tax_rate_b] [decimal] (18, 6) NULL,
[tax_rate_c] [decimal] (18, 6) NULL,
[orig_acct_rep_id] [int] NULL,
[ticket_seq_id] [int] NULL,
[surchg_code_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_system_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_acct_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_acct_add_date] [date] NULL,
[retail_mask] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_price_level] [int] NULL,
[retail_face_value] [decimal] (18, 6) NULL,
[retail_face_value_tax] [decimal] (18, 6) NULL,
[retail_facility_fee] [decimal] (18, 6) NULL,
[retail_service_charge] [decimal] (18, 6) NULL,
[retail_service_charge_tax] [decimal] (18, 6) NULL,
[retail_distance_charge] [decimal] (18, 6) NULL,
[return_datetime] [datetime] NULL,
[ticket_type_Category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contract_id] [int] NULL,
[surchg_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [etl].[AUDIT_TM_Ticket_DeletedDuplicateSeats] ADD CONSTRAINT [PK__AUDIT_TM__C4EA24455C9E7B05] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
