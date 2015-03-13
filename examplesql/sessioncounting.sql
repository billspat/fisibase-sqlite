-- fisibase sql
-- example basic query
-- query counts number of session where a hyena occurs
 select count(*) from sessions inner join hyenaspersession on sessions.session = hyenaspersession.session where hyenaspersession.hyena="mrph";