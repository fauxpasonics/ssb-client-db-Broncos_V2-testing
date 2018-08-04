CREATE TABLE [dbo].[tmp_stg_Athletics_MDM]
(
[ssb_crmsystem_contact_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sourcesystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prefix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middlename] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fullname] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[companyname] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarysuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarycity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystate] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarycountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneprimary] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[updateddate] [datetime] NULL,
[createddate] [datetime] NULL,
[ssupdateddate] [datetime] NULL,
[sscreateddate] [datetime] NULL,
[dimcustomerid] [int] NOT NULL,
[customerstatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customertype] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastpurchase] [datetime] NULL,
[isdeleted] [bit] NULL,
[copyloaddate] [datetime] NULL CONSTRAINT [DF_src_Athletics_MDM_copyloaddate] DEFAULT (getdate()),
[ETL_ID] [bigint] NOT NULL IDENTITY(1, 1),
[etl_deltahashkey] [varbinary] (max) NULL,
[AddressPrimaryUpdate] [datetime] NULL,
[PhonePrimaryUpdate] [datetime] NULL,
[EmailPrimaryUpdate] [datetime] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create Trigger [dbo].[addressprimarycityupdate_stg] on [dbo].[tmp_stg_Athletics_MDM]
For Update As

If UPDATE (addressprimarycity)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE addressprimarycity IN (select Distinct addressprimarycity from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimarycityupdate_stg] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[addressprimarystreetupdate_stg] on [dbo].[tmp_stg_Athletics_MDM]
For Update As

If UPDATE (addressprimarystreet)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE addressprimarystreet IN (select Distinct addressprimarystreet from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimarystreetupdate_stg] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Trigger [dbo].[addressprimarysuiteupdate_stg] on [dbo].[tmp_stg_Athletics_MDM]
For Update As

If UPDATE (addressprimarysuite)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE addressprimarysuite IN (select Distinct addressprimarysuite from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimarysuiteupdate_stg] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[addressprimaryzipupdate_stg] on [dbo].[tmp_stg_Athletics_MDM]
For Update As

If UPDATE (addressprimaryzip)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE AddressPrimaryZip IN (select Distinct AddressPrimaryZip from inserted)
           END
GO
DISABLE TRIGGER [dbo].[addressprimaryzipupdate_stg] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[emailprimaryupdate_stg] on [dbo].[tmp_stg_Athletics_MDM]
For Update As

If UPDATE (emailprimary)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set EmailPrimaryUpdate = getdate()
							   WHERE EmailPrimary IN (select Distinct EmailPrimary from inserted)
           END

GO
DISABLE TRIGGER [dbo].[emailprimaryupdate_stg] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[phoneprimaryupdate_stg] on [dbo].[tmp_stg_Athletics_MDM]
For Update As

If UPDATE (PhonePrimary)
            BEGIN
                   UPDATE tmp_ods_Athletics_MDM
                               Set PhonePrimaryUpdate = getdate()
							   WHERE phoneprimary IN (select Distinct phoneprimary from inserted)
           END
GO
DISABLE TRIGGER [dbo].[phoneprimaryupdate_stg] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create Trigger [dbo].[stg_athletics_mdm_update_addressprimarycity]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (addressprimarycity) 
BEGIN
								UPDATE a
                               Set a.AddressPrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.addressprimarycity,'NULL VALUE') <>  ISNULL(i.addressprimarycity,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create Trigger [dbo].[stg_athletics_mdm_update_addressprimarycountry]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (addressprimarycountry) 
BEGIN
								UPDATE a
                               Set a.AddressPrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.addressprimarycountry,'NULL VALUE') <>  ISNULL(i.addressprimarycountry,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create Trigger [dbo].[stg_athletics_mdm_update_addressprimarystate]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (addressprimarystate) 
BEGIN
								UPDATE a
                               Set a.AddressPrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.addressprimarystate,'NULL VALUE') <>  ISNULL(i.addressprimarystate,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create Trigger [dbo].[stg_athletics_mdm_update_addressprimarystreet]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (addressprimarystreet) 
BEGIN
								UPDATE a
                               Set a.AddressPrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.addressprimarystreet,'NULL VALUE') <>  ISNULL(i.addressprimarystreet,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create Trigger [dbo].[stg_athletics_mdm_update_addressprimarysuite]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (addressprimarysuite) 
BEGIN
								UPDATE a
                               Set a.AddressPrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.addressprimarysuite,'NULL VALUE') <>  ISNULL(i.addressprimarysuite,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[stg_athletics_mdm_update_emailprimary]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (emailprimary) 
BEGIN
								UPDATE a
                               Set a.EmailPrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.emailprimary,'NULL VALUE') <>  ISNULL(i.emailprimary,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Trigger [dbo].[stg_athletics_mdm_update_phoneprimary]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (phoneprimary) 
BEGIN
								UPDATE a
                               Set a.PhonePrimaryUpdate = getdate()
							   FROM dbo.tmp_stg_Athletics_MDM a
							   INNER JOIN inserted AS i ON i.dimcustomerid = a.dimcustomerid
							   INNER JOIN deleted AS d ON i.dimcustomerid = d.dimcustomerid
							   WHERE a.dimcustomerid IN (select Distinct dimcustomerid from inserted)
								AND (ISNULL(d.phoneprimary,'NULL VALUE') <>  ISNULL(i.phoneprimary,'NULL VALUE') ) 
	End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[stg_athletics_mdm_updateAddress]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (addressprimarystreet) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End
	 
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateAddress] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[stg_athletics_mdm_updateAddress2]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (addressprimarysuite) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateAddress2] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[stg_athletics_mdm_updateAddress3]
ON [dbo].[tmp_stg_Athletics_MDM]
AFTER UPDATE
AS 

IF UPDATE (addressprimarycity) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE dimcustomerid IN (select Distinct dimcustomerid from inserted)
								--AND deleted.addressprimarycity <>  inserted.addressprimarycity
	End
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateAddress3] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[stg_athletics_mdm_updateAddress4]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (addressprimaryzip) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateAddress4] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Trigger [dbo].[stg_athletics_mdm_updateAddress5]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (addressprimarystate) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateAddress5] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE Trigger [dbo].[stg_athletics_mdm_updateAddress6]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (addressprimarycountry) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set AddressPrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateAddress6] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Trigger [dbo].[stg_athletics_mdm_updateEmail]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (emailprimary) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set EmailPrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End


GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updateEmail] ON [dbo].[tmp_stg_Athletics_MDM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Trigger [dbo].[stg_athletics_mdm_updatePhone]
ON [dbo].[tmp_stg_Athletics_MDM]
FOR UPDATE
AS If UPDATE (phoneprimary) 
BEGIN
                   UPDATE tmp_stg_Athletics_MDM
                               Set PhonePrimaryUpdate = getdate()
							   WHERE ssb_crmsystem_contact_id IN (select Distinct ssb_crmsystem_contact_id from inserted)
	End
GO
DISABLE TRIGGER [dbo].[stg_athletics_mdm_updatePhone] ON [dbo].[tmp_stg_Athletics_MDM]
GO
ALTER TABLE [dbo].[tmp_stg_Athletics_MDM] ADD CONSTRAINT [PK_src_Athletics_MDM] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IX_src_Athletics_MDM_Dimcustomer] ON [dbo].[tmp_stg_Athletics_MDM] ([dimcustomerid])
GO
