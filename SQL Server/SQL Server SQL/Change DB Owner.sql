 select 'ALTER AUTHORIZATION ON DATABASE::'+name+' TO sa ' from sys.databases where  suser_sname(owner_sid) like '%LBADmin%'

