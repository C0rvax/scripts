#!/bin/bash

PORT=49

ID=/home/c0rvax
DEST_ID=c0rvax@192.168.1.6

SRC_DIR=(
	"$ID/Documents"
	"$ID/Code"
	"$ID/scripts"
)

DEST_DIR=NetBackup/

BACKUP_DIR=save/$(date +%Y-%m-%d)

LOG_DIR=$ID/log
LOG_TXT=$LOG_DIR/synchro_NAS.txt

OPTS="--delete -av --backup --backup-dir=$BACKUP_DIR --suffix=$(date +_%Y-%m-%d)"

if [ ! -d "$LOG_DIR" ]; then
	mkdir -p "$LOG_DIR"
	sudo chmod 777 $LOD_DIR
fi

echo "     -------------------------------------     " >>$LOG_TXT
echo >>$LOG_TXT
echo $(date +%d-%m-%Y) >>$LOG_TXT
for DIR in "${SRC_DIR[@]}"; do
	rsync -e "ssh -p $PORT" $OPTS ${DIR} $DEST_ID::$DEST_DIR >>$LOG_TXT 2>&1
done
echo "     -------------------------------------     " >>$LOG_TXT
