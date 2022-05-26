SELECT name DBName,
	create_date,
	compatibility_level,
	collation_name,
	user_access_desc,
	state_desc ,
	recovery_model_desc
FROM sys.databases 