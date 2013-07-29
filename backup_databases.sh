#!/bin/bash

#
# a.llave@irri.org 01JUL2013-0936
#
# Parameters needed.
# $1 - backup number
# $2 - string that describes what this backup is about
#
# The .sql extension is automatically appended.

# PARAMETER CHECKS
if [ "$1" == "" ]; then
	echo "[error] First parameter should not be blank, expected integer.";
	exit 1;
fi
if ! [[ "$1" =~ ^[0-9]+$ ]] ; then
   	echo "[error] First parameter not a number.";
	exit 1;
fi
if [ "$2" == "" ]; then
        echo "[error] Second parameter should not be blank, expected string describing backup.";
        exit 1;
fi

# Variable declarations
PGUSER=your_postgresql_useraccount_name
export PGPASSWORD=your_postgresql_useraccount_password
NUM=$1
DRUPAL_DUMP_FILE="$1_$2_db--drupal.sql";
#CHADO_DUMP_FILE="$1_$2_db--chado.sql";



echo "[info] `date` : Database dumping script called.";
echo "[info] `date` : Dumping database 'drupal' to $DRUPAL_DUMP_FILE ...";

pg_dump drupal --host=localhost --username=$PGUSER --no-password > $DRUPAL_DUMP_FILE

#echo "[info] `date` : Dumping database 'chado' to $CHADO_DUMP_FILE ...";

#pg_dump chado --username=$PGUSER --no-password > $CHADO_DUMP_FILE 

echo "[info] `date` : Database dumping script finished.";

