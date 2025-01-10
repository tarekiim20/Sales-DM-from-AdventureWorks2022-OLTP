USE AdventureWorks2022
GO

set Identity_insert sales.SalesOrderHeader on
INSERT INTO sales.SalesOrderHeader 
(SalesOrderID, OrderDate,DueDate, ShipDate, CustomerID, BillToAddressID, ShipToAddressID, ShipMethodID)
VALUES
(6,'2022-05-31 00:00:00.000','2022-05-31 00:00:00.000','2022-05-31 00:00:00.000',29565,850,921,5),
(7,'2022-05-31 00:00:00.000','2022-05-31 00:00:00.000','2022-05-31 00:00:00.000',29565,850,921,5),
(8,'2022-05-31 00:00:00.000','2022-05-31 00:00:00.000','2022-05-31 00:00:00.000',29565,850,921,5),
(9,'2022-05-31 00:00:00.000','2022-05-31 00:00:00.000','2022-05-31 00:00:00.000',29565,850,921,5),
(10,'2022-05-31 00:00:00.000','2022-05-31 00:00:00.000','2022-05-31 00:00:00.000',29565,850,921,5)
set Identity_insert sales.SalesOrderHeader off

set Identity_insert sales.SalesOrderDetail on
INSERT INTO sales.SalesOrderDetail 
(SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, UnitPrice, SpecialOfferID)
VALUES
(6,1,884,1,53.99,1),
(7,1,884,1,53.99,1),
(8,1,884,1,53.99,1),
(9,1,884,1,53.99,1),
(10,1,884,1,53.99,1)
set Identity_insert sales.SalesOrderDetail off


