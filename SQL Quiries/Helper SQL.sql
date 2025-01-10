SELECT
	ST.TerritoryID,
	ST.Name AS TerritoryName,
	[Group] AS TerritoryGroup,
	CR.Name AS CountryRegionName,
	SP.Name AS ProvinceName
FROM
	sales.SalesTerritory as ST
LEFT JOIN
	Person.CountryRegion as CR
ON
	ST.CountryRegionCode = CR.CountryRegionCode
LEFT JOIN
	Person.StateProvince AS SP
ON
	SP.CountryRegionCode = ST.CountryRegionCode