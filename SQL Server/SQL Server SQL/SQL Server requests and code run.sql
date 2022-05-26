SELECT s.original_login_name, s.program_name,  r.command, 
       (SELECT TOP (1) SUBSTRING(t.text, r.statement_start_offset / 2 + 1, 
			                     ((CASE WHEN r.statement_end_offset = -1 
                                   THEN (LEN(CONVERT(nvarchar(max), t.text)) * 2) 
                                   ELSE r.statement_end_offset 
                                   END)  - r.statement_start_offset) / 2 + 1)) AS SqlStatement,
       r.wait_type, r.wait_time, r.blocking_session_id
FROM sys.dm_exec_requests AS r
INNER JOIN sys.dm_exec_sessions AS s
ON r.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) AS t		
WHERE s.is_user_process = 1;
GO