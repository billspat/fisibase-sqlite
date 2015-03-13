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
DROP INDEX IF EXISTS aggression_date_index; 
DROP INDEX IF EXISTS aggression_session_index;
DROP TABLE IF EXISTS aggressions;
--
CREATE TABLE aggressions (
    sessiondate    date,
    aggressiontime time,
    session        varchar,
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

CREATE INDEX aggression_date_index ON aggressions ("sessiondate");
CREATE INDEX aggression_session_index ON aggressions ("session");

-- add more indexes and foreign keys here

INSERT INTO aggressions
SELECT
    strftime('%Y-%m-%d',tblAggression.DATE) as SESSIONDATE,
    strftime('%H:%M',tblAggression.time)  as AGGRESSIONTIME,
    tblAggression.SESSION,
    tblAggression.AGGRESSOR,
    tblAggression.RECIP,
    tblAggression.`GROUP` AS ISGROUP,
    tblAggression.GROUPCOMP,
    tblAggression.Context,
    tblAggression.AltContext,
    tblAggression.BEHAVIOR1,
    tblAggression.BEHAVIOR2,
    tblAggression.RESPONSE1,
    tblAggression.RESPONSE2,
    tblAggression.RESPONSE3,
    tblAggression.SEQ,
    `Entered By`,
    `Double check`,
    tblAggression.notes
FROM tblAggression inner join sessions on (tblAggression.session = sessions.session) 
ORDER BY sessiondate, aggressiontime, aggressor;

SELECT COUNT(*), " aggressions rows " from aggressions;


PRAGMA foreign_keys=ON;
