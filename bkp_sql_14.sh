#!/bin/bash
# Script to execute mysql database and compressing him by gzip. Easy to adjust on your needs - just edit some parameters like filename, or backupfolder. In belowing example files deleting after 14 days, but of course you can adjust it for your needs by change number after "-mtime". It's easy to automate executing backups by this script with cron.
now="$(date +'%d_%m_%Y_%H_%M_%S')"
filename="db_backup_$now".gz
backupfolder="/var/lib/mysql/backups/"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --user=testo --password=test1234 --default-character-set=utf8 --all-databases | gzip > "$fullpathbackupfile"
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
chown root "$fullpathbackupfile"
chown root "$logfile"
echo "file permission changed" >> "$logfile"
find "$backupfolder" -name db_backup_* -mtime +14 -exec rm {} \;
echo "old files deleted" >> "$logfile"
echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0
