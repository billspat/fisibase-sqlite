-- tblAggressions_fix.sql
-- post-processing of table Aggressions after direct import from MS Access
-- sqlite format  
-- usage:  first create sqlite database from MS Access
-- then sqlite my_database.sqlite3 < this_file.sql

--
-- version 0.1 
--    change date/times formats to only dates or only times,
--    change GROUP` to ISGROUP y/n value
--    all field names lower case

-- to do: remove redundant sessiondate field and use only session


PRAGMA foreign_keys=ON;
--
-- -- include current columns and add new columns and indexes
DROP INDEX IF EXISTS aggression_talek_date_index; 
DROP INDEX IF EXISTS aggression_talek_session_index;
DROP TABLE IF EXISTS aggressions_talek;
--
CREATE TABLE aggressions_talek (
    sessiondate    date,
    aggressiontime time,
    session        varchar,
    clan           varchar,
    aggressor      varchar,
    recip          varchar,
    isgroup        varchar,
    groupcomp      varchar,
    context        varchar,
    altcontext     varchar,
    behavior1      varchar,
    behavior2      varchar,
    response1      varchar,
    response2      varchar,
    response3      varchar,
    seq            integer,
    `entered by`   varchar,
    `double check` varchar,
    notes          varchar,
    FOREIGN KEY(session) REFERENCES sessions(session)
);

-- to do: create foreign keys to table hyenas for aggressor recip?

CREATE INDEX aggression_talek_date_index ON aggressions_talek ("sessiondate");
CREATE INDEX aggression_talek_session_index ON aggressions_talek ("session");

-- add more indexes and foreign keys here

INSERT INTO aggressions_talek
SELECT
    strftime('%Y-%m-%d',tblAggression_talek.DATE) as SESSIONDATE,
    strftime('%H:%M',tblAggression_talek.time)  as AGGRESSIONTIME,
    tblAggression_talek.SESSION,
    'talek' as clan,
    tblAggression_talek.AGGRESSOR,
    tblAggression_talek.RECIP,
    tblAggression_talek.`GROUP` AS ISGROUP,
    tblAggression_talek.GROUPCOMP,
    tblAggression_talek.Context,
    tblAggression_talek.AltContext,
    tblAggression_talek.BEHAVIOR1,
    tblAggression_talek.BEHAVIOR2,
    tblAggression_talek.RESPONSE1,
    tblAggression_talek.RESPONSE2,
    tblAggression_talek.RESPONSE3,
    tblAggression_talek.SEQ,
    `Entered By`,
    `Double check`,
    tblAggression_talek.notes
FROM tblAggression_talek inner join sessions on (tblAggression_talek.session = sessions.session) 
ORDER BY sessiondate, aggressiontime, aggressor;

PRAGMA foreign_keys=ON;


