/*
   this proc checks if its the primary replica for any availability groups and enables or disables ALL Sql Agent Jobs 
   If its primary the jobs are enabled else they are disabled

*/
alter PROCEDURE dbo.sp_HADRAgentJobFailover (@AGname varchar(200) = '%AG01' )
AS 

DECLARE @SQL NVARCHAR(MAX)

--;WITH DBinAG AS (  -- This finds all databases in the AG )
--SELECT  distinct
--        runJobs = CASE WHEN role_desc = 'Primary' THEN 1 ELSE 0 END   --If this is the primary, then yes we want to run the jobs
--        ,dbname = db.name
-- FROM sys.dm_hadr_availability_replica_states hars
--INNER JOIN sys.availability_groups ag ON ag.group_id = hars.group_id
--INNER JOIN sys.Databases db ON  db.replica_id = hars.replica_id
--WHERE is_local = 1
----AND ag.Name = @AGname
--) 


  
  Declare @enable char(1) = '0'

   SELECT top 1 @enable = '1'
   FROM sys.DATABASES d
   INNER JOIN sys.dm_hadr_availability_replica_states hars ON d.replica_id = hars.replica_id
   WHERE 
   role_desc = 'Primary'

  
     -- select @enable
               
			   
SELECT @SQL = (
SELECT DISTINCT N'exec msdb..sp_update_job @job_name = ''' + j.name + ''', @enabled = '+ @enable  + ' ;'
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobsteps s
ON j.job_id = s.job_id
FOR XML PATH ('')
)
--PRINT REPLACE(@SQL,';',CHAR(10))
EXEC sys.sp_executesql @SQL

GO

dbo.sp_HADRAgentJobFailover 'AvailabilityGroup1'