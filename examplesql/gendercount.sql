-- fisibase sqlite
-- example sql 'query'
-- for each 'sex' in hyenas table, count number of m, f born in any natal clan, group by clan
-- includes animals with no gender entered (cubs died before id)
 select clan,sex,count(*) as n from tblHyenas where mom is not null group by clan, sex;