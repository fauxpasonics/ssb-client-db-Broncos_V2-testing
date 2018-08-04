SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[SplitMultiColumn]
(
      @String NVARCHAR(MAX), 
      @ColumnDelimeter NVARCHAR(4) = '|',
      @RowDelimeter NVARCHAR(4) = ','
)

RETURNS
@Values TABLE 
(     
	Col1 VARCHAR(4000),
	Col2 VARCHAR(4000)      
)
AS

BEGIN

	DECLARE @Xdoc XML

	DECLARE @Rows TABLE (Item VARCHAR(4000))

	--XML parser doesn't work for the & symbol. 
	--Convert it to another value before parsing and then convert back before returning the table
	SET @String = REPLACE(@String, '&', '*$and$*')

	SET @Xdoc = CONVERT(XML,'<r><v>' + REPLACE(@String, @RowDelimeter,'</v><v>') + '</v></r>')

	INSERT INTO @Rows(Item)
	SELECT [Item] = REPLACE(LTRIM(RTRIM(T.c.value('.','varchar(1000)'))),'*$and$*','&')
	FROM @Xdoc.nodes('/r/v') T(c)            

	INSERT INTO @Values (Col1, Col2)
	SELECT dbo.fnGetValueFromDelimitedString(Item, @ColumnDelimeter, '1') Col1
	, dbo.fnGetValueFromDelimitedString(Item, @ColumnDelimeter, '2') Col2
	FROM @Rows



	RETURN

END



GO
