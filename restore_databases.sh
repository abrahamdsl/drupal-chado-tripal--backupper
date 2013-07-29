#!/bin/bash

#
# a.llave@irri.org 01JUL2013-0936
#
# Parameters needed.
# $1 - filenames (before '_db--<db name>.sql')
#

# PARAMETER CHECKS
if [ "$1" == "" ]; then
	echo "[error] First parameter should not be blank, expected string.";
	exit 1;
fi

# Variable declarations
DESIRED_USER=root;
CURRENT_USER=`whoami`;
PGUSER=your_postgresql_useraccount_name
export PGPASSWORD=your_postgresql_useraccount_password
NUM=$1
DRUPAL_DUMP_FILE="$1_db--drupal.sql";
THIS_SCRIPT_DIR=${0%/*}/;

# statement start! 
echo "[info] `date` : Database dump restoration script called.";

# needed in calling out for the script to drop and recreate DBs later - so no asking for password.
if [ "$DESIRED_USER" != "$CURRENT_USER" ]; then
	echo "[error] `date` : Current user is '$CURRENT_USER'. You need to run this as superuser / root. Exiting.";
	exit 2;
fi
echo "[info] `date` : Current directory is at : ${pwd} ";
echo "[info] `date` : This script's directory is at : $THIS_SCRIPT_DIR";

#check for the dump's existence first
if [ ! -e $DRUPAL_DUMP_FILE ]; then
	echo "[error] `date`: Cannot find file : $DRUPAL_DUMP_FILE";
        exit 3;
fi
echo "[info] `date` : Will be restoring :";
echo "			(1) $DRUPAL_DUMP_FILE ";
echo "";
echo "";

echo "[info] `date` :  Dropping and recreating databases...";
sudo su -c $THIS_SCRIPT_DIR/restore_scripts/drop_and_recreate_drupal_dbs.sh -s /bin/bash postgres

if [ "$?" != "0" ]; then
	echo "[error] `date` : Error when dropping and recreating databases. Cannot proceed.";
	exit 1;
fi

echo "[info] `date` : Restoring database 'drupal' from $DRUPAL_DUMP_FILE ...";
#echo "Oops, just testing. exiting.";
#exit 0;
psql drupal --host=localhost --username=$PGUSER --no-password < $DRUPAL_DUMP_FILE
if [ "$?" != "0" ]; then
	echo "[error] `date` : Error restoring from dump. Please check appropriate files and settings.";
	exit 1;
fi


echo "[info] `date` : Database dump restoration script finished.";
exit 0;
