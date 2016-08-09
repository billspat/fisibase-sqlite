-- tblPreyDensity_fix.sql
-- version 0.1 
--     imports the table and adds preylevel +1 when > avg or -1 when < agg
--     potentially remove preylevel as not using it yet


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

