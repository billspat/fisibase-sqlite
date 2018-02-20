-- aggressions_import.sql
-- import aggressions data from an Excel file provide by Eli S
-- REQUIRES PRESENCE OF NAMED TEXT DATA FILE (AS WRITTEN IN IMPORT STATEMENT BELOW)
-- THIS TEXT DATA FILE IS NOT INCLUDED IN THE GIT REPOSITORY
-- see instructions for converting excel file
-- the excel file used may have been changed from Original (or new version may have been change)
-- the data is only up to 2013 and missing  the `aggressiontime` field
-- it requires the CSV file to be formatted with column order exactly as the table below is created
-- I modified the excel file from Eli to match this table. 
-- column order: 
-- clan session aggressor recip group groupcomp context altcontext behavior1 behavior2 response1 response2 response3 seq entered.by notes

-- remove column 'sessiondate' or date ; this will come from sessions
-- even though, historically, the 'date' column in aggression table doesn't always match sessions
-- After exporting from Excel, you must 


PRAGMA foreign_keys=OFF;
--
-- -- include current columns and add new columns and indexes
DROP INDEX IF EXISTS aggression_date_index; 
DROP INDEX IF EXISTS aggression_session_index;
DROP TABLE IF EXISTS aggressions;
--
CREATE TABLE aggressions (
    clan           varchar,
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
    notes          varchar,
    FOREIGN KEY(session) REFERENCES sessions(session)    
);

-- to do: create foreign keys to table hyenas for aggressor recip?

-- NEED TO WRITE A SHELL SCRIPT TO CONVERT THE FORMAT OF THE EXCEL EXPORT FILE
-- excelcsv=allAggressions_EDS.txt   # filename of the excel export , use Tab delimited
-- after exporting from Mac Excel to tab delimited, convert the stupid excel csv formatting 
-- this is Mac version of iconv, linux versions may be have diff syntax
-- SHELL SCRIPT FRAGEMENT
-- excelcsv=allAggressions_EDS.txt   # filename of the excel export , use Tab delimited
-- iconv -f "ISO-8859-1" -t "UTF-8" $excelcsv -o temp1.csv
-- tr '\r' '\n' < temp1.csv > $excelcsv 

-- no semicolons here
.mode tabs
.headers on
.import ../db/allAggressions.txt aggressions

-- SO the data above doesn't have a date, and it shouldn't.  That should come from sessions
-- in the last time I created the import txt file, I removed the data
-- so lets add sessiondate because it's really convenient to have for builder code
-- and builder code assumes aggressions.sessiondate is present

ALTER TABLE aggressions ADD COLUMN sessiondate date;

-- insert sessiondates from the sessions table

UPDATE aggressions SET sessiondate = 
    (select sessions.sessiondate 
     from sessions
     where aggressions.session = sessions.session
    );

-- add indexes and foreign keys here
CREATE INDEX aggression_session_index ON aggressions ("session");
CREATE INDEX aggression_aggressor_index ON aggressions ("aggressor");

PRAGMA foreign_keys=ON;


