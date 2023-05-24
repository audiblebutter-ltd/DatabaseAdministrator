SELECT TOP 10
    s.host_name,
    s.login_name,
    r.session_id,
    r.request_id,
    r.start_time,
    t.text AS [SQL Text],
    tsu.user_objects_alloc_page_count AS [User Objects Allocated Pages],
    tsu.internal_objects_alloc_page_count AS [Internal Objects Allocated Pages],
    (tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count) AS [Total Allocated Pages]
FROM sys.dm_db_task_space_usage tsu
JOIN sys.dm_exec_requests r ON (tsu.session_id = r.session_id AND tsu.request_id = r.request_id)
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
ORDER BY (tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count) DESC;


