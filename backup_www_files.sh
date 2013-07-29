#!/bin/bash

#
# a.llave@irri.org 01JUL2013-0936
#
# Parameters needed.
# $1 - backup number
# $2 - string that describes what this backup is about
#
# the .tar.gz is automatically appended.

# PARAMETER CHECKS
if [ "$1" == "" ]; then
	echo "[error] First parameter should not be blank, expected integer.";
	exit 1;
fi
if ! [[ "$1" =~ ^[0-9]+$ ]] ; then
   	echo "[error] First parameter not a number";
	exit 1;
fi
if [ "$2" == "" ]; then
        echo "[error] Second parameter should not be blank, expected string describing backup.";
        exit 1;
fi

# Variable declarations
RETVAL=0
DESIRED_USER=root;
CURRENT_USER=`whoami`;
ORIG_WORKING_DIR=$(pwd);

echo "[info] `date` : File backup script called. Running checks...";

# because not all files might be backed up if not root
if [ "$DESIRED_USER" != "$CURRENT_USER" ]; then
        echo "[warning] `date` : Current user is '$CURRENT_USER'. It is suggested that you run this as superuser or root so as to avoid any file from not being backed up.";
	echo "			  Sleeping for 15 seconds so you can read the notice.";
	sleep 15;
fi

echo "[info] `date` : Now compressing ...";
cd /var/www

# the dereference param is present because, the .htaccess file is a softlink to /data/var/www/.htaccess
tar --dereference --same-owner -czpf $ORIG_WORKING_DIR/$1_$2_var-www.tar.gz ./
if [ "$?" != "0" ]; then
	echo "[warning] `date` : Creation of backup to archive might not have been so successful. Please check yourself.";
	RETVAL=5;
fi

echo "[info] `date` : File backup script finsihed. ";
exit $RETVAL;
