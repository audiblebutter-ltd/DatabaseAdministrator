--Let’s see the example on the EmployeeReports table:

CREATE TABLE EmployeeReports
(
ReportID int IDENTITY (1,1) NOT NULL,
ReportName varchar (100),
ReportNumber varchar (20),
ReportDescription varchar (max)
CONSTRAINT EReport_PK PRIMARY KEY CLUSTERED (ReportID)
)
 
DECLARE @i int
SET @i = 1
 
BEGIN TRAN
WHILE @i&lt;100000 
BEGIN
INSERT INTO EmployeeReports
(
ReportName,
ReportNumber,
ReportDescription
)
VALUES
(
'ReportName',
CONVERT (varchar (20), @i),
REPLICATE ('Report', 1000)
)
SET @i=@i+1
END
COMMIT TRAN
GO
--If we run a SQL query to pull ReportID, ReportName, ReportNumber data from the EmployeeReports table the result set that a scan count is 5 and represents a number of times that the table was accessed during the query, and that we had 113,288 logical reads that represent the total number of page accesses needed to process the query:

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT er.ReportID, er.ReportName, er.ReportNumber
FROM dbo.EmployeeReports er
WHERE er.ReportNumber LIKE '%33%'
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
--SQL query messages
--As indicated, every page is read from the data cache, whether or not it was necessary to bring that page from disk into the cache for any given read. To reduce the cost of the query we will change the SQL Server database schema and split the EmployeeReports table vertically.

--Next we’ll create the ReportsDesc table and move the large ReportDescription column, and the ReportsData table and move all data from the EmployeeReports table except the ReportDescription column:

CREATE TABLE ReportsDesc 
( ReportID int FOREIGN KEY REFERENCES EmployeeReports (ReportID),
  ReportDescription varchar(max)
  CONSTRAINT PK_ReportDesc PRIMARY KEY CLUSTERED (ReportID)
 )
 
CREATE TABLE ReportsData
(
ReportID int NOT NULL,
ReportName varchar (100),
ReportNumber varchar (20),
 
CONSTRAINT DReport_PK PRIMARY KEY CLUSTERED (ReportID)
)
INSERT INTO dbo.ReportsData
(
    ReportID,
    ReportName,
    ReportNumber
)
SELECT er.ReportID, 
er.ReportName, 
er.ReportNumber 
FROM dbo.EmployeeReports er
--The same search query will now give different results:

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT er.ReportID, er.ReportName, er.ReportNumber
FROM ReportsData er
WHERE er.ReportNumber LIKE '%33%'
SET STATISTICS IO OFF
SET STATISTICS TIME OFF