-- tblLocationsPerSessionfix.sql
-- post-processing of table LocationsPerSession after direct import from MS Access
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql 
-- this is done automatically by the shell script buildsqlite.sh

-- version 0.1 
--     quick hack to change table name and fields using select statement.  needs to be developed

PRAGMA foreign_keys=OFF;

-- include current columns and add new columns and indexes
BEGIN;

DROP TABLE IF EXISTS `locationspersession`;
--
-- CREATE TABLE locationspersession from select *
--  PRIMARY KEY("session", "time")
-- );
    
CREATE TABLE locationspersession AS 
SELECT 
    session,
    strftime('%H:%M',tblLocationspersession.time) as `locationtime`,
    utme,
    utmn,
    direction,
    landmarkid
from tblLocationspersession;


-- CREATE INDEX date_index ON sessions ("date"); --should not be using 'date' field, compatibility
CREATE INDEX idx_locationspersessiontime ON locationspersession ("session", "locationtime");

END TRANSACTION;

SELECT COUNT(*), " locationsPersession rows " from locationspersession;

-- should check that no orphans from sessions are in this table after insert
-- else this will blow up
PRAGMA foreign_keys=ON;
