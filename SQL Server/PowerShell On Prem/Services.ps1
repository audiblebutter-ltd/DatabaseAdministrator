$list = get-content “$:\$$$$$\MachineNames.txt”

Get-Service -Computername (Get-Content -path “$:\$$$$$\MachineNames.txt”) -Name spooler | Select-Object MachineName,Name,Displayname,Status | Sort-Object Status