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
DROP TABLE IF EXISTS `preydensity`;

PRAGMA foreign_keys=off;

BEGIN TRANSACTION;

CREATE TABLE preydensity (
     "clan" varchar,
     "year" integer,
     "month" integer,
     "preydensity" real,
     "numofsd" REAL,
     "preylevel" integer

);

INSERT INTO preydensity ( "clan", "year", "month", "preydensity","numofsd","preylevel") 
SELECT lower(clan) as clan, 
        year,         
        month ,
        preydensity ,
        numofsd ,
        case when 
            numofsd >= 0 then 1 
            else -1 
        end as 'preylevel'
FROM tblPreyDensity;

COMMIT;

PRAGMA foreign_keys=on;

