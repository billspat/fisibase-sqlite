-- tblSessions_fix.sql
-- post-processing of table Sessions after direct import from MS Access
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql

-- version 0.1 
--     change date/times formats to only dates or only times,
--     add a renamed 'date' column (reserved word) to sessiondate for easier queries (but leave Date intact )
--     remove 'time' and 'hyenas' fields (they can calculated easily with SQL)

-- version 0.2
--    added size limits on char fields for ODBC and MDB compatibility
--    added NOT NULL constraints (which may slow down inserts?) and additional indexes
--   UNTESTED 2/28

-- version 0.3
--    added a 'clan' and 'region' fields to this table to accommodate other databases
--    Since this is from the Talek DB, fill with 'Talek' and 'Narok'  
--    not some in the talek db are actually fig Tree, and that needs to be determined and
--    Region is not nullable and must have a character value of some kind, including 'unk'


PRAGMA foreign_keys=OFF;

-- include current columns and add new columns and indexes
DROP TABLE IF EXISTS `sessions`;

CREATE TABLE sessions (
 session     varchar(10) NOT NULL, 
 clan        varchar(25) ,
 region      varchar(25) NOT NULL, -- Narok, Amboseli, Serena
 location    varchar(2)  ,
 "date"      DateTime    NOT NULL, -- this should go away; confuse with date type name
 sessiondate date        NOT NULL, -- replaces 'date' field 
 start       time        NOT NULL, 
 stop        time        NOT NULL, 
 unidhyenas  varchar(255), -- 255 is MS Access limit for character fields 
 other       varchar(255),  
 tracked     integer     NOT NULL,  -- boolean
 seen        integer     NOT NULL,  -- boolean
 pickup      integer     , 
 entrystatus varchar(255), 
 eventnotes  varchar(255),
 PRIMARY KEY("session")
);

CREATE INDEX date_index ON sessions ("date"); --should not be using 'date' field, compatibility
CREATE INDEX idx_sessiondate ON sessions ("sessiondate");
CREATE INDEX idx_sessiondatetime ON sessions ("sessiondate","start");

BEGIN;
    
INSERT INTO sessions
SELECT 
    session, 
    "Talek" as clan,
    "Narok" as region,
    location, 
    `DATE`, 
    strftime('%Y-%m-%d',tblSessions.DATE) as sessiondate,
    strftime('%H:%M',START)            as start,
    strftime('%H:%M',STOP)             as stop,
    unidhyenas,
    other,
    tracked,
    seen,
    pickup,
    entrystatus,
    eventnotes
from tblSessions
where stop > start
order by sessiondate, start;


END TRANSACTION;

SELECT COUNT(*), " session rows " from sessions;

-- should check that no orphans from sessions are in this table after insert
-- else this will blow up
PRAGMA foreign_keys=ON;
