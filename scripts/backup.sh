#!/bin/bash

# ==============================================================================
# Backup script for StatusPulse PostgreSQL database
# ==============================================================================

# Configuration defaults
BACKUP_DIR="${BACKUP_DIR:-/var/backups/statuspulse}"
DB_NAME="${POSTGRES_DB:-statuspulse}"
DB_USER="${POSTGRES_USER:-statuspulse}"
DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"

# File naming
DATE=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/statuspulse_db_$DATE.sql.gz"
LOG_FILE="$BACKUP_DIR/backup.log"
RETENTION_COUNT=7

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting backup of database '$DB_NAME' to $BACKUP_FILE"

# Dump database and compress
export PGPASSWORD="${POSTGRES_PASSWORD}"
if pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"; then
    log "Backup successfully created: $BACKUP_FILE"
else
    log "ERROR: Backup failed!"
    unset PGPASSWORD
    exit 1
fi
unset PGPASSWORD

# Keep only last 7 backups (rotate older ones)
log "Rotating old backups, keeping the last $RETENTION_COUNT..."
# Find files matching the pattern, sort by modification time (newest first), skip the first 7, and delete the rest
ls -tp "$BACKUP_DIR"/statuspulse_db_*.sql.gz | grep -v '/$' | tail -n +$((RETENTION_COUNT + 1)) | xargs -I {} rm -- {}
log "Rotation complete."

# Optionally upload to S3 if $S3_BUCKET is set
if [ -n "$S3_BUCKET" ]; then
    log "Uploading backup to S3 bucket '$S3_BUCKET'..."
    if aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/"; then
        log "Successfully uploaded to S3."
    else
        log "ERROR: S3 upload failed!"
    fi
else
    log "S3_BUCKET variable not set. Skipping S3 upload."
fi

log "Backup script finished successfully."
