-- tblPreyCensus.sql
-- create table for current prey census excel file (saved as tab delim)
-- and import text file ; text file hard coded and needs to be replaced here
-- then create a simplified table of just totals and proper dates
-- this can be used with a command in the buildsqlite.sh file as 
-- sqlite3 "$sqlitefile" < $SQLDIR/tblPreyCensus.sql
-- OR something like (replace name of database file )
-- sqlite3 mydb.sqlite < buildsql/tblPreyCensus.sql 
-- from the terminal

-- version 0.1 March 2016
-- June 2016
-- preyDensity is a table in MS Access database version so this is no longer used
-- kept for referennce only


drop table if exists tblPreyCensus;

CREATE TABLE tblPreyCensus(
    Park       varchar,
    Transect    varchar,
    Day         integer,
    Month       integer,
    Year        integer,
    ActualDate  varchar,
    BiMonth     integer,
    TimeStart   varchar, -- non standard time, no colon
    TimeEnd     varchar, -- non standard time, no colon
    Thomsons    integer,
    Impala      integer,
    Zebra       integer,
    Gnu         integer,
    Topi        integer,
    Warthog     integer,
    Hartebeast  integer,
    Grants      integer,
    Buffalo     integer,
    Hippo       integer,
    Giraffe     integer,
    Ostrich     integer,
    Eland       integer,
    Elephant    integer,
    Oribi       integer,
    Reedbuck    integer,
    Waterbuck   integer,
    Baboons     integer,
    Bushbuck    integer,
    Other       integer,
    Comments    text,
    TotalPrey   integer,
    AvgPrey     real,
    Distance    real
    );


.separator "\t"
.headers on 

-- rename file here when new data arrives  
.import "db/Prey2013.txt" tblPreyCensus

-- don't know why, but it imports the header as a row
-- delete that
DELETE from tblPreyCensus where Transect='Transect';

-- create new table
drop table if exists preytransects;

CREATE TABLE preytransects (
    park        varchar,
    transect    varchar,
    censusdate  date,
    bimonth     integer,
    startdate   date,
    stopdate    date,
    status      varchar,
    totalprey   integer 
);

INSERT INTO preytransects
SELECT 
    rtrim(PARK) as park,
    rtrim(TRANSECT) as transect, 
    printf("%4d-%02d-%02d", YEAR, MONTH, DAY) as censusdate,
    BiMonth     integer,
    printf("%4d-%02d-%02d", YEAR, MONTH, ((BIMONTH-1)*14) + 1) as startdate,
    date(printf("%4d-%02d-%02d", YEAR, MONTH, 1), '+1 month', '-1 day') as enddate,
    NULL as status,
    TotalPrey as totalprey
FROM tblPreyCensus;

select count(*) as preyTransectRows from preytransects;

DROP VIEW IF EXISTS avgprey;

CREATE VIEW avgprey AS
SELECT 
    park, 
    round(avg(totalprey),1) as avgprey 
FROM preytransects 
GROUP BY park;

