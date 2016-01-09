-- SESSIONS with hyenas 
DROP VIEW IF EXISTS "sessions_view";

CREATE VIEW sessions_plus_view AS 
    SELECT sessions.session,  
	sessions.location, 
	sessions.sessiondate, 
	sessions.start, 
	sessions.stop, 
	sessions.unidhyenas, 
	sessions.other, 
	sessions.tracked, 
	sessions.seen, 
	sessions.pickup, 
	group_concat(hyenaspersession.hyena) AS hyenas,
    count(hyenaspersession.hyena) as identified_hyena_count,
    (strftime('%s',sessions.stop ) - strftime('%s',sessions.start) ) /60.0 
    as sessionminutes, 
	max(hyenaspersession.fas) as fas,
    "talek" as clan
FROM 
	sessions INNER JOIN hyenaspersession ON sessions.SESSION = hyenaspersession.session
WHERE  (strftime('%s',sessions.stop ) - strftime('%s',sessions.start) ) > 0
GROUP BY sessions.session
ORDER BY sessions.sessiondate, sessions.START;

-- clan list for hard-coded dates
-- mostly good for an example
-- TO DO: use shell script to insert dates related to the most recent year of sessions data

DROP VIEW IF EXISTS "example_clanlist";

CREATE VIEW "example_clanlist" AS 
SELECT distinct hyenas.hyena, hyenas.status, hyenas.sex, 
	'2011/01/01' - hyenas.birthdate as end_age, 
	count(sessions.session) as times_seen 
FROM (hyenaspersession inner join sessions 
	on hyenaspersession.session = sessions.session)
	inner join hyenas on hyenaspersession.hyena = hyenas.hyena
WHERE 
	SESSIONDATE between '2010/01/01' and '2011/01/01'
	and hyenas.clan = 'talek'
GROUP BY hyenas.hyena;