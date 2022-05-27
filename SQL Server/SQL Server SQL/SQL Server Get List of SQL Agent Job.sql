
use msdb;

select 
				SYSJ.name sysjobschedulesname
			,	SYSS.name sysjobname 
			,	sl.name sysloginname
			,	sysj.enabled
			,	sysj.date_created
			,	sysj.date_modified
			,	sysj.version_number
			,	sysjs.next_run_date
			,	sysjs.next_run_time
from sysjobs as SYSJ

inner join sysjobschedules as SYSJS on SYSJ.job_id = SYSJS.job_id
inner join sysschedules SYSS on SYSS.schedule_id = SYSJS.schedule_id
inner join master.sys.syslogins as sl on sysj.owner_sid = sl.sid 
;
