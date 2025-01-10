USE DM_AdventureWorks2022

GO

--Foreign Key Drop
IF EXISTS
(
	SELECT
		*
	FROM
		sys.foreign_keys
	WHERE
		name = 'FK_FactSales_DimProducts'
	AND
		object_id = OBJECT_ID('FactSales')
)
ALTER TABLE FactSales
DROP CONSTRAINT FK_FactSales_DimProducts

-- DROP TABLE IF EXSISTS
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'DimProducts' AND type = 'U')
	DROP TABLE DimProducts

CREATE TABLE DimProducts(
	[ProductSK] int Identity(1,1) PRIMARY KEY,				-- Surrgoate Key
	[ProductID] int,
    [Name] nvarchar(50),
    [ProductNumber] nvarchar(25),
    [MakeFlag] bit,
    [FinishedGoodsFlag] bit,
    [Color] nvarchar(15),
    [ReorderPoint] smallint,
    [StandardCost] money,
    [ListPrice] money,
    [Class] nvarchar(2),
    [Style] nvarchar(2),
    [SafetyStockLevel] smallint,
    [DaysToManufacture] int,
    [SubCategory] nvarchar(50),
    [Category] nvarchar(50),
    [ModelName] nvarchar(50),
    [Description] nvarchar(400),
    [CultureName] nvarchar(50),
	[Source_System_Code] TINYINT NOT NULL,					-- Indication from where the record had come(MetaData)
	[start_date] datetime NOT NULL DEFAULT(GETDATE()),		-- SCD
	[end_date] datetime,									-- SCD
	[is_current] tinyint NOT NULL default(1)				-- SCD
)

SET IDENTITY_INSERT DimProducts ON
INSERT INTO DimProducts
(
    ProductSK,           -- int, not null
    ProductID,           -- int, not null
    Name,                -- nvarchar(50), null
    ProductNumber,       -- nvarchar(25), null
    MakeFlag,            -- bit, null
    Color,               -- nvarchar(15), null
    ReorderPoint,        -- smallint, null
    StandardCost,        -- money, null
    ListPrice,           -- money, null
    Class,               -- nvarchar(2), null
    SafetyStockLevel,    -- smallint, null
    DaysToManufacture,   -- int, null
    SubCategory,         -- nvarchar(50), null
    Category,            -- nvarchar(50), null
    ModelName,           -- nvarchar(50), null
    Description,         -- nvarchar(400), null
    CultureName,         -- nvarchar(50), null
    Source_System_Code,  -- tinyint, not null
    start_date,          -- datetime, not null
    end_date,            -- datetime, null
    is_current           -- tinyint, not null
)
VALUES
(
    -1,                 -- ProductSK (PK, int, not null)
    -1,                 -- ProductID (int, not null)
    'Unknown',          -- Name (nvarchar(50), null)
    'Unknown',          -- ProductNumber (nvarchar(25), null)
    1,                  -- MakeFlag (bit, null)
    'Unknown',          -- Color (nvarchar(15), null)
    0,                  -- ReorderPoint (smallint, null)
    0.0,                -- StandardCost (money, null)
    0.0,                -- ListPrice (money, null)
    'Un',               -- Class (nvarchar(2), null)
    0,                  -- SafetyStockLevel (smallint, null)
    NULL,               -- DaysToManufacture (int, null)
    'Unknown',          -- SubCategory (nvarchar(50), null)
    'Unknown',          -- Category (nvarchar(50), null)
    'Unknown',          -- ModelName (nvarchar(50), null)
    'Unknown',          -- Description (nvarchar(400), null)
    'Unknown',          -- CultureName (nvarchar(50), null)
    1,                  -- Source_System_Code (tinyint, not null)
    '1900-01-01',       -- start_date (datetime, not null)
    NULL,               -- end_date (datetime, null)
    1                   -- is_current (tinyint, not null)
);
SET IDENTITY_INSERT DimProducts OFF




-- Create Index
--ProductID
IF EXISTS
(
	SELECT
		*
	FROM
		sys.indexes
	WHERE
		name = 'DimProducts_ProductID'
	AND
		object_id = OBJECT_ID('DimProducts')
)
DROP INDEX DimProducts.DimProducts_ProductID
GO
CREATE INDEX DimProducts_ProductID ON DimProducts(ProductID)

--Category
IF EXISTS
(
	SELECT
		*
	FROM
		sys.indexes
	WHERE
		name = 'DimProducts_ProductCategory'
	AND
		object_id = OBJECT_ID('DimProducts')
)
DROP INDEX DimProducts.DimProducts_ProductCategory
GO
CREATE INDEX DimProducts_ProductCategory ON DimProducts(Category)