--  tblGREETINGS fix.sql

-- depends on tblSessions.fix.sql
-- keeps the 'date' field but creates betternamed sessiondate field
-- renames 'time' field to 'greetingtime' 

-- version 0.3.1
--    removed redundant column 'date' in favor of renamed sessiondate

DROP TABLE IF EXISTS greetings;
--
CREATE TABLE greetings (
       session            varchar, 
       sessiondate       date,
       checked            varchar, 
       error_check         varchar, 
       typedby            varchar,  
       greetingtime         time, 
       approacher            varchar, 
       approached            varchar, 
       app_1            varchar, 
       app_2            varchar, 
       app_symmetry            varchar, 
       ll_solicitor            varchar, 
       ll_reciever            varchar, 
       ll_symmetry            varchar, 
       ll_1            varchar, 
       ll_2            varchar, 
       id1            varchar, 
       id2            varchar, 
       polyadic            varchar, 
       polyadicold            varchar, 
       id3              varchar, 
       id4              varchar, 
       id1_behav            varchar, 
       id2_behav            varchar, 
       id3_behav            varchar, 
       id4_behav            varchar, 
       ll_3                 varchar, 
       grtoccured             varchar, 
       hyenaspresent          varchar, 
       notes                  varchar, 
       greeterlist            varchar, 
       grt_1_arr_t            time, 
       grt_2_arr_t            time, 
       grt_3_arr_t            time, 
       grt_4_arr_t            time, 
       symmetry            varchar, 
       exclude            varchar, 
       context_1            varchar, 
       context_2            varchar, 
       context_3            varchar,
    FOREIGN KEY(session) REFERENCES sessions(session)
);

-- primary key?

-- add more indexes and foreign keys here

BEGIN;

INSERT INTO greetings
SELECT
    tblGreeting.session, 
    strftime('%Y-%m-%d',tblGreeting.DATE) as SESSIONDATE,
    `Checked?` as checked, 
    `Error check` as error_check, 
    typedBy, 
    strftime('%H:%M',`Time`) as greetingtime, 
    Approacher, 
    Approached, 
    App_1, 
    App_2, 
    App_symmetry, 
    LL_solicitor, 
    LL_reciever, 
    LL_symmetry, 
    LL_1, 
    LL_2, 
    ID1, 
    ID2, 
    Polyadic, 
    PolyadicOLD, 
    ID3, 
    ID4, 
    ID1_Behav, 
    ID2_Behav, 
    ID3_Behav, 
    ID4_Behav, 
    LL_3, 
    GRTOccured, 
    Hyenaspresent, 
    Notes, 
    GreeterList, 
    strftime('%H:%M',Grt_1_Arr_T) as grt_1_arr_t,  
    strftime('%H:%M',Grt_2_Arr_T) as grt_2_arr_t, 
    strftime('%H:%M',Grt_3_Arr_T) as grt_3_arr_t, 
    strftime('%H:%M',Grt_4_Arr_T) as grt_4_arr_t, 
    Symmetry, 
    Exclude, 
    Context_1, 
    Context_2, 
    Context_3
FROM tblGreeting inner join sessions on (tblGreeting.session = sessions.session) 
ORDER BY SESSIONDATE;

END TRANSACTION;

PRAGMA foreign_keys=ON;

