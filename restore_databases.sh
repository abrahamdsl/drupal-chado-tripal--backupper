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
PGUSER=<your pguser here>
export PGPASSWORD=<your ppgpassword here>
NUM=$1
DRUPAL_DUMP_FILE="$1_db--drupal.sql";
THIS_SCRIPT_DIR=${0%/*}/;
IS_TARBALL=0;

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
        
        if [ -e "$DRUPAL_DUMP_FILE.tar.gz" ]; then
          echo "[info] File found is compressed. ";
          DRUPAL_DUMP_FILE="$DRUPAL_DUMP_FILE.tar.gz"
          IS_TARBALL=1
        else
	  echo "[error] `date`: Cannot find file : $DRUPAL_DUMP_FILE";
          exit 3;
        fi
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
#echo $PGPASSWORD;
if [ $IS_TARBALL == 1 ]; then
  psql drupal --host=localhost --username=$PGUSER --no-password < `tar -O -xzvpf $DRUPAL_DUMP_FILE`
else
  psql drupal --host=localhost --username=$PGUSER --no-password < $DRUPAL_DUMP_FILE
fi

if [ "$?" != "0" ]; then
	echo "[error] `date` : Error restoring from dump. Please check appropriate files and settings.";
        if [ $IS_TARBALL == 1]; then
          echo "[notice] `date` : If the message is about memory allocation errors, please try submitting an extracted SQL file instead of a compressed one, say, a tarball. ";
        fi
	exit 1;
else
  # Successful, execute any post...
  psql drupal -c 'ALTER USER drupal SET search_path = chado,public,so,frange,genetic_code;' --host=localhost --username=$PGUSER --no-password
fi


echo "[info] `date` : Database dump restoration script finished.";
exit 0;
