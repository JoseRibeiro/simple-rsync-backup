#!/bin/bash

# Usage help.
if [[ "$1" == "" || "$2" == "" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: srbackup.sh <source dir> <target dir>"
    exit 1
fi

echo Simple rsync backup!

# Log file.
LOG="$2/srbackup.log"

# Log for present files in the target but missing in the source.
LOG_MISSING="$2/srbackup-missing.log"

date > "$LOG"
echo "" >> "$LOG"

rsync -v -a -U -X -E "$1" "$2" >> "$LOG" 2>&1

echo "Finding missing files." >> "$LOG"
echo "Missing files:" > "$LOG_MISSING"
rsync -v -a -n "$2/$(basename "$1")" "$(dirname "$1")" >> "$LOG_MISSING" 2>&1

echo "" >> "$LOG"
date >> "$LOG"

exit 0
