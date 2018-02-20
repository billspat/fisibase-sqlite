-- tblRanks_fix.sql
-- post-processing of table Ranks after direct import from MS Access
-- based on ranks from Katie/Sarah/Julie which is not official ranks table
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql

-- version 0.1 
--     changed field names and types for consistency and compatibility
-- version 0.4
--     for all clans db 
--     in old grey market db Absolute (intrasex) Rank is now just "Rank"
--     and don't know if the data is different so for compatibility with existing SNA code
--     adding new column 'rank' and also using tblRanks.rank for redundant column absintrasexrank
--     no 'sex' column in superdb table

-- "ID" TEXT,
-- "Year" DOUBLE,
-- "Clan" TEXT,
-- "Rank" DOUBLE,
-- "stdRelativeRank" DOUBLE,

-- "RankChange" TEXT

PRAGMA foreign_keys=OFF;

-- include current columns and add new columns and indexes
DROP TABLE IF EXISTS `ranks`;

CREATE TABLE `ranks` (
     "hyena" varchar,
	 "year" integer,
	 "clan" varchar,
     "rank" integer,
     "absintrasexrank" integer,
	 "stdrelativerank" REAL
);

INSERT INTO `ranks`
SELECT lower(tblRanks.ID) as hyena, 
        tblRanks.Year, 
        lower(tblRanks.Clan), 
        tblRanks.Rank,
        tblRanks.Rank as "absintrasexrank",
        tblRanks.stdRelativeRank
FROM tblRanks;

PRAGMA foreign_keys=on;


