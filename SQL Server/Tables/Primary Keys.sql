--The following SQL creates a PRIMARY KEY on the "ID" column when the "Persons" table is created:


CREATE TABLE Persons (
    ID int NOT NULL PRIMARY KEY,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

--To allow naming of a PRIMARY KEY constraint, and for defining a PRIMARY KEY constraint on multiple columns, use the following SQL syntax:

CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CONSTRAINT PK_Person PRIMARY KEY (ID,LastName)
);

--To create a PRIMARY KEY constraint on the "ID" column when the table is already created, use the following SQL:


ALTER TABLE Persons
ADD PRIMARY KEY (ID);
--To allow naming of a PRIMARY KEY constraint, and for defining a PRIMARY KEY constraint on multiple columns, use the following SQL syntax:


ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);
--Note: If you use ALTER TABLE to add a primary key, the primary key column(s) must have been declared to not contain NULL values (when the table was first created).

--To drop a PRIMARY KEY constraint, use the following SQL:

ALTER TABLE Persons
DROP CONSTRAINT PK_Person;