#setup loop
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes(480)
Write-Host "Start Time: $TimeStart"
write-host "End Time:   $TimeEnd"
Do { 
 $TimeNow = Get-Date
 if ($TimeNow -ge $TimeEnd) {
  Write-host "It's time to finish."
 } else {

write-host "----------------All DB's------------------"
 $array_flow1 = Invoke-Sqlcmd -query " 
SELECT [servname]
      ,[name]
      ,[state_desc]
  FROM [DBREPORTS].[dbo].[morning_Check_DB]

" -Database "DBREPORTS" -ServerInstance "NCCSQL17DBALIS"
 
 $array_flow1 | Format-Table

write-host "----------------Oracle DB's------------------"
 $array_flow2 = Invoke-Sqlcmd -query " 
SELECT [INSTANCE_NAME]
      ,[HOST_NAME]
      ,[VERSION]
      ,[STATUS]
      ,[ARCHIVER]
      ,[LOGINS]
      ,[SHUTDOWN_PENDING]
      ,[DATABASE_STATUS]
      ,[ACTIVE_STATE]
      ,[BLOCKED]
      ,[INSTANCE_MODE]
      ,[last_run]
  FROM [DBREPORTS].[dbo].[morning_Check_DB_Oracle]

" -Database "DBREPORTS" -ServerInstance "NCCSQL17DBALIS"
 
 $array_flow2 | Format-Table




write-host "----------------Problem DB's------------------"
 $array_flow = Invoke-Sqlcmd -query " 
select * from  DBREPORTS.dbo.Problem_DBS


" -Database "DBREPORTS" -ServerInstance "NCCSQL17DBALIS"
 
 $array_flow | Format-Table


    write-host "---------------- Repeat ----------------------"
 
 
 
 
 
 }
 Start-Sleep -Seconds 300
}
Until ($TimeNow -ge $TimeEnd)