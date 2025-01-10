USE DM_AdventureWorks2022
GO


-- Delete from the SCD to show that these records will be loaded into the table again , 1912 rows
DELETE FROM DimCustomers
WHERE CustomerSK % 10 = 5


-- Update City Records (Type 1 Change) These will be not result in a new row but they will be changed in place. 374 Rows
UPDATE DimCustomers 
SET City = 'Alex'
WHERE City = 'London'


-- Update Phone Records (Type 2 Change) and these will result in a new rows in our dimension -- 442 rows
UPDATE DimCustomers
SET phone = Substring(phone, 10, 3) 
             + Substring(phone, 4, 5) + Substring(phone, 9, 1) 
             + Substring(phone, 1, 3) 
WHERE  Len(phone) = 12 AND LEFT(phone, 3) BETWEEN '101' AND '125'; 



-- Now let's check after SCD application

-- Let's see the customers repeated in our dimension table.
SELECT 
	CustomerID, 
    Count(*) 
FROM
	DimCustomers 
GROUP  BY
	CustomerID 
HAVING
	Count(*) > 1 -- We see that there are 434 rows that are duplicated.

SELECT
	* 
FROM
	DimCustomers 
WHERE
	CustomerID = 11036 -- We see the change in phone number led to a new row of the customer 

-- Let's check for type 1 change
SELECT
	*
FROM
	DimCustomers
WHERE
	City = 'Alex'