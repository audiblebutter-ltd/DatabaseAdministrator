Copy-DbaDatabase -Source sql2014a -Destination sqlcluster -ExcludeDatabase Northwind, pubs -IncludeSupportDbs -Force -BackupRestore -SharedPath \\fileshare\sql\migration
