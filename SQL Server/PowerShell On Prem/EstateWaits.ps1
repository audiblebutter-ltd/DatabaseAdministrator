# IMPORT INSTANCE LIST
clear
$instances1 = Import-CSV "C:\DBAChecks\instances.csv" 

#$instances1.target_name
##################################################################

# LOOP THROUGH CREATE RESULTS ARRAY
 foreach ($row in $instances1.target_name) { 

 $DatabaseWaits += Get-DbaWaitStatistic -SqlInstance $row -Threshold 100 -IncludeIgnorable | Select-Object * | ConvertTo-DbaDataTable

}

##################################################################

# FORMATING 
$DatabaseWaitsTable = $DatabaseWaits | Sort-Object -Property SignalSeconds
$DatabaseWaitsTable | Format-Table #| Sort-Object -Property WaitSeconds
##################################################################
# HOUSE KEEPING

Remove-Variable $DatabaseWaitsTable

##################################################################