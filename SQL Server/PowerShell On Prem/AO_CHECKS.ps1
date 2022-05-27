#Set-ExecutionPolicy Unrestricted -Scope CurrentUser
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes(480)
Write-Host "Start Time: $TimeStart"
write-host "End Time:   $TimeEnd"
Do { 
 $TimeNow = Get-Date
 if ($TimeNow -ge $TimeEnd) {
  Write-host "It's time to finish."
 } else {
 Write-Host "--------------------Total IOs?---------------------"
$stuff1 = Invoke-Sqlcmd -query "

 select [replica_server_name, name from [DBREPORTS].[dbo].[AO_status]


" -Database "DBREPORTS" -ServerInstance "XXX"

$table1 = $stuff1 | Format-Table
$table1 


# Write-Host "--------------------Failed Agent Jobs?---------------------"
#$stuff = Invoke-Sqlcmd -query "

#use DBREPORTS
#select *
#from dbo.dbagentjobs
#where Run_Status = 'Failed'
#and enabled = 1
#
#" -Database "DBREPORTS" -ServerInstance "NCCSQL17DBALIS"

#$table = $stuff | Format-Table
##write-color 
#$table
##-color yellow,Red
# write-host "---------------------------------------------------------"
 
 Write-Host "--------------------Problem AO's---------------------"
$stuff2 = Invoke-Sqlcmd -query "

select * from [DBREPORTS].[dbo].[Problem_AO]

" -Database "DBREPORTS" -ServerInstance "NCCSQL17DBALIS"

$table2 = $stuff2 | Format-Table
$table2 



 }

 Start-Sleep -Seconds 60
}
Until ($TimeNow -ge $TimeEnd)
