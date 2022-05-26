

Use msdb
Go

     --select * from sysmail_profile  --Step1: Varifying the new profile
     select @@serverName,* from sysmail_account --Step2: Verifying accounts
     --select * from sysmail_profileaccount where profile_id=3--Step3: To check the accounts of a profile
     --select * from sysmail_server --Step4: To display mail server details

--Enabling Database Mail


/*
GO
sp_configure 'show advanced options',1
reconfigure

--Creating a Profile
EXECUTE msdb.dbo.sysmail_add_profile_sp
@profile_name = 'SQLProfile',
@description = 'Mail Service for SQL Server' ;

-- Create a Mail account 
EXECUTE msdb.dbo.sysmail_add_account_sp
@account_name = 'SQLAlerts',
@email_address = 'SQLAlerts@NottinghamCity.gov.uk',
@mailserver_name = 'resexhtsw2k31.nottinghamcity.gov.uk',
@port=25,
@enable_ssl=0,
--@username='',
--@password=''

-- Adding the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = 'SQLProfile',
@account_name = 'SQLAlerts',
@sequence_number =1 ;


-- Granting access to the profile to the DatabaseMailUserRole of MSDB
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
@profile_name = 'SQLProfile',
@principal_id = 0,
@is_default = 1 ;


--Sending Test Mail
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQLProfile',
@recipients = 'SQLAlerts@NottinghamCity.gov.uk',
@body = 'Database Mail Testing...',
@subject = 'Databas Mail from SQL Server';


--Verifying, check status column
select * from sysmail_allitems 
*/
