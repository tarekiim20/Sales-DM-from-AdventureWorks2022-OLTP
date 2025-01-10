USE DM_AdventureWorks2022
GO

IF EXISTS 
(
	SELECT
		*
	FROM
		sys.tables
	WHERE
		name = 'DimDate'
	AND
		type = 'U'
)
DROP TABLE DimDate
GO
CREATE TABLE DimDate
(
	DateSK int identity(1,1) primary key,
	full_date date not null,
	calendar_year int not null,
	calendar_quarter int not null,
	calendar_month_num int not null,
	calendar_month_name NVARCHAR(20)
)