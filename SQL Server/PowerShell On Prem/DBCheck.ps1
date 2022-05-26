Function CheckDbs
{
# IMPORT INSTANCE LIST

clear
$instances1 = Import-CSV "C:\DBAChecks\instances.csv" 

#$instances1.target_name
##################################################################

# LOOP THROUGH CREATE RESULTS ARRAY
 foreach ($row in $instances1.target_name) { 
        $DatabaseStates +=   Get-DbadbState -SqlInstance $row
            }


##################################################################

# FORMATING 
$DatabaseStates | Format-Table |
  Where-Object {$_.StartMode -ne 'Disabled'}

 
######################################################################
# HOUSE KEEPING

Remove-Variable instances1
Remove-Variable DatabaseStates
##################################################################REPEAT

}

Set-ExecutionPolicy Unrestricted -Scope CurrentUser
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes(480)
Write-Host "Start Time: $TimeStart"
write-host "End Time:   $TimeEnd"
Do { 
 $TimeNow = Get-Date
 if ($TimeNow -ge $TimeEnd) {
  Write-host "It's time to finish."
 } else {
# CREATE FUNCTION



CheckDbs




#Disabled 

 }
 Start-Sleep -Seconds 150
}
Until ($TimeNow -ge $TimeEnd)
