-- fisibase sqlite
-- example sql 'query'
-- for each 'sex' in hyenas table, count number of m, f born in any natal clan
-- includes animals with no gender entered (cubs died before id)
 select sex,count(*) as n from tblHyenas where mom is not null group by sex;