#!/bin/bash
ENV_FILE="/etc/sentinel/sentinel.env"
if [[ -f "$ENV_FILE" ]]; then source "$ENV_FILE"; else exit 1; fi

DISK_USED=$(df / -h | awk 'NR==2 {print $5}' | tr -d '%')
RAM_USED=$(free | awk 'NR==2 {printf "%.0f\n", (1 - $7/$2) * 100}')
CPU_USED=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.0f\n", 100 - $8}')

mkdir -p "$LOG_DIR"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [[ "$DISK_USED" -gt "$THRESHOLD_DISK" || "$RAM_USED" -gt "$THRESHOLD_RAM" || "$CPU_USED" -gt "$THRESHOLD_CPU" ]]; then
    STATUS="WARNING"
else
    STATUS="OK"
fi

LOG_LINE="[$TIMESTAMP] [STATUS: $STATUS] - CPU: ${CPU_USED}% | RAM: ${RAM_USED}% | DISK: ${DISK_USED}%"

echo "$LOG_LINE"
echo "$LOG_LINE" >> "$LOG_FILE"
