SELECT * FROM sys.dm_exec_requests;	

SELECT 
		count(1) numsess	, 
		status	, 
		command	, 
		@@SERVERNAME insname 
		FROM sys.dm_exec_requests
		group by 
				status ,
				command
		union
		select
				count(1) numsess	, 
		'Total Sessions'	, 
		'Total Sessions'	, 
		'Total Sessions' insname 
		FROM sys.dm_exec_requests
