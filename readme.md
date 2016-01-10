fisibase-sqlite
===============

There are scripts in this folder that can convert an existing MS-Access formatted database into a SQLite format database file.  SQLite database can be used on any computer and with R or other systems.  However the programs here are designed to work on Mac or Linux systems and tailored for use on Mac.   Once these programs are run, the resulting SQLite file can be used anywhere.  

Note that one could use a commercial app/ program like http://eggerapps.at/mdbviewer for mac, or various sqlite editors for windows that can export from MDB to SQLite.  From this  Then run the X.fix.sql against sqlite.  These scripts depend on mdb-tools open source unix program that can read MDB format.  These tools are based on the command line and must be installed by the command line (see below)

This folder also includes simple R code for connecting and querying a SQLite file. 

*For each table listed in the script fisibase_build.sh, the script runs three steps:*
    
1. uses mdb-tools to export tables structure and data from an Access MDB file in form of SQL code, to create tables and insert the data. 
2. runs these command on the SQLite file to build tables and insert data exactly as is
3. looks for and runs any 'fix up' SQL script to change field names, convert date/time other format fixes. These fix up scripts are named for the table they work on e.g. tblGreeting.fix.sql   These scripts typically create a new, renamed table (from tblAggression to simply 'aggressions.') and the leave the existing table as it came over from the mdb file for 'backward compatiblity' with old queries.  Some fields need renaming as they use SQL reserved words like 'group' and 'time'


*Instructions for Mac:*

1. install the unix/mac mdb-tools.  One easy way is to first install the unix software installer called "homebrew" from http://brew.sh  The website has a terminal command for installation (requires internet connection).  Open terminal and copy and past the command at that website to install.  Then use homebrew to install mdbtools on the terminal with the following commands.   Homebrew command may tell you someting about /usr/local not being writable - it will give you a command to run to fix that.  then run 

    brew update
    brew install mdbtools

    Test this install by running the following command in the terminal 
    
    which mdb-export
    
     

2. Run the build script, specifying the name of the mdb file (accessfisi_be.mdb) and the name of the sqlitefile like this

    $ buildSQLiteFromMDB.sh <mdbfile> <sqlitefile>

   
**Historical note**: from PSB: there are other folders with versions of this  conversion script ( fisibase-r, etc) but this (fisibase-sqlite) is the main repository for fisibase conversion scripts.  It was split off into a seperate project.  

