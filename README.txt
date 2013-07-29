v1.0

So I have made the scripts to automate making of backups of Drupal+Chado+Tripal, database and files in /var/www
( and in essence GBrowse and JBrowse contents when using GMOD in the Cloud AMI ).

RUNNING INSTRUCTIONS

	Just run like any other shell scripts. However, you might need to edit some variables. This is
	mostly true for those that deal with databases.

BACKUP FILES NAMING CONVENTIONS
	<sequential number><underscore><string describing this backup><underscore>{ 'db--{drupal|chado}.sql' | 'var-www.tar.gz' }

Example:
	000_fresh-from-maintenance-or-reformat_var-www.tar.gz
	000_fresh-from-maintenance-or-reformat_db--drupal.sql
	000_fresh-from-maintenance-or-reformat_db--chado.sql

DESCRIPTION OF FILES

In most files, you have to specify the appropriate values for your situation. The variables are
easily found there, example `PGUSER` and `PGPASSWORD` for PostgreSQL.

backup_databases.sh
	- Usage: ./backup_databases.sh <sequential number, int> <string describing this backup, string>
	- Does not need root access.
	- Does not check if file is already existing - will be overwriten by default.
	- Will output <sequential number><underscore><string describing this backup><underscore>{ 'db--{drupal|chado}' }'.sql'
	- Does not return anything. (or default 0?)
backup_www_files.sh
	- Usage: ./backup_www_files.sh <sequential number, int> <string describing this backup, string>
	- STRONGLY RECOMMENDED that you run under sudo / have root access.
	- Changes current working directory to /var/www, then runs command tar to compress the contents and filter through GZip.
		File permissions and owner are retained. ( parameters -p and --same-owner )
		Symbolic links are followed. ( parameter --dereference)
	- Will output <sequential number><underscore><string describing this backup><underscore>'var-www.tar.gz'
	- Returns 0 or 5.
restore_databases.sh
	- Usage: ./restore_databases.sh <string describing this backup - part before `<underscore>{ 'db--{drupal|chado}' }'.sql'`, string>
		i.e.: ./restore_databases.sh 000_fresh-from-maintenance-or-reformat
		The rest is automatically appended as per our file naming conventions here.
	- NEEDS root access.
	- Returns 0-3.
restore_www_files.sh
	- Usage: ./restore_databases.sh <whole filename of the .tar.gz file containing the files - should be relative> <name of who should own /var/www> <OPTIONAL - name of the group of /var/www, default 'www-data'>
	- STRONGLY RECOMMENDED that you run under sudo / have root access.
	- Might not restore symbolic links but instead, put dereferenced files/folders.
	- Tries to change ownership and group of /var/www (not recursive), gives only textual warning when unsuccessful.
	- Returns 0,1,3.
restore_scripts/drop_and_recreate_drupal_dbs.sh
	- INTERNAL to restore_databases.sh : I don't think I need to describe it here. Anyway, you can see the file itself for details.

RETURN VALUES

0
	Success/OK/True.
1
	Program called by script returned an error.
2
	Elevation of privilege needed.
3
	File passed to/required by program not found.
4
	<vacant>
5
	Warning - operation might not be successful but in most cases okay to proceed.


FURTHER WORK
	Aside from checking existence of files needed, check too if target directory/ies are writable.

	How can we just have one file where settings are there (i.e. DB passwords), and
	then, the scripts will look at first for it and use settings specified there. If not,
	there will be defaults. Just like what "setup.ini" in most Microsoft softwares is for.

	Research on how to apply the likes of C's library function to bash - that is, how to share commonly
	used functions - i.e. checking if root, random.


