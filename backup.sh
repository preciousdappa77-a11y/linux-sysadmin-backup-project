#!/bin/bash
#
# backup.sh — Automated backup script with logging and failure alerts
# Part of a Linux sysadmin learning project: filesystem, CLI, permissions,
# shell scripting, cron, package management, and log monitoring.

SOURCE_DIR="$HOME/backup-project"
BACKUP_DIR="$HOME/backups"
LOG_FILE="$HOME/backup-project/logs/cron.log"
DATE=$(date +%F_%H-%M-%S)
BACKUP_NAME="backup_$DATE.tar.gz"
EMAIL="your@email.com"   # <-- change this to your real address

mkdir -p "$BACKUP_DIR"

echo "[$DATE] Starting backup..." >> "$LOG_FILE"

if [ -d "$SOURCE_DIR" ]; then
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" --exclude="$BACKUP_DIR" "$SOURCE_DIR"
    if [ $? -eq 0 ]; then
        echo "[$DATE] SUCCESS: $BACKUP_NAME created" >> "$LOG_FILE"
    else
        echo "[$DATE] FAILURE: tar command failed" >> "$LOG_FILE"
        echo "Backup FAILED on $(hostname) at $DATE" | mail -s "Backup Alert: FAILURE" "$EMAIL"
    fi
else
    echo "[$DATE] ERROR: Source directory not found" >> "$LOG_FILE"
    echo "Backup FAILED - source missing on $(hostname) at $DATE" | mail -s "Backup Alert: FAILURE" "$EMAIL"
fi
