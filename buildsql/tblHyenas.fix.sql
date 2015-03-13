-- tblHyenas_fix.sql
-- post-processing of table hyenas after direct import from MS Access
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql


-- version 0.1 change date/times formats to only dates or only times, remove 'park' field

PRAGMA foreign_keys=OFF;

-- include current columns and add new columns and indexes
DROP TABLE IF EXISTS `hyenas`;

CREATE TABLE hyenas
 (
    hyena              varchar(6)   NOT NULL, 
    sampleid           integer, 
    eartag             varchar, 
    name               varchar(100), 
    previd             varchar(25), 
    sex                varchar(1), 
    ageclass           varchar, 
    status             varchar, 
    firstseen          date, 
    dengrad            date, 
    disappeared        date, 
    mom                varchar(6), 
    birthdate          date, 
    numberlittermates  integer, 
    litrank            integer, 
    arrivedden         date, 
    leaveden           date, 
    fate               varchar, 
    mortalitysource    varchar, 
    deathdate          date, 
    weaned             date, 
    clan               varchar, 
    miscnotes          text,     
    PRIMARY KEY("hyena")
);


-- add more indexes and foreign keys here

INSERT INTO hyenas
SELECT
    ID as hyena, 
    sampleID, 
    eartag, 
    Name, 
    PrevID, 
    Sex, 
    AgeClass, 
    Status, 
    strftime('%Y-%m-%d',FirstSeen) as `firstseen`, 
    strftime('%Y-%m-%d',DenGrad) as `dengrad`, 
    strftime('%Y-%m-%d',Disappeared) as `disappeared`, 
    Mom, 
    strftime('%Y-%m-%d',Birthdate) as `birthdate`, 
    NumberLittermates, 
    Litrank, 
    strftime('%Y-%m-%d',ArrivedDen) as `arrivedden`, 
    strftime('%Y-%m-%d',LeaveDen) as `leaveden`, 
    Fate, 
    MortalitySource, 
    strftime('%Y-%m-%d',DeathDate) as `deathdate`, 
    strftime('%Y-%m-%d',Weaned) as `weaned`, 
    Clan, 
    miscNotes

from tblHyenas
order by ID;

SELECT COUNT(*), " hyena rows " from hyenas;


PRAGMA foreign_keys=ON;
