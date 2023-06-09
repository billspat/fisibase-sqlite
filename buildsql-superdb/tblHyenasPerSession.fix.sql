-- tblHyenasPerSession.fix.sql
-- post-processing of table Sessions after direct import from MS Access
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql

-- version 0.1 
--      pulls data from old table but skips bad session numbers
--     change date/times formats to only dates or only times,
-- version 0.2
--      add size to varchar field
-- version 0.4
--     for allclans db, no changes needed

-- include current columns and add new columns and indexes
DROP TABLE IF EXISTS hyenaspersession;

CREATE TABLE hyenaspersession
 (
     session    VARCHAR(10), 
     hyena      VARCHAR(6), 
     fas        INTEGER,  -- boolean
     fasstart   TIME,     -- time-only datatype, instead of MS Access datatime 
     fasstop    TIME,     -- time-only datatype, instead of MS Access datatime
     fasstart2  TIME,     -- time-only datatype, instead of MS Access datatime
     fasstop2   TIME,     -- time-only datatype, instead of MS Access datatime
     feedingfas INTEGER,  -- boolean
     follow     INTEGER,  -- boolean
     tracked    INTEGER,  -- boolean       
    PRIMARY KEY(session,hyena),
    FOREIGN KEY(SESSION) REFERENCES sessions(SESSION),
    FOREIGN KEY(hyena) REFERENCES hyenas(hyena)
);

--  this inserts into new table, but skips problem records...
INSERT INTO hyenaspersession
SELECT tblHyenasPerSession.*
FROM (tblHyenasPerSession inner join tblSessions 
  on tblHyenasPerSession.session = tblSessions.session)
  inner join tblHyenas on tblHyenasPerSession.Hyena = tblHyenas.ID;

