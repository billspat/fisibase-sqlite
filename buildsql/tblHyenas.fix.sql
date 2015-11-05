-- tblHyenas_fix.sql
-- post-processing of table hyenas after direct import from MS Access
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql


-- version 0.1 change date/times formats to only dates or only times, remove 'park' field
-- version 0.2
--    added a 'region' field to this table to accommodate other databases'
--    fill with 'Narok' for the talek DB

PRAGMA foreign_keys=OFF;

-- include current columns and add new columns and indexes
DROP TABLE IF EXISTS `hyenas`;

CREATE TABLE hyenas
 (
    id                 varchar(6)   NOT NULL,   -- alias for hyena field, added for consistency
    hyena              varchar(6)   NOT NULL,   -- short name id, primary key
    sampleid           integer,                 -- if this animal has a sample_id, foreign key for sampleid table
    eartag             varchar,                 -- animals that get ear tags have numbers here
    name               varchar(100),            -- full animal name (based on lineage)
    previd             varchar(25),             -- comma list of ids, if this animal had another id previously
    sex                varchar(1),              -- m,f,u,null
    ageclass           varchar,                 -- typically not used as based on birthdate
    status             varchar,                 -- clan membership status for current clan : immigrant, resident
    firstseen          date,                    -- date the animal was first seen, usually min(Session.sessiondate) 
    dengrad            date,                    -- date of den graduation; see documentation for protocol
    disappeared        date, 
    mom                varchar(6),              -- foreign key of this table
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
    region             varchar, 
    miscnotes          text,     
    PRIMARY KEY("hyena")
);


-- add more indexes and foreign keys here

INSERT INTO hyenas
SELECT
    ID, 
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
    clan, 
    'Narok' as region,
    miscNotes

from tblHyenas
order by ID;

SELECT COUNT(*), " hyena rows " from hyenas;


PRAGMA foreign_keys=ON;
