
--Scripting SQL Logins
--SQL
SET NOCOUNT ON
SELECT 'EXEC sp_addlogin @loginame = ''' + loginname + ''''
,', @defdb = ''' + dbname + ''''
,', @deflanguage = ''' + language + ''''
,', @encryptopt = ''skip_encryption'''
,', @passwd ='
, cast(password AS varbinary(256))
,', @sid ='
, sid
FROM syslogins
WHERE name NOT IN ('sa')
AND isntname = 0

--Windows
SELECT 'EXEC sp_grantlogin @loginame = ''' + loginname + ''''
,' EXEC sp_defaultdb @loginame = ''' + loginname + ''''
,', @defdb = ''' + dbname + ''''
FROM syslogins
WHERE loginname NOT IN ('BUILTIN\Administrators')
AND isntname = 1

