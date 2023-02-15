CREATE PROC	PK_usage_check_audit
AS
DECLARE
	@dbname NVARCHAR(125) ,
	@mxdbid INT ,
	@dbid INT

SELECT @mxdbid = MAX(database_id) FROM Sys.databases 
set  @dbid = 1

WHILE (@mxdbid > @dbid)
BEGIN
			DELETE FROM dba_admin.dbo.usage_check_audit WHERE [check_time] < getdate() - 7
			insert into dba_admin.dbo.usage_check_audit
			select @dbid, getdate() check_time, @dbname
			
	SELECT @dbname = name FROM sys.databases WHERE database_id = @dbid
		IF sys.fn_hadr_is_primary_replica (@dbname) <> 0
			BEGIN
	insert	into dba_admin.dbo.usage_check
				select 
						s.session_id
					,   getdate() TimeStamp
					,	s.database_id
					,	s.program_name
					,	s.login_name
					,	s.login_time
					,	r.plan_handle
					,	t.text
					,   p.query_plan
					,	@dbname dbname
					,	@@SERVERNAME InstanceName
					,	'SECONDARY' replica_pos
				from
					sys.dm_exec_sessions as s
						join sys.dm_exec_requests as r
				on s.session_id = r.session_id
						cross apply sys.dm_exec_sql_text (r.sql_handle) as t
						cross apply sys.dm_exec_query_plan(r.plan_handle) as p
					where s.is_user_process = 1
					and s.database_id = @dbid
			END

		IF sys.fn_hadr_is_primary_replica (@dbname) <> 1
			BEGIN
	insert	into dba_admin.dbo.usage_check
			select 
								s.session_id
							,   getdate() TimeStamp
							,	s.database_id
							,	s.program_name
							,	s.login_name
							,	s.login_time
							,	r.plan_handle
							,	t.text
							,   p.query_plan
							,	@dbname dbname
							,	@@SERVERNAME InstanceName
							,	'PRIMARY' replica_pos
				from
					sys.dm_exec_sessions as s
						join sys.dm_exec_requests as r
				on s.session_id = r.session_id
						cross apply sys.dm_exec_sql_text (r.sql_handle) as t
						cross apply sys.dm_exec_query_plan(r.plan_handle) as p
					where s.is_user_process = 1
					and s.database_id = @dbid
			END
	SET @dbid = @dbid + 1
END


/*
create table dba_admin.dbo.usage_check_audit
			(
			[dbid] int, 
			[check_time] datetime, 
			[dbname] varchar(125)
			) 

	--		drop table dba_admin.dbo.usage_check
					select 
						s.session_id
					,   getdate() TimeStamp
					,	s.database_id
					,	s.program_name
					,	s.login_name
					,	s.login_time
					,	r.plan_handle
					,	t.text
					,   p.query_plan
					,	'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC' dbname
					,	@@SERVERNAME InstanceName
					,	'SECONDARY' replica_pos
			into dba_admin.dbo.usage_check
			from
					sys.dm_exec_sessions as s
						join sys.dm_exec_requests as r
				on s.session_id = r.session_id
						cross apply sys.dm_exec_sql_text (r.sql_handle) as t
						cross apply sys.dm_exec_query_plan(r.plan_handle) as p
					where s.is_user_process = 1
DELETE from dba_admin.dbo.usage_check where dbname = 'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC'
select * from dba_admin.dbo.usage_check
select * from dba_admin.dbo.usage_check_audit
*/


