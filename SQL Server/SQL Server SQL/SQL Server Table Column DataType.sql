use SWTEST3
select sys.columns.name column_name
,	sys.tables.name table_name
, sys.types.name datatype
from sys.columns ,
	sys.tables ,
	sys.types
where sys.columns.is_nullable = 0
and sys.columns.object_id = sys.tables.object_id
and sys.columns.system_type_id = sys.types.system_type_id

order by sys.tables.name
