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

DROP TABLE IF EXISTS `landmarks`;

    
CREATE TABLE landmarks AS 
SELECT
	 "landmarkid", 
	 "name" ,
	 "name_alternates",
	 "category",
	 "abbrv" ,
	 "abbrv_alternates" ,
	 "description",
	 tblLandmarks."date" as date_added,
	 "territory",
	 "utme",
	 "utmn",
	 "source"   
     from tblLandmarks;


CREATE INDEX idx_landmarks ON landmarks ("landmarkid");

END TRANSACTION;

-- should check that no orphans from sessions are in this table after insert
-- else this will blow up
PRAGMA foreign_keys=ON;

