# IMPORT INSTANCE LIST
clear
$instances1 = Import-CSV "C:\DBAChecks\instances.csv" 


#Get-DbaQueryExecutionTime -EnableException -SqlInstance RHEBIW2K161\RHESQLBI01 -ExcludeSystem
#$instances1.target_name
##################################################################

##################################################################

# LOOP THROUGH CREATE RESULTS ARRAY
 foreach ($row in $instances1.target_name) { 
 $DbaQueryExecutionTime +=   Get-DbaQueryExecutionTime -EnableException -SqlInstance $row

}


##################################################################

# LOOP THROUGH CREATE RESULTS ARRAY

$DbaQueryExecutionTime | format-table
##################################################################

# HOUSE KEEPING

Remove-Variable $DbaQueryExecutionTime
Remove-Variable $instances1
##################################################################