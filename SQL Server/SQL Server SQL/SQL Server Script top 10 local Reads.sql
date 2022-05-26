

SELECT TOP (10) total_logical_reads/execution_count AS AvgLogicalReads,
                SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
                ((CASE statement_end_offset 
                  WHEN -1 THEN DATALENGTH(st.text)
                  ELSE qs.statement_end_offset END 
                 - qs.statement_start_offset)/2) + 1) as StatementText
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY total_logical_reads/execution_count DESC;
GO
