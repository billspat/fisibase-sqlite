--  tblGREETINGS fix.sql

-- depends on tblSessions.fix.sql
-- keeps the 'date' field but creates betternamed sessiondate field
-- renames 'time' field to 'greetingtime' 

-- version 0.4
-- remove all the useless columns per Julie Turner's edits
-- version 0.3.1
--    removed redundant column 'date' in favor of renamed sessiondate



DROP TABLE IF EXISTS greetings;
--
CREATE TABLE greetings (
       session            varchar, 
       sessiondate       date,
       grtTime         time, 
       approacher            varchar, 
       approached            varchar, 
       app_symmetry            varchar, 
       ll_solicitor            varchar, 
       ll_reciever            varchar, 
       ll_symmetry            varchar, 
       ll_1            varchar, 
       ll_2            varchar, 
       id1            varchar, 
       id2            varchar, 
       polyadic            varchar, 
       id1_behav            varchar, 
       id2_behav            varchar, 
       grtoccured             varchar, 
       notes                  varchar, 
       grt_1_arr_t            time, 
       grt_2_arr_t            time, 
    FOREIGN KEY(session) REFERENCES sessions(session)
);

-- primary key?

-- add more indexes and foreign keys here

BEGIN;

INSERT INTO greetings
SELECT
    tblGreetings.session, 
    strftime('%Y-%m-%d',tblGreetings.DATE) as SESSIONDATE, 
    strftime('%H:%M',`grtTime`) as grtTime, 
    Approacher, 
    Approached, 
    App_symmetry, 
    LL_solicitor, 
    LL_reciever, 
    LL_symmetry, 
    LL_1, 
    LL_2, 
    ID1, 
    ID2, 
    Polyadic, 
    ID1_Behav, 
    ID2_Behav, 
    GRTOccured, 
    Notes, 
    strftime('%H:%M',Grt_1_Arr_T) as grt_1_arr_t,  
    strftime('%H:%M',Grt_2_Arr_T) as grt_2_arr_t 
FROM tblGreetings inner join sessions on (tblGreetings.session = sessions.session) 
ORDER BY SESSIONDATE;

END TRANSACTION;

PRAGMA foreign_keys=ON;

