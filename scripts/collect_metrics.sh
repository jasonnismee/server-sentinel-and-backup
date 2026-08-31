#!/bin/bash

# 1. Trích xuất dữ liệu và ép về SỐ NGUYÊN để Bash so sánh được
DISK_USED=$(df / -h | awk 'NR==2 {print $5}' | tr -d '%')
RAM_USED=$(free | awk 'NR==2 {printf "%.0f\n", (1 - $7/$2) * 100}')
CPU_USED=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.0f\n", 100 - $8}')

# 2. Khai báo Ngưỡng (Thresholds)
THRESHOLD_DISK=85
THRESHOLD_RAM=90
THRESHOLD_CPU=80

LOG_FILE="$(dirname "$0")/logs/metrics.log"
mkdir -p "$(dirname "$LOG_FILE")"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [[ "$DISK_USED" -gt "$THRESHOLD_DISK" || "$RAM_USED" -gt "$THRESHOLD_RAM" || "$CPU_USED" -gt "$THRESHOLD_CPU" ]]; then
    STATUS="WARNING"
else
    STATUS="OK"
fi

LOG_LINE="[$TIMESTAMP] [STATUS: $STATUS] - CPU: ${CPU_USED}% | RAM: ${RAM_USED}% | DISK: ${DISK_USED}%"

echo "$LOG_LINE"
echo "$LOG_LINE" >> "$LOG_FILE"
