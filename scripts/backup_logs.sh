#!/bin/bash
set -euo pipefail
ENV_FILE="/etc/sentinel/sentinel.env"
if [[ -f "$ENV_FILE" ]]; then source "$ENV_FILE"; else exit 1; fi

SRC_DIR="${SRC_DIR:-/var/log/sentinel/}"
DEST_SERVER="${DEST_SERVER:-root@172.29.71.100}"
DEST_DIR="${DEST_DIR:-/backups/server-a/}"
SSH_PORT="${SSH_PORT:-22}"
SSH_KEY="${SSH_KEY:-/root/.ssh/id_ed25519}"
LOG_FILE="${BACKUP_LOG_FILE:-/var/log/sentinel/backup.log}"
mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
	local message="$1"
	echo "[$(date "+%Y-%m-%d %H:%M:%S")] ${message}" | tee -a "${LOG_FILE}"
}

log_message "[INFO] Bat dau backup"

if [[ ! -d "$SRC_DIR" ]]; then
	log_message "[ERROR] Thu muc nguon ${SRC_DIR} khong ton tai"
	exit 1
fi

log_message "[INFO] Tao thu muc $SRC_DIR neu chua ton tai"
ssh -p "$SSH_PORT" -i "$SSH_KEY" -o BatchMode=yes -o ConnectTimeout=10 "$DEST_SERVER" "mkdir -p '$DEST_DIR'"

log_message "[INFO] Syncing file tu $SRC_DIR -> '$DEST_SERVER:$DEST_DIR'"
rsync -avzP --delete \
	-e "ssh -p $SSH_PORT -i $SSH_KEY -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no" \
	"$SRC_DIR" \
	"$DEST_SERVER:$DEST_DIR" >> "$LOG_FILE" 2>&1
log_message "[SUCCESS] Backup thanh cong"
