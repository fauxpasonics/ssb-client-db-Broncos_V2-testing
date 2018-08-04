CREATE TABLE [dbo].[DimCustomerAttributes]
(
[DimCustomerAttrID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NULL,
[AttributeGroupID] [int] NULL,
[Attributes] [xml] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Creat__4FBCC72F] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Updat__50B0EB68] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[DimCustomerAttributes] ADD CONSTRAINT [PK__DimCusto__ABC694027A0D8CEA] PRIMARY KEY NONCLUSTERED  ([DimCustomerAttrID])
GO
CREATE CLUSTERED INDEX [IXC_DimCustomerAttributes] ON [dbo].[DimCustomerAttributes] ([DimCustomerID], [AttributeGroupID])
GO
