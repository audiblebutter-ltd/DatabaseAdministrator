
SELECT session_id,
    blocking_session_id,
    start_time,
    status,
    command,
    DB_NAME(database_id) as [database],
    wait_type,
    wait_resource,
    wait_time,
    open_transaction_count, 
    plan_handle 
FROM SYS.DM_EXEC_REQUESTS
WHERE session_id > 49

 