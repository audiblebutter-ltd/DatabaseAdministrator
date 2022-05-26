SELECT jobs.name AS 'Job Name', jobsteps.step_id AS 'Step', jobsteps.step_name AS 'Step 
Name', 
 msdb.dbo.agent_datetime(run_date, run_time) AS 'Run Date', 
 ((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60)  
         AS 'Duration' 
FROM msdb.dbo.sysjobs jobs  
INNER JOIN msdb.dbo.sysjobsteps jobsteps  
  ON jobs.job_id = jobsteps.job_id 
INNER JOIN msdb.dbo.sysjobhistory history  
  ON jobsteps.job_id = history.job_id  
  AND jobsteps.step_id = history.step_id  
  AND history.step_id <> 0 
WHERE jobs.enabled = 1 
ORDER BY 'Job Name', 'Run Date' desc; 