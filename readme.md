fisibase-sqlite
===============

There are scripts in this folder that can convert an existing MS-Access formatted database into a SQLite format database file.  SQLite database can be used on any computer and with R or other systems.  However the programs here are designed to work on Mac or Linux systems and tailored for use on Mac.   Once these programs are run, the resulting SQLite file can be used on any computer.   Windows computers will require installation of sqlite or a sqlite tool.  

This folder also includes example SQL code to demonstrate how to query the resulting database.  

Overview
---

*For each table listed in the script fisibase_build.sh, the script runs three steps:*
    
1. uses mdb-tools to export tables structure and data from an Access MDB file in form of SQL code, to create tables and insert the data. 
2. runs these command on the SQLite file to build tables and insert data exactly as is
3. looks for and runs any 'fix up' SQL script to change field names, convert date/time other format fixes. These fix up scripts are named for the table they work on e.g. tblGreeting.fix.sql   These scripts typically create a new, renamed table (from tblAggression to simply 'aggressions.') and the leave the existing table as it came over from the mdb file for 'backward compatiblity' with old queries.  Some fields need renaming as they use SQL reserved words like 'group' and 'time'

Install and Use
---

*Install Instructions for Mac:*

First you must install the open source mdb-tools software.  One easy way is to first install the software installer called "homebrew" from http://brew.sh  The website has a terminal command for installation (requires internet connection).  Open terminal and copy and paste the command at that website to install.  Then use homebrew to install mdbtools on the terminal with the following commands.   Homebrew command may tell you someting about /usr/local not being writable - it will give you a command to run to fix that.  then run 

    brew update
    brew install mdbtools

Then Test this install by running the following command in the terminal 
    
    which mdb-export

Note that 'homebrew' is useful for installing other unix-style software for development.      

*Converting the Database on Mac*

Start the the terminal, change to the directory where the fisibase-sqlite project files are

        cd to_the_project_folder


First download the code in this git repository either by downloading the zip file or if you are using git for this program, make sure you get the latest code by 

     git pull


Copy the latest version of the MS Access backend file you want.  Note that this sqlite program uses a non-standard ranks table and that must be in the database for 
this program to run, named tblRanks.   Ask Pat for details.   You can put this MDB file anywhere, but the 'db' folder of this fisibase-sqlite project is a good place. 
The MDB File is NOT Part of the git repository or this project because it's a big file. 

Now the code is updated and you have the latest MDB file, Run the buildqslite.sh script, specifying the path to the name of the mdb file (db/accessfisi_be.mdb) and the name of the resulting sqlitefile like this (in the terminal)

     ./buildsqlite.sh <path/to/mdbfile> <sqlitefile>

for example 
   
     buildsqlite.sh db/accessfisi_be_current.mdb fisibase.sqlite

* Using the SQLite File*

there are dozens of ways to open and view a sqlite file from many programming languages (R, Python, Excel, OpenOffice, etc).  The sure-fired way for rudimentary exploration is to use the sqlite3 program that comes with Mac (and linux).    Start terminal and type

sqlite3 fisibase.sqlite
then you see a sqlite3 prompt in which you can type sql commands.  Fore exmaple, type

select count(*) from sessions;

to see how many session records there are. 

You can also use the sql in teh "examplesql" folder here like this

sqlite3 fisibase.sqlite < examplesql/gendercount.sql

which pipes the sql code into sqlite3 and shows the results. 

To use a graphic program to open the sqlite file can use also use the free  http://sqlitestudio.pl/  which lets you see the tables and data and enter sql tools.   This programs runs on Mac, Windows and Linux. 

     
*Notes for Windows users:*  
 
The scripts requires a unix shell (bash) and the mdb-tools software which are unix based, so don't have a good solution for Windows to run them.   You could look into other products like http://www.sqlmaestro.com/products/sqlite/datawizard/, then run the SQL command in the 'buildsql'

You could try to install the Cygwin linux layer, or use a program like MobaXterm http://mobaxterm.mobatek.net/ and explore plugins http://mobaxterm.mobatek.net/plugins.html to provide a complete linux development environment to install.   


**Historical note**: from PSB: there are other folders with versions of this  conversion script ( fisibase-r, etc) but this (fisibase-sqlite) is the main repository for fisibase conversion scripts.  It was split off into a seperate project.  

Note that one could use a commercial app/ program like http://eggerapps.at/mdbviewer for mac, or various sqlite editors for windows that can export from MDB to SQLite.  From this  Then run the X.fix.sql against sqlite.  These scripts depend on mdb-tools open source unix program that can read MDB format.  These tools are based on the command line and must be installed by the command line (see below)

