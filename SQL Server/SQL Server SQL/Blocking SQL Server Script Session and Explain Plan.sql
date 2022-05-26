create proc block_count
AS
		select 
			count(1) blocked_sessions
			,	d.name DatabaseName
			,	getdate() check_date
		from
				master.sys.dm_exec_requests as r
		join master.sys.databases d on r.database_id = d.database_id
			where r.blocking_session_id <> 0

	group by d.name
			
--select * from master.sys.dm_exec_sessions as s
--select * from master.sys.dm_exec_requests as r

--select * from sys.dm_exec_sql_text