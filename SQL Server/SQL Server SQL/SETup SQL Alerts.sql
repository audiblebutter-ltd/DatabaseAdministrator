USE [msdb]

USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @databasemail_profile=N'NCC DBA Mail Profile'
GO


GO
--EXEC msdb.dbo.sp_purge_jobhistory  @oldest_date='2016-11-20T13:04:16'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @jobhistory_max_rows=-1, 
		@jobhistory_max_rows_per_job=-1
GO

/****** Object:  Operator [DBAs]    Script Date: 18/12/2016 12:58:51 ******/
EXEC msdb.dbo.sp_add_operator @name=N'DBAs', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'nccdbateam@nottinghamcity.gov.uk', 
		@category_name=N'[Uncategorized]'
GO

USE [msdb]
GO

/****** Object:  Operator [DBA Manager]    Script Date: 18/12/2016 12:59:25 ******/
EXEC msdb.dbo.sp_add_operator @name=N'DBA Manager', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'leonard.bonde@nottinghamcity.gov.uk', 
		@category_name=N'[Uncategorized]'
GO



DECLARE @OperatorName NVARCHAR(1000),@OperatorNameEmail NVARCHAR(1000),@AlertName NVARCHAR(4000),@AlertSeverity INT
SET @OperatorName = N'DBAs'

--IF  NOT EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'SQLALERTS')
--BEGIN
--EXEC msdb.dbo.sp_add_operator @name=@OperatorName,@enabled=1,@email_address=N'sqlalerts@yourdomain.com'
--END

DECLARE c CURSOR LOCAL FAST_FORWARD
FOR SELECT DISTINCT [severity] FROM sys.messages WHERE [severity] IN (14,16,17,18,19,20,21,22,23,24) UNION ALL SELECT 25 ORDER BY [severity]		
OPEN c;
FETCH NEXT FROM c INTO @AlertSeverity;			
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRY
		SET @AlertName = N'Severity ' + RIGHT('000'+CAST(@AlertSeverity AS VARCHAR(3)),3)
		IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = @AlertName)
		BEGIN
			PRINT 'Deleting Alert: '+@AlertName
			EXEC msdb.dbo.sp_delete_alert @name=@AlertName
		END
			PRINT 'Creating Alert: '+@AlertName
			EXEC msdb.dbo.sp_add_alert @name=@AlertName, 
					@message_id=0, 
					@severity=@AlertSeverity, 
					@enabled=1, 
					@delay_between_responses=0, 
					@include_event_description_in=1, 
					@category_name=N'[Uncategorized]', 
					@job_id=N'00000000-0000-0000-0000-000000000000'
			PRINT 'Adding Alert: '+@AlertName + ' Notification ' + @OperatorName
			EXEC msdb.dbo.sp_add_notification @alert_name=@AlertName,@operator_name=@OperatorName,@notification_method = 1
			EXEC msdb.dbo.sp_add_notification @alert_name=@AlertName,@operator_name=[DBA],@notification_method = 1
	
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
	FETCH NEXT FROM c INTO @AlertSeverity;
END			
CLOSE c;
DEALLOCATE c;

/*
--Reset counters
DECLARE @curr_date INT,@curr_time INT,@dt DATETIME
SET @dt = CURRENT_TIMESTAMP 
SELECT @curr_date = CAST(CONVERT(CHAR, @dt,112) AS INT),@curr_time=(DATEPART(hh,@dt)*10000)+(DATEPART(mi,@dt)*100)+DATEPART(ss,@dt)
   
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 014',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 016',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 017',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 018',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 019',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 020',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 021',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 022',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 023',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 024',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
EXECUTE msdb.dbo.sp_update_alert @name = N'Severity 025',@count_reset_date=@curr_date,@count_reset_time=@curr_time,@occurrence_count=0
*/
/*
Now not all alerts are raise to the log, therefore in some cases you may wish to change this behaviour. For example permissions issue could be raise if we tell sql to log them.

SELECT * FROM sys.messages WHERE [message_id] = 229
The %ls permission was denied on the object '%.*ls', database '%.*ls', schema '%.*ls'.
sp_altermessage (Transact-SQL)
http://msdn.microsoft.com/en-us/library/ms175094.aspx
EXEC msdb.dbo.sp_altermessage 229,'WITH_LOG','true';
*/
