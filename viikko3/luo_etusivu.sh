#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="/home/ubuntu/viikko3/viikko3.html"
OUTPUT_DIR="/var/www/viikko3"
OUTPUT_FILE="$OUTPUT_DIR/index.html"
TEMP_FILE="$OUTPUT_DIR/index.html.tmp"
GITHUB_URL="https://github.com/Subikoira/Linux-kurssi"

get_disk_status() {
    local usage="$1"
    if [ "$usage" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

if [ ! -f "$TEMPLATE" ]; then
    echo "Template not found: $TEMPLATE" >&2
    exit 1
fi

GENERATED_AT="$(date '+%Y-%m-%d %H:%M:%S %Z (UTC%z)')"
UPTIME_TEXT="$(uptime -p)"
DISK_PERCENT="${TEST_DISK_USAGE:-$(df -P / | awk 'NR == 2 {gsub("%", "", $5); print $5}')}"
DISK_USAGE="${DISK_PERCENT}%"
DISK_STATUS="$(get_disk_status "$DISK_PERCENT")"
MEM_TOTAL="$(free -m | awk '/^Mem:/ {print $2}')"
MEM_AVAILABLE="$(free -m | awk '/^Mem:/ {print $7}')"

PAGE="$(cat "$TEMPLATE")"
PAGE="${PAGE//@@GENERATED_AT@@/$GENERATED_AT}"
PAGE="${PAGE//@@UPTIME_TEXT@@/$UPTIME_TEXT}"
PAGE="${PAGE//@@DISK_USAGE@@/$DISK_USAGE}"
PAGE="${PAGE//@@DISK_STATUS@@/$DISK_STATUS}"
PAGE="${PAGE//@@MEM_TOTAL@@/$MEM_TOTAL}"
PAGE="${PAGE//@@MEM_AVAILABLE@@/$MEM_AVAILABLE}"
PAGE="${PAGE//@@GITHUB_URL@@/$GITHUB_URL}"

printf '%s\n' "$PAGE" > "$TEMP_FILE"
chmod 644 "$TEMP_FILE"
mv "$TEMP_FILE" "$OUTPUT_FILE"
