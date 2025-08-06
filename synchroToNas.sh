#!/bin/bash

CONFIG_FILE="${1:-$HOME/secrets/babel.conf}"

if [ ! -f "$CONFIG_FILE" ]; then
	echo "Configuration file not found: $CONFIG_FILE"
	echo "Please create a configuration file with the necessary variables."
	echo ""
	echo "Example content:"
	echo '
# --- Configuration file babel.conf ---

# Username for the local machine
LOCAL_USER="localuser"

# Username for remote server
REMOTE_USER="myuser"

# Hostname or IP address of the remote server
REMOTE_HOST="192.168.1.113"

# SSH port for the remote server
SSH_PORT="22"

# Local source directory to backup
LOCAL_SOURCE_DIRS=("$HOME/Documents" "$HOME/Pictures")

# Destination directory on the remote server
REMOTE_DEST_DIR="Save/"

# Log directory for the backup process
LOG_DIR="$HOME_DIR/log"

LOG_FILE="$LOG_DIR/synchroToNas.log"
'
	exit 1
fi

source $CONFIG_FILE

if [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_HOST" ] || [ -z "$SSH_PORT" ] || [ ${#LOCAL_SOURCE_DIRS[@]} -eq 0 ] || [ -z "$REMOTE_DEST_DIR" ] || [ -z "$LOG_DIR" ] || [ -z "$LOG_FILE" ] || [ -z "$LOCAL_USER" ]; then
	echo "One or more configuration variables are not set. Please check your configuration file."
	exit 1
fi

HOME_DIR="/home/$LOCAL_USER"
REMOTE_BACKUP_DIR="save/$(date +%Y-%m-%d-%H)"

if [ ! -d "$LOG_DIR" ]; then
	mkdir -p "$LOG_DIR"
	sudo chown $LOCAL_USER:$LOCAL_USER $LOG_DIR
	sudo chmod 750 $LOG_DIR
fi

touch "$LOG_FILE"
sudo chown $LOCAL_USER:$LOCAL_USER $LOG_FILE
sudo chmod 640 $LOG_FILE

RSYNC_OPTS="--delete -av --backup --backup-dir=$REMOTE_BACKUP_DIR"

echo "---------------------------------------------------" >>"$LOG_FILE"
echo "Starting backup..." >>"$LOG_FILE"
echo "	Source		: ${LOCAL_SOURCE_DIRS[@]}" >>"$LOG_FILE"
echo "	Destination	: $REMOTE_USER@$REMOTE_HOST::$REMOTE_DEST_DIR" >>"$LOG_FILE"
echo "	SSH Port	: $SSH_PORT" >>"$LOG_FILE"
echo "	Backup Dir	: $REMOTE_BACKUP_DIR" >>"$LOG_FILE"
echo "	Log File	: $LOG_FILE" >>"$LOG_FILE"
echo "---------------------------------------------------" >>"$LOG_FILE"

for SRC_DIR in "${LOCAL_SOURCE_DIRS[@]}"; do
	if [ ! -d "$SRC_DIR" ]; then
		echo "Source directory does not exist: $SRC_DIR" >>"$LOG_FILE"
		continue
	fi

	echo "Backing up $SRC_DIR..." >>"$LOG_FILE"
	rsync -e "ssh -p $SSH_PORT" $RSYNC_OPTS "$SRC_DIR" "$REMOTE_USER@$REMOTE_HOST::$REMOTE_DEST_DIR" >>"$LOG_FILE" 2>&1

	if [ $? -eq 0 ]; then
		echo "✅ Backup of $SRC_DIR completed successfully." >>"$LOG_FILE"
	else
		echo "❌ Error occurred while backing up $SRC_DIR." >>"$LOG_FILE"
	fi
	echo "" >>"$LOG_FILE"
	echo "---------------------------------------------------" >>"$LOG_FILE"
	echo ""
done
