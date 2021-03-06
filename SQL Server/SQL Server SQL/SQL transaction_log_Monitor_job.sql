USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DatabaseBackup - MONITOR_LOGSPACE', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'NCCAD\gwinte', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DatabaseBackup - MONITOR_LOGSPACE'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DatabaseBackup - MONITOR_LOGSPACE', @step_name=N'Record_Log_Space_Size', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'use _DBA

insert  into transaction_log_size 
 select
    DB_NAME(db.database_id) DatabaseName,
    (CAST(mflog.LogSize AS FLOAT)*8)/1024 LogSizeMB,
	getdate() SnapShotDate
FROM sys.databases db
    LEFT JOIN (SELECT database_id, SUM(size) LogSize FROM sys.master_files WHERE type = 1 GROUP BY database_id, type) mflog ON mflog.database_id = db.database_id
 order by name', 
		@database_name=N'_DBA', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DatabaseBackup - MONITOR_LOGSPACE', @step_name=N'Check Stats and Email Warning.', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'use _DBA
declare 
 @RwNu int ,
 @Server varchar(255),
 @Message varchar(3000)
 Begin
select @RwNu = count(1) 
from transaction_log_size
where logsizemb > (select SettingLevel from ControlSettings where SettingName = ''LogSize'')
set @Server = @@SERVERNAME
set @Message = ''This instance '' + @Server + '' has a DB with over transaction Logs in excess of 50gb''
IF @RwNu >= 1
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''NCCDBATeam'',
	@recipients = ''Garry.Graves@nottinghamcity.gov.uk; Ravi.Pinniboyina@nottinghamcity.gov.uk; Gary.Hosker@nottinghamcity.gov.uk; Gareth.Winterman@nottinghamcity.gov.uk'',
 	@body =  @Message,
	@subject = ''Automated Success Message'' ;

end
 
 ', 
		@database_name=N'_DBA', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DatabaseBackup - MONITOR_LOGSPACE', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'NCCAD\gwinte', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DatabaseBackup - MONITOR_LOGSPACE', @name=N'Record_Logfile_Size_Schedule', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190325, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
USE [_DBA]
GO

/****** Object:  Table [dbo].[transaction_log_size]    Script Date: 25/03/2019 14:16:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[transaction_log_size](
	[DatabaseName] [nvarchar](128) NULL,
	[LogSizeMB] [float] NULL,
	[SnapShotDate] [datetime] NOT NULL
) ON [PRIMARY]
GO


SET QUOTED_IDENTIFIER ON
GO
--drop table [ControlSettings]
CREATE TABLE [ControlSettings](
	[SettingName] [varchar](255) NULL,
	[SettingLevel] [int] NULL
) ON [PRIMARY]
GO
insert into [ControlSettings] values ('LogSize', 50000)
USE msdb ;
GO

EXEC dbo.sp_start_job N'DatabaseBackup - MONITOR_LOGSPACE' ;
GO
WAITFOR DELAY '00:00:05';
use _DBA
select *
from [dbo].[transaction_log_size]