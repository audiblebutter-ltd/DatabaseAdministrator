select 
	d.name dbname
 ,	d.state_desc
 ,  dhdrs.synchronization_health_desc
 ,  dhdrs.synchronization_state_desc
from sys.dm_hadr_database_replica_states dhdrs 
join sys.databases d on d.database_id = dhdrs.database_id 
select count(1) , synchronization_state_desc
from sys.dm_hadr_database_replica_states 
group by synchronization_state_desc
