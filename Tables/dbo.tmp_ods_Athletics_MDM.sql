CREATE TABLE [dbo].[tmp_ods_Athletics_MDM]
(
[ssb_crmsystem_contact_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sourcesystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prefix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middlename] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fullname] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[companyname] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarysuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarycity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystate] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarycountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryUpdate] [datetime] NULL,
[phoneprimary] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhonePrimaryUpdate] [datetime] NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emailprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPrimaryUpdate] [datetime] NULL,
[updateddate] [datetime] NULL,
[createddate] [datetime] NULL,
[ssupdateddate] [datetime] NULL,
[sscreateddate] [datetime] NULL,
[dimcustomerid] [int] NOT NULL,
[customerstatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customertype] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastpurchase] [datetime] NULL,
[isdeleted] [bit] NULL,
[ETL_ID] [bigint] NOT NULL IDENTITY(1, 1),
[etl_deltahashkey] [varbinary] (max) NULL,
[etl_createddate] [datetime] NOT NULL CONSTRAINT [DF_ods_Athletics_MDM_etl_createddate] DEFAULT (getdate()),
[etl_updateddate] [datetime] NOT NULL CONSTRAINT [DF_ods_Athletics_MDM_etl_updateddate] DEFAULT (getdate())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATe Trigger [dbo].[addressprimarycityupdate] on [dbo].[tmp_ods_Athletics_MDM]
For Update As

If UPDATE (addressprimarycity)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE addressprimarycity IN (select Distinct addressprimarycity from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimarycityupdate] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[addressprimarystreetupdate] on [dbo].[tmp_ods_Athletics_MDM]
For Update As

If UPDATE (addressprimarystreet)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE addressprimarystreet IN (select Distinct addressprimarystreet from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimarystreetupdate] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[addressprimarysuiteupdate] on [dbo].[tmp_ods_Athletics_MDM]
For Update As

If UPDATE (addressprimarysuite)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE addressprimarysuite IN (select Distinct addressprimarysuite from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimarysuiteupdate] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[addressprimaryzipupdate] on [dbo].[tmp_ods_Athletics_MDM]
For Update As

If UPDATE (addressprimaryzip)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE AddressPrimaryZip IN (select Distinct AddressPrimaryZip from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimaryzipupdate] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[emailprimaryupdate] on [dbo].[tmp_ods_Athletics_MDM]
For Update As

If UPDATE (emailprimary)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set EmailPrimaryUpdate = getdate()
							   WHERE EmailPrimary IN (select Distinct EmailPrimary from inserted)
           END

GO
DISABLE TRIGGER [dbo].[emailprimaryupdate] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Trigger [dbo].[ods_athletics_mdm_updateAddress]
ON [dbo].[tmp_ods_Athletics_MDM]
AFTER UPDATE
AS BEGIN
	SET NOCOUNT ON
	UPDATE a SET AddressPrimaryUpdate = GETDATE()
		FROM dbo.tmp_ods_Athletics_MDM a
		WHERE EXISTS (SELECT 1 FROM inserted i WHERE i.ssb_crmsystem_contact_id = a.ssb_crmsystem_contact_id AND i.AddressPrimaryStreet <> a.AddressPrimarySuite)
	End
	 
GO
DISABLE TRIGGER [dbo].[ods_athletics_mdm_updateAddress] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Trigger [dbo].[ods_athletics_mdm_updateEmail]
ON [dbo].[tmp_ods_Athletics_MDM]
AFTER UPDATE
AS BEGIN
	SET NOCOUNT ON
	UPDATE a SET EmailPrimaryUpdate = GETDATE()
		FROM dbo.tmp_ods_Athletics_MDM a
		WHERE EXISTS (SELECT 1 FROM inserted i WHERE i.ssb_crmsystem_contact_id = a.ssb_crmsystem_contact_id AND i.EmailPrimary <> a.EmailPrimary)
	End
GO
DISABLE TRIGGER [dbo].[ods_athletics_mdm_updateEmail] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[ods_athletics_mdm_updatePhone]
ON [dbo].[tmp_ods_Athletics_MDM]
AFTER UPDATE
AS BEGIN
	SET NOCOUNT ON
	UPDATE a SET PhonePrimaryUpdate = GETDATE()
		FROM dbo.tmp_ods_Athletics_MDM a
		WHERE EXISTS (SELECT 1 FROM inserted i WHERE i.ssb_crmsystem_contact_id = a.ssb_crmsystem_contact_id AND i.PhonePrimary <> a.phoneprimary)
	End
GO
DISABLE TRIGGER [dbo].[ods_athletics_mdm_updatePhone] ON [dbo].[tmp_ods_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[phoneprimaryupdate] on [dbo].[tmp_ods_Athletics_MDM]
For Update As

If UPDATE (PhonePrimary)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set PhonePrimaryUpdate = getdate()
							   WHERE phoneprimary IN (select Distinct phoneprimary from inserted)
           END
GO
DISABLE TRIGGER [dbo].[phoneprimaryupdate] ON [dbo].[tmp_ods_Athletics_MDM]
GO
ALTER TABLE [dbo].[tmp_ods_Athletics_MDM] ADD CONSTRAINT [PK_ods_Athletics_MDM] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IX_ods_Athletics_MDM_Dimcustomer] ON [dbo].[tmp_ods_Athletics_MDM] ([dimcustomerid])
GO
