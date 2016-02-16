-- tblRanks_fix.sql
--  WORK IN PROGRESS
-- post-processing of table Ranks after direct import from MS Access
-- based on ranks from Katie/Sarah/Julie which is not official ranks table
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql

-- version 0.1 
--     changed field names and types for consistency and compatibility

PRAGMA foreign_keys=OFF;

-- include current columns and add new columns and indexes
DROP TABLE IF EXISTS `ranks`;

PRAGMA foreign_keys=off;

BEGIN TRANSACTION;
DROP TABLE IF EXISTS ranks;

CREATE TABLE ranks (
     "hyena" varchar,
	 "year" integer,
	 "clan" varchar,
	 "absintrasexrank" integer,
	 "stdrelativerank" REAL,
	 "sex" varchar,
	 "status" varchar,
	 "notes" varchar
);

INSERT INTO ranks ( "hyena", "year", "clan", "absIntrasexRank", "stdRelativeRank", "sex", "status", "notes") 
SELECT lower(ID) as hyena, 
        "Year", 
        lower(Clan), 
        "Absolute (intrasex) Rank", 
        "stdRelativeRank",  
        "sex", 
        "status", 
        "notes" 
FROM tblRanks;

COMMIT;

PRAGMA foreign_keys=on;

SELECT COUNT(*), " rank rows " from ranks;
