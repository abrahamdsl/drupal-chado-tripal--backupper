#!/bin/bash

#
# a.llave@irri.org 01JUL2013-0936
#
# Parameters needed.
# $1 -  filename of the .tar.gz file containing the /var/www files
# 	should be relative
#
# Variable declarations, early
WWW_GROUP=www-data;

# PARAMETER CHECKS
if [ "$1" == "" ]; then
	echo "[error] First parameter should not be blank, expected string filename.";
	exit 1;
fi
if [ "$2" == "" ]; then
        echo "[error] Second parameter should not be blank, expected string, name of the owner of www";
        exit 1;
fi
if [ "$3" != ""] ; then
		WWW_GROUP=$3;
fi

# Variable declarations
#ORIG_WORKING_DIR=$(pwd);
DESIRED_USER=root;
CURRENT_USER=`whoami`;

echo "[info] `date` : File restoration script called. Checks first...";

# because not all files might be backed up if not root
if [ "$DESIRED_USER" != "$CURRENT_USER" ]; then
        echo "[warning] `date` : Current user is '$CURRENT_USER'. It is suggested that you run this as superuser or root";
        echo "                    Sleeping for 15 seconds so you can read the notice.";
        sleep 15;
fi

if [ ! -e $1 ]; then
	echo "[error] `date` : File $1 not found.";
	exit 3;
fi

echo "[info] `date` : Checks passed. Deleting files ...";
rm -r /var/www/*.*
rm -r /var/www/*

echo "[info] `date` : Extracting ...";
tar --same-owner --directory=/var/www -xzpvf $1
if [ "$?" != "0" ]; then
	"[warning] `date` : Extraction did not return zero - something might have gone wrong. Please check.";
fi
chown $2 /var/www
if [ "$?" != "0" ]; then
	"[warning] `date` : Unable to successfully change ownership of /var/www to '$2' . Please verify and do necessary actions yourself.";
fi
chgrp $WWW_GROUP /var/www
if [ "$?" != "0" ]; then
	"[warning] `date` : Unable to successfully change group of /var/www to '$WWW_GROUP' . Please verify and do necessary actions yourself.";
fi
echo "[info] `date` : File backup script finsihed. ";
exit 0;
