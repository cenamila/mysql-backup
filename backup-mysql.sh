#!/bin/sh
#
DIR=/volume1/DB/backup/
DATESTAMP=$(date +%Y%m%d%)
DB_USER=mcdowellappuser
DB_PASS=colombo99
DB_HOST=10.100.100.29
DB_NAME=mcdowell
 
# create backup dir if it does not exist
mkdir -p ${DIR}
 
# remove backups older than $DAYS_KEEP
#DAYS_KEEP=30
#find ${DIR}* -mtime +$DAYS_KEEP -exec rm -f {} \; 2&gt; /dev/null
 
# remove all backups except the $KEEP latest
KEEP=5
BACKUPS=`find ${DIR} -name "mysqldump-*.sql" | wc -l | sed 's/\ //g'`
while [ $BACKUPS -ge $KEEP ]
do
  ls -tr1 ${DIR}mysqldump-*.sql | head -n 1 | xargs rm -f
  BACKUPS=`expr $BACKUPS - 1`
done
 
#
# create backups securely
#umask 006
 
# dump all the databases in a file
FILENAME=${DIR}mysqldump-${DATESTAMP}.sql
mysqldump --user=$DB_USER --password=$DB_PASS --host=$DB_HOST --opt $DB_NAME --routines --triggers --events --ignore-table=$DB_NAME.nppesdata > $FILENAME
