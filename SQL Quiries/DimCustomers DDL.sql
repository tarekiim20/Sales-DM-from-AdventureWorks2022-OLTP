USE  DM_AdventureWorks2022
GO

-- Forign Key Drop
IF EXISTS 
(
	SELECT
		*
	FROM
		sys.foreign_keys
	WHERE
		name = 'FK_FactSales_DimCustomers'
	AND
		object_id = OBJECT_ID('FactSales')
)
ALTER TABLE FactSales
Drop CONSTRAINT  FK_FactSales_DimCustomers

-- Table Drop
IF EXISTS (
			SELECT
				* 
			FROM
				sys.tables
			WHERE
				name = 'DimCustomers'
			AND
				type = 'U')
DROP TABLE DimCustomers
GO
-- Create Table
CREATE TABLE DimCustomers(
    [CustomerSK] int identity(1,1) primary key,					-- surrgoate key
    [CustomerID] int,
    [CustomerName] nvarchar(150),
    [Address1] nvarchar(60),
    [Address2] nvarchar(60),
    [City] nvarchar(30),
    [Phone] nvarchar(25),
	[Source_System_code] tinyint not null,
	[start_date] datetime not null default(getdate()),			-- SDC
	[end_date] datetime null,									-- SDC
	[is_current] tinyint not null								-- SDC
)


-- Insert a record to handle for Oraphan Data (Missing Data)
SET IDENTITY_INSERT DimCustomers ON

INSERT INTO DimCustomers
            (CustomerSK,
             CustomerID,
             CustomerName,
             address1,
             address2,
             city,
             phone,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES      (-1,
             -1,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             '1900-01-01',
             NULL,
             1 )
SET IDENTITY_INSERT DimCustomers OFF


-- Index Creation
------ CustomerID
IF EXISTS
(
	SELECT
		*
	FROM
		sys.indexes
	WHERE
		name = 'DimCustomers_CustomerID'
	AND
		object_id = OBJECT_ID('DimCustomers')
)
DROP INDEX DimCustomers.DimCustomers_CustomerID
GO
CREATE INDEX DimCustomers_CustomerID ON DimCustomers(CustomerID)

------ City
IF EXISTS
(
	SELECT
		*
	FROM
		sys.indexes
	WHERE
		name = 'DimCustomers_City'
	AND
		object_id = OBJECT_ID('DimCustomers')
)
DROP INDEX DimCustomers.DimCustomers_City
GO
CREATE INDEX DimCustomers_City ON DimCustomers(City)