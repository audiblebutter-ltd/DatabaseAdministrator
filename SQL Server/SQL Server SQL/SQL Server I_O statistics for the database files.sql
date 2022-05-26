---********************************* database usage
-- Task 10 - View I/O statistics for the database files
SELECT DB_NAME(fs.database_id) AS DatabaseName,
       mf.name AS FileName,
       mf.type_desc,
       fs.*
FROM sys.dm_io_virtual_file_stats(NULL,NULL) AS fs
INNER JOIN sys.master_files AS mf
ON fs.database_id = mf.database_id
AND fs.file_id = mf.file_id
ORDER BY fs.database_id, fs.file_id DESC;
GO
	
