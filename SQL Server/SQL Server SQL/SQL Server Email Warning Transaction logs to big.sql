use _DBA
declare 
 @RwNu int ,
 @Server varchar(255),
 @Message varchar(3000)
 Begin
select @RwNu = count(1) 
from transaction_log_size
where logsizemb > 50000
set @Server = @@SERVERNAME
set @Message = 'This instance ' + @Server + ' has a DB with over transaction Logs in excess of 50gb'
IF @RwNu >= 1
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'NCCDBATeam',
	@recipients = 'Gareth.Winterman@nottinghamcity.gov.uk',
 	@body =  @Message,
	@subject = 'Automated Success Message' ;

end
