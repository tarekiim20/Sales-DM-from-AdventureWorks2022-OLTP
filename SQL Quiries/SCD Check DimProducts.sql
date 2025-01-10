USE DM_AdventureWorks2022
GO

SELECT
	COUNT(*) as [Total Number of Rows]
FROM
	DimProducts					-- Total 504 Rows for the inital load.


SELECT
	*
FROM
	DimProducts

-- Delete 50 records and don't worry they will be restored again (with different ProductSK) but the record will be restored.
DELETE FROM DimProducts
WHERE ProductSK % 10 = 5

-- Update a Hisorical Record like ListPrice for 50 rows ( Type 3 Change ) 
UPDATE DimProducts
SET Category = 'MyCategory'
WHERE ProductSK % 10 = 7

-- Update A changing record like Color for 51 rows (Type 2 Change )
UPDATE DimProducts
SET Color = 'Mint Green'
WHERE ProductSK % 10 = 2 

--- Now let's look at the changes
SELECT
	*
FROM
	DimProducts
WHERE
	DimProducts.end_date IS NOT NULL


-- This should be 50 because these are the only added records. (Type 2 Change doesn't actually add new records)
SELECT
	COUNT(*)
FROM
	DimProducts
WHERE
	DimProducts.end_date IS NOT NULL

-- Show Chnages of type 2
SELECT
	*
FROM
	DimProducts
WHERE
	ProductSK % 10 = 2

