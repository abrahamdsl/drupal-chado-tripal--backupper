#!/bin/bash

# exit 0; # test purposes

#sudo su - postgres
dropdb chado;
createdb chado -O ubuntu;

if [ "$?" != "0" ]; then
	echo "[error] `date` : Error when dropping and recreating database 'chado'. Cannot proceed.";
	exit 1;
fi

dropdb drupal;
createdb drupal -O drupal;
#exit

if [ "$?" != "0" ]; then
	echo "[error] `date` : Error when dropping and recreating database 'drupal'. Cannot proceed.";
	exit 1;
fi
