USE
DM_AdventureWorks2022
GO

IF EXISTS
(
	SELECT
		*
	FROM
		sys.tables
	WHERE
		name = 'MetaData'
	AND
		type = 'U'
)
DROP TABLE MetaData
GO
CREATE TABLE MetaData
(
	id int identity(1,1) primary key,
	source_table nvarchar(100) not null,
	last_load_date datetime not null
)
GO
INSERT INTO MetaData
VALUES ('sales order header', '1900-01-01');
