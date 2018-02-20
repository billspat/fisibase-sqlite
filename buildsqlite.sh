#!/usr/bin/env bash
# build SQLite rom MDB shell script
# given an MDB version of fisibase, creates a SQLITE format version
# and standardizes the table 
#    eg. dates and times are datetime and stored as strings in SQLite

# runs on Linux or Mac.  May run with Unix layer in Windows.eg. mingw 
# sqlite files output will run on any platform with sqlite3
# then looks for 'fixing' sql to transform 

# turns sqlite3 journalling during db creation, and back on when finished for regular use

hash mdb-export >/dev/null 2>&1 || { echo >&2 "requires mdb-export but it doesn't appear to be installed.  \nYou can install with homebrew ( http://brew.sh ) on Mac.";  echo "After installing, use 'brew install mdbtools'"; exit 1; }

if [ "$#" -lt 1 ]; then
    echo "Please indicate which MDB file to use"
    echo "Usage: $0 input_mdbfile.msb output.sqlite optional table list"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "error - $1 file not found"
    exit 1 
fi

mdbfile=$1
# script picks default filename for sqlite file based on mdb file
sqlitefile=${2:-`basename $mdbfile .mdb`.sqlite} 

# to do : make a temporary folder to hold these files
BASEDIR=`basename $0`
TMPDIR=`mktemp -d -t ${BASEDIR}` || exit 1
echo "creating schema sql files in $TMPDIR"
SQLDIR='buildsql'


tables="tblHyenas tblSessions tblHyenasPerSession tblAggression tblDarting tblGreetings tblRanks tblLocationsPerSession tblLandmarks tblPreyDensity"
# tables to do: "tblLandmarks, tblLocationsPerSession, tblPredatorsPerSession, tblEats, tblFeeding
# tables with data in process : tblAppeasements 

# also to do: add 'region' and 'clan' to sessions table
#  merge in serena data with talek data
# LOOKUP TABLES TO DO: tlkpClans, tblLandmarks, and many others...

if [[ -e "$sqlitefile" ]]; then
    rm "$sqlitefile"
fi

# create empty db file and set journaling off while buidling
sqlite3 "$sqlitefile" ".databases"
sqlcmd="PRAGMA journal_mode=OFF;"
sqlite3 "$sqlitefile"  -cmd "$sqlcmd" < /dev/null

for table in $tables; do
    echo $table...
    
    CREATEFILE="$TMPDIR/$table.ddl.sql"
    # remove existing sql file if it exists
    # note this won't be necessary if using mktmpfile above
    if [[ -e "$CREATEFILE" ]]; then
       rm "$CREATEFILE"
    fi
 	 
    # export the SQL code to create the table from the MDB file
    mdb-schema -T $table "$mdbfile" sqlite > "$CREATEFILE"
    
    INSERTFILE="$TMPDIR/$table.insert.sql"
    if [[ -e "$INSERTFILE" ]]; then
        rm "$INSERTFILE"
    fi
    # export the sql code to insert the data from the mdb file
    # surround this file with BEGIN;...END TRANSACTION; to prevents INSERTs from going slowly
   
    echo BEGIN\; > "$INSERTFILE"
    mdb-export -D '%Y-%m-%d %H:%M:%S' -I sqlite "$mdbfile" $table >> "$INSERTFILE"
    echo END TRANSACTION\; >> "$INSERTFILE" 
     
    # create the table in the new database
    sqlite3 "$sqlitefile" < "$CREATEFILE"
    # insert the data into this new table
    sqlite3 "$sqlitefile" < "$INSERTFILE"
    
    # script feedback : tell us how many rows, 
    # to do: something like echo `sqlite select count(*) from $table` rows inserted...
        # to do: test the number of rows inserted = number of rows exported
    
    # FIXUP : run sql that makes corrections to date formats, field names, etc
    # if it exists, assume file is names like  ${table}_fix.sql
    if [[ -e "$SQLDIR/$table.fix.sql" ]]; then
        echo "running $table.fix.sql"
        # build new table based on old tblTable
        sqlite3 "$sqlitefile" < "$SQLDIR/$table.fix.sql"
        # print diagnostic msg, use table name without the 'tbl' prefix
        # ASSUMES NEW TABLE NAME IS SAME AS OLD
        sqlite3 "$sqlitefile"  -cmd "select count(*) from ${table}" < /dev/null
        # note need dev/null here else sqlite enters interactive mode
    fi
done

echo "adding views..."
sqlite3 "$sqlitefile" < "$SQLDIR/fisibase.views.sql" # need to make sure this runs from the same folder as the script...

# prey density now part of Access database, but leave this as a comment
# echo "adding prey census data"
# sqlite3 "$sqlitefile" < $SQLDIR/tblPreyCensus.sql

echo "...done"

# list all tables... 
sqlite3 "$sqlitefile" ".tables"

echo "removing old tables"
for table in $tables; do
    sqlite3 "$sqlitefile"  -cmd "drop table ${table}" < /dev/null
done

# turn journaling back on when sqlitedb is complete
sqlcmd="PRAGMA journal_mode=DELETE;"
sqlite3 "$sqlitefile"  -cmd "$sqlcmd" < /dev/null
