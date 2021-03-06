USE [CC_Problem3]
GO
/****** Object:  User [test]    Script Date: 26-09-2021 08:44:12 ******/
CREATE USER [test] FOR LOGIN [test] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [test]
GO
ALTER ROLE [db_datareader] ADD MEMBER [test]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [test]
GO
/****** Object:  Table [dbo].[PO_Products]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PO_Products](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseOrderID] [bigint] NOT NULL,
	[ProductID] [int] NULL,
	[POQuantity] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Tax] [decimal](18, 2) NOT NULL,
	[Subtotal] [money] NOT NULL,
 CONSTRAINT [PK_PO_Products] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurchaseOrder]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseOrder](
	[PurchaseOrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[PurchaseOrderNr] [nvarchar](20) NOT NULL,
	[SupplierID] [int] NOT NULL,
	[PurchaseOrderDateTime] [datetime] NOT NULL,
	[POVat] [decimal](18, 2) NOT NULL,
	[POTotal] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PurchaseOrder] PRIMARY KEY CLUSTERED 
(
	[PurchaseOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_PurchaseOrder] UNIQUE NONCLUSTERED 
(
	[PurchaseOrderNr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SupplierProducts]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupplierProducts](
	[ProductID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](50) NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[ProductPrice] [decimal](18, 2) NULL,
	[SupplierID] [bigint] NOT NULL,
 CONSTRAINT [PK_SupplierProducts] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Suppliers]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[SupplierID] [bigint] IDENTITY(1,1) NOT NULL,
	[SupplierCode] [nvarchar](10) NOT NULL,
	[SupplierName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Suppliers_Code] UNIQUE NONCLUSTERED 
(
	[SupplierCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_PO_Products]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PO_Products]
AS
SELECT        dbo.PO_Products.PurchaseOrderID, dbo.PO_Products.ProductID, dbo.SupplierProducts.ProductCode, dbo.SupplierProducts.ProductName, dbo.PO_Products.POQuantity, dbo.PO_Products.UnitPrice, dbo.PO_Products.Tax, 
                         dbo.PO_Products.Subtotal, dbo.Suppliers.SupplierCode, dbo.Suppliers.SupplierName, dbo.PO_Products.ID
FROM            dbo.PO_Products INNER JOIN
                         dbo.SupplierProducts ON dbo.PO_Products.ProductID = dbo.SupplierProducts.ProductID INNER JOIN
                         dbo.Suppliers ON dbo.SupplierProducts.SupplierID = dbo.Suppliers.SupplierID

GO
/****** Object:  View [dbo].[vw_PurchageOrders]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PurchageOrders]
AS
SELECT        dbo.PurchaseOrder.PurchaseOrderID, dbo.PurchaseOrder.PurchaseOrderNr, dbo.PurchaseOrder.PurchaseOrderDateTime, dbo.PurchaseOrder.POVat, dbo.PurchaseOrder.POTotal, dbo.Suppliers.SupplierCode, 
                         dbo.Suppliers.SupplierName, dbo.PurchaseOrder.SupplierID
FROM            dbo.PurchaseOrder INNER JOIN
                         dbo.Suppliers ON dbo.PurchaseOrder.SupplierID = dbo.Suppliers.SupplierID

GO
/****** Object:  View [dbo].[vw_SupplierCodes]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SupplierCodes]
AS
SELECT        SupplierCode
FROM            dbo.Suppliers

GO
/****** Object:  View [dbo].[vw_SupplierProducts]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SupplierProducts]
AS
SELECT        ProductID, ProductCode, ProductName, ProductPrice, SupplierID
FROM            dbo.SupplierProducts

GO
/****** Object:  View [dbo].[vw_Suppliers]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Suppliers]
AS
SELECT        SupplierID, SupplierName, SupplierCode
FROM            dbo.Suppliers

GO
ALTER TABLE [dbo].[PO_Products] ADD  CONSTRAINT [DF_PO_Products_UnitPrice]  DEFAULT ((0.0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[PO_Products] ADD  CONSTRAINT [DF_PO_Products_Subtotal]  DEFAULT ((0.0)) FOR [Subtotal]
GO
ALTER TABLE [dbo].[PurchaseOrder] ADD  CONSTRAINT [DF_PurchaseOrder_PurchaseOrderDateTime]  DEFAULT (getdate()) FOR [PurchaseOrderDateTime]
GO
/****** Object:  StoredProcedure [dbo].[usp_CreateProduct]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CreateProduct] 
	@SupplierID		int,
	@ProductCode	NVARCHAR(10),
	@ProductName	NVARCHAR(50),
	@ProductPrice	MONEY=0.0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     INSERT INTO [CC_Problem3].dbo.SupplierProducts(
		ProductCode, ProductName, ProductPrice, SupplierID

	)
	VALUES(
		@ProductCode, @ProductName, @ProductPrice, @SupplierID

	);
END

GO
/****** Object:  StoredProcedure [dbo].[usp_CreatePurchaseOrder]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CreatePurchaseOrder] 

	@PurchaseOrderNr NVARCHAR(20),
	@SupplierID		 INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	--IF NOT EXISTS(SELECT PurchaseOrderID FROM [CC_Problem3].dbo.PurchaseOrder WHERE PurchaseOrderNr=@PurchaseOrderNr)
	--BEGIN
		INSERT INTO [CC_Problem3].dbo.PurchaseOrder(PurchaseOrderNr, PurchaseOrderDateTime,SupplierID, POVat, POTotal)
		VALUES(@PurchaseOrderNr, GETDATE(),@SupplierID,0.0,0.0 );
	--END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_CreatePurchaseOrderProduct]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CreatePurchaseOrderProduct] 
	@PurchaseOrderID		int,
	@ProductID				INT,
	@POQuantity	INT,
	@Tax	MONEY=0.0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Subtotal MONEY=0.0
	DECLARE @POTotal MONEY=0.0,@UnitPrice	MONEY=0.0,@Totaltax Money=0.0

	SELECT @UnitPrice=ProductPrice FROM SupplierProducts WHERE ProductID=@ProductID

	SET @Totaltax = @UnitPrice*@POQuantity*@Tax/100
	
	SET @Subtotal=@UnitPrice*@POQuantity + @Totaltax

	 SET @Subtotal=@POQuantity*@UnitPrice+(@POQuantity*@UnitPrice/100)

     INSERT INTO [CC_Problem3].dbo.PO_Products(PurchaseOrderID, ProductID,POQuantity, UnitPrice, Tax,Subtotal)
	 VALUES(@PurchaseOrderID, @ProductID,@POQuantity, @UnitPrice, @Tax,@Subtotal);

	UPDATE PurchaseOrder SET POTotal = (SELECT SUM(Subtotal) FROM PO_Products WHERE PO_Products.PurchaseOrderID=PurchaseOrder.PurchaseOrderID),
	POVat = (SELECT SUM(POQuantity*UnitPrice*Tax/100) FROM PO_Products WHERE PO_Products.PurchaseOrderID=PurchaseOrder.PurchaseOrderID)
	WHERE PurchaseOrderID=@PurchaseOrderID

END


GO
/****** Object:  StoredProcedure [dbo].[usp_CreateSupplier]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_CreateSupplier] 
	@SupplierCode NVARCHAR(10)
	, @SupplierName NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [CC_Problem3].dbo.Suppliers(
		SupplierCode
		, SupplierName
	)
	VALUES(
		@SupplierCode
		, @SupplierName
	);
		
END

GO
/****** Object:  StoredProcedure [dbo].[usp_DeletePoProductById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_DeletePoProductById]
	-- Add the parameters for the stored procedure here
	@ID INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [CC_Problem3].[dbo].PO_Products
	WHERE ID = @ID;

	DECLARE @PurchaseOrderID INT 
	SELECT @PurchaseOrderID=PurchaseOrderID FROM [CC_Problem3].[dbo].PO_Products 
	WHERE ID=@ID

	UPDATE PurchaseOrder SET POTotal = (SELECT SUM(Subtotal) FROM PO_Products WHERE PO_Products.PurchaseOrderID=PurchaseOrder.PurchaseOrderID),
	POVat = (SELECT SUM(POQuantity*UnitPrice*Tax/100) FROM PO_Products WHERE PO_Products.PurchaseOrderID=PurchaseOrder.PurchaseOrderID)
	WHERE PurchaseOrderID= @PurchaseOrderID

END



GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteProductById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_DeleteProductById]
	-- Add the parameters for the stored procedure here
	@ProductID INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     DELETE FROM [CC_Problem3].[dbo].SupplierProducts
	WHERE ProductID = @ProductID;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_DeletePurchaseOrderById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_DeletePurchaseOrderById]
	-- Add the parameters for the stored procedure here
	@PurchaseOrderID INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 DELETE FROM [CC_Problem3].[dbo].PO_Products
	WHERE PurchaseOrderID = @PurchaseOrderID;

     DELETE FROM [CC_Problem3].[dbo].PurchaseOrder
	WHERE PurchaseOrderID = @PurchaseOrderID;
END


GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteSupplier]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DeleteSupplier]
	@SupplierID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM [CC_Problem3].[dbo].[Suppliers]
	WHERE SupplierID = @SupplierID;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EditProductById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_EditProductById]
	@ProductID	INT,
	@SupplierID BIGINT
	,@ProductCode NVARCHAR(10)
	,@ProductName NVARCHAR(50),@ProductPrice MONEY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [CC_Problem3].[dbo].SupplierProducts
	SET SupplierID = @SupplierID,ProductCode= @ProductCode, ProductName = @ProductName,ProductPrice=@ProductPrice
	WHERE ProductID = @ProductID
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EditPurchasgeOrderById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_EditPurchasgeOrderById]
	@PurchaseOrderID BIGINT,
	@ProductID	INT,
	@PurchaseOrderNr	VARCHAR(20),
	@POQuantity INT,
	@POVat MONEY=0.0,
	@ProductPrice	MONEY=0.0,
	@POTotal		MONEY=0.0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [CC_Problem3].[dbo].PurchaseOrder
	SET PurchaseOrderNr= @PurchaseOrderNr, POVat=@POVat,POTotal=@POTotal
	WHERE PurchaseOrderID = @PurchaseOrderID
END


GO
/****** Object:  StoredProcedure [dbo].[usp_EditSupplier]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_EditSupplier]
	@SupplierID BIGINT
	, @SupplierCode NVARCHAR(10)
	, @SupplierName NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [CC_Problem3].[dbo].[Suppliers]
	SET SupplierCode = @SupplierCode
	, SupplierName = @SupplierName
	WHERE SupplierID = @SupplierID
END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetPO_ProductsByPoId]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPO_ProductsByPoId]
	@PurchaseOrderID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ID, PurchaseOrderID, ProductID, ProductCode, ProductName, POQuantity as Quantity, UnitPrice, Tax, Subtotal, SupplierCode, SupplierName
	FROM vw_PO_Products
	WHERE PurchaseOrderID = @PurchaseOrderID;

END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetProductById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetProductById] 
	-- Add the parameters for the stored procedure here
	@ProductID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		ProductID, ProductCode, ProductName, ProductPrice, SupplierID
		FROM   vw_SupplierProducts
	WHERE ProductID = @ProductID;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetProductsBySupplierId]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetProductsBySupplierId]
	@SupplierID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		ProductID
		, ProductCode
		, ProductName
		, ProductPrice
	FROM [CC_Problem3].[dbo].[vw_SupplierProducts]
	WHERE SupplierID = @SupplierID;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetPurchaseOrderById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPurchaseOrderById] 
	-- Add the parameters for the stored procedure here
	@PurchaseOrderID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT PurchaseOrderID, PurchaseOrderNr, PurchaseOrderDateTime, SupplierCode, SupplierName
,POVat, POTotal
		FROM vw_PurchageOrders
	WHERE PurchaseOrderID = @PurchaseOrderID;
END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetPurchaseOrders]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPurchaseOrders]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT  PurchaseOrderID, PurchaseOrderNr, PurchaseOrderDateTime, POVat, POTotal
FROM            vw_PurchageOrders
END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetPurchaseOrdersBySupplierId]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPurchaseOrdersBySupplierId]
@SupplierID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT  PurchaseOrderID, PurchaseOrderNr, PurchaseOrderDateTime, POVat AS TotalTax , POTotal AS GrandTotal,SupplierID,SupplierCode,SupplierName
FROM vw_PurchageOrders where SupplierID=@SupplierID
END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetSupplierById]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetSupplierById] 
	-- Add the parameters for the stored procedure here
	@SupplierID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		SupplierID
		, SupplierName
		, SupplierCode
	FROM [CC_Problem3].[dbo].[vw_Suppliers]
	WHERE SupplierID = @SupplierID;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetSuppliers]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetSuppliers]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		SupplierID
		, SupplierName
		, SupplierCode
	FROM [CC_Problem3].dbo.vw_Suppliers;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_Report_PurchaseOrder]    Script Date: 26-09-2021 08:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Report_PurchaseOrder]
@SupplierName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	This report should show the total purchase amounts per product per month for the last 3 months for a specific supplier. 
	Ordered by highest total per month
	*/

	
	--SELECT *
	--, CONVERT(VARCHAR(50), (SELECT SupplierName FROM Suppliers S WHERE S.SupplierID = (SELECT SupplierID FROM SupplierProducts JOIN PurchaseOrder 
	--ON  SupplierProducts.ProductID = PurchaseOrder.ProductID))) as suppliername
	--, CONVERT(varchar(50), PO2.PurchaseOrderNr) as purchaseordernumber
	--, (convert(decimal(18,3),PurchaseOrder.POQuantity) * convert(decimal(18,3),SupplierProducts.ProductPrice)) 
	--+ (convert(decimal(18,3),PurchaseOrder.POQuantity) * convert(decimal(18,3),SupplierProducts.ProductPrice) * convert(decimal(18,3),PurchaseOrder.POVat)) as total 
	--, case when datediff(M, getdate(), dateadd(d,-90, getdate())) > 3 then month(PO2.PurchaseOrderDateTime) else null end as [month]
	--FROM PurchaseOrder
	--full outer join SupplierProducts on PurchaseOrder.ProductID = SupplierProducts.ProductID
	--full outer join Suppliers on SupplierProducts.SupplierID = Suppliers.SupplierID
	--join PurchaseOrder as PO2 on PurchaseOrder.PurchaseOrderNr = PO2.PurchaseOrderNr
	--group by PO2.PurchaseOrderId, PurchaseOrder.PurchaseOrderNr, PurchaseOrder.PurchaseOrderDateTime, PurchaseOrder.ProductID
	--, PurchaseOrder.POQuantity, PurchaseOrder.POVat, PurchaseOrder.POTotal, SupplierProducts.ProductID, SupplierProducts.ProductCode, SupplierProducts.ProductName
	--, SupplierProducts.ProductPrice, SupplierProducts.SupplierID, Suppliers.SupplierID, Suppliers.SupplierCode, Suppliers.SupplierName, PurchaseOrder.PurchaseOrderID
	--, PO2.PurchaseOrderNr
	--, PO2.PurchaseOrderDateTime, PO2.ProductID
	--, PO2.POQuantity, PO2.POVat, PO2.POTotal
	--order by PO2.PurchaseOrderNr desc, PurchaseOrder.PurchaseOrderDateTime asc
	--;


	SELECT SupplierCode,SupplierName,ProductCode,ProductName,[Month],IsNull(SUM(POTotal),0.0)  AS TotalAmounts

	FROM(
	SELECT S.SupplierCode,S.SupplierName, ProductCode,ProductName,POTotal,
	case when datediff(M, getdate(), dateadd(d,-90, getdate())) > 3 then month(PO.PurchaseOrderDateTime) else null end as [Month]
	FROM
		Suppliers S JOIN SupplierProducts SP ON S.SupplierID=SP.SupplierID LEFT  JOIN PO_Products POP ON SP.ProductID=POP.ProductID 
	LEFT  JOIN  PurchaseOrder PO ON PO.PurchaseOrderID=POP.PurchaseOrderID 
	WHERE S.SupplierName=@SupplierName AND PO.PurchaseOrderDateTime>dateadd(d,-90, getdate())
	)  AS Temp
	GROUP BY ProductCode,ProductName,[Month],SupplierCode,SupplierName

	ORDER BY TotalAmounts DESC


END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[9] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PO_Products"
            Begin Extent = 
               Top = 14
               Left = 51
               Bottom = 212
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SupplierProducts"
            Begin Extent = 
               Top = 2
               Left = 347
               Bottom = 183
               Right = 517
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Suppliers"
            Begin Extent = 
               Top = 4
               Left = 621
               Bottom = 133
               Right = 773
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PO_Products'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PO_Products'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[25] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PurchaseOrder"
            Begin Extent = 
               Top = 22
               Left = 22
               Bottom = 236
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Suppliers"
            Begin Extent = 
               Top = 6
               Left = 323
               Bottom = 162
               Right = 493
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PurchageOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PurchageOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Suppliers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SupplierCodes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SupplierCodes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SupplierProducts"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 209
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SupplierProducts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SupplierProducts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Suppliers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Suppliers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Suppliers'
GO
