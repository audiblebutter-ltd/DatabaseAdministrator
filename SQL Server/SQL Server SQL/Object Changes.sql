
------------------------------------------- DBSPECIFIC
    
------------------ proc's
DECLARE @command varchar(1000) 
SELECT @command = '
USE ?
SELECT 
	@@SERVERNAME instanceName,
	db_name() DBname,
	SPECIFIC_NAME ObjectName,
	routine_type ObjectType,
	LAST_ALTERED LastAltered
FROM INFORMATION_SCHEMA.ROUTINES' 
EXEC sp_MSforeachdb @command 
------------------ tables
go
DECLARE @command varchar(1000) 
SELECT @command = '
USE ?
SELECT
	@@SERVERNAME instanceName,
	db_name() DBname,
	[name] ObjectName,
	''Table'' ObjectType,
	[modify_date] LastAltered
	  FROM sys.tables
' 
EXEC sp_MSforeachdb @command 
go
-------------------View
DECLARE @command varchar(1000) 
SELECT @command = '
USE ?
SELECT
	@@SERVERNAME instanceName,
	db_name() DBname,
	[name] ObjectName,
	''Views'' ObjectType,
	[modify_date] LastAltered
	  FROM sys.views

' 
EXEC sp_MSforeachdb @command 



------------------------------------------- DBSPECIFIC
go
------------------ Agent
if exists (select name from sys.databases where name = 'MSDB') 
SELECT 
	@@SERVERNAME instanceName,
	'MSDB' DBname,
	[name] ObjectName,
	'Agent Job' ObjectType,
	[date_modified] LastAltered
from msdb.dbo.sysjobs
go
------------------ SSIS Packages
if exists (select name from sys.databases where name = 'SSISDB') 
SELECT 
	@@SERVERNAME instanceName,
	'SSISDB' DBname,
	name ObjectName,
	'SSIS Project' ObjectType,
	convert(datetime,[last_deployed_time]) LastAltered
 from ssisdb.internal.projects
 