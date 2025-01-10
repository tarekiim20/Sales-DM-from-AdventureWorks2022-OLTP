USE DM_AdventureWorks2022
GO

-- Dropping Forign Key
IF EXISTS
(
	SELECT
		*
	FROM
		sys.foreign_keys
	WHERE
		name = 'FK_FactSales_DimTerritory'
	AND
		object_id = object_id('FactSales')
)
ALTER TABLE FactSales
DROP CONSTRAINT FK_FactSales_DimTerritory

-- Dropping Table
IF EXISTS 
(
	SELECT
		*
	FROM
		sys.tables
	WHERE
		Name = 'DimTerritory'
	AND
		type = 'U'
)
DROP TABLE DimTerritory
GO
CREATE TABLE DimTerritory
(
	TerritorySK int identity(1,1) primary key,			-- Surrogate Key
	TerritoryID int,										-- bussiness key
	TerritoryName NVARCHAR(100),
	TerritoryGroup NVARCHAR(100),			
	CountryRegionName NVARCHAR(100),
	ProvinceName NVARCHAR(100),
	Source_System_Code TINYINT NOT NULL,
	start_date DATETIME NOT NULL DEFAULT(GETDATE()),
	end_date DATETIME,
	is_current TINYINT  not null 
)

-- Orphan Handling (Inserting a record for observations which we don't know the trritory)
SET IDENTITY_INSERT DimTerritory ON
INSERT INTO DimTerritory
(
	TerritorySK,
	TerritoryID,
	TerritoryName,
	TerritoryGroup,
	CountryRegionName,
	ProvinceName,
	Source_System_Code,
	start_date,
	end_date,
	is_current
)
VALUES 
(
	-1,
	-1,
	'Unknown',
	'Unknown',
	'Unknown',
	'Unknown',
	0,
	'1900-01-01',
	NULL,
	1
)
SET IDENTITY_INSERT DimTerritory OFF


-- Create Index on Territory ID
IF EXISTS
(
	SELECT
		*
	FROM
		sys.indexes
	WHERE
		name = 'DimTerritory_TerritoryID'
	AND
		object_id =OBJECT_ID('DimTerritory')
)
DROP INDEX DimTerritory.DimTerritory_TerritoryID
GO
CREATE INDEX DimTerritory_TerritoryID on DimTerritory(TerritoryID)