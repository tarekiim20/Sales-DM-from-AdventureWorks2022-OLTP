USE DM_AdventureWorks2022
GO

IF EXISTS 
(
	SELECT
		*
	FROM
		sys.tables
	WHERE
		name = 'FactSales'
	AND
		type = 'U'
)
DROP TABLE FactSales
GO
CREATE TABLE FactSales (
	[FactSalesSK] int identity(1,1) Primary Key,
    [CustomerSK] int,
    [TerritorySK] int,
	[ProductSK] int,
	[OrderDate_SK] int,
    [ShipDate_SK] int,
    [DueDate_SK] int,
	[LineTotal] numeric(38,6),
    [OrderQty] smallint,
	[OnlineOrderFlag] bit,
    [TaxAmt] money,
    [Freight] money,
    [UnitPrice] money,
	[SubTotal] money,
    [UnitPriceDiscount] money,
    [StandardCost] money,
	[TotalDue] money,
    [ExtendedCost] money,
    [ExtendedPrice] money,

	[CreatedAt] DATETIME NOT NULL DEFAULT(Getdate())

	CONSTRAINT FK_FactSales_DimCustomers FOREIGN KEY (CustomerSK) REFERENCES DimCustomers(CustomerSK),
	CONSTRAINT FK_FactSales_DimProducts  FOREIGN KEY (ProductSK) REFERENCES DimProducts(ProductSK),
	CONSTRAINT FK_FactSales_DimTerritory FOREIGN KEY (TerritorySK) REFERENCES DimTerritory(TerritorySK),
	CONSTRAINT FK_FactSales_DimDate_Order FOREIGN KEY (OrderDate_SK) REFERENCES DimDate(DateSK),
	CONSTRAINT FK_FactSales_DimDate_DueDate FOREIGN KEY (DueDate_SK) REFERENCES DimDate(DateSK),
	CONSTRAINT FK_FactSales_DimDate_ShipDate FOREIGN KEY (ShipDate_SK) REFERENCES DimDate(DateSK)
)
