#!/bin/bash

# Configuration
TARGET_DIR="/var/log"
THRESHOLD_Gb=0.001
# Convert threshold to Kilobytes (1GB = 1048576 KB)
THRESHOLD_KB=$((THRESHOLD_GB * 1024 * 1024))

# 1. Get the current size of the directory in KB
# 'du -s' gives total sum, 'cut -f1' extracts just the number
CURRENT_SIZE=$(du -s "$TARGET_DIR" | cut -f1)

# 2. Compare sizes
if [ "$CURRENT_SIZE" -gt "$THRESHOLD_KB" ]; then
    MESSAGE="WARNING: $TARGET_DIR has exceeded ${THRESHOLD_GB}GB. Current size: $(du -sh $TARGET_DIR | cut -f1)"
    
    # 3. Action: Send a notification to all logged-in terminals
    echo "$MESSAGE" | wall
    
    # Optional: Log the alert to a file for history
    echo "$(date): $MESSAGE" >> /var/log/disk_usage_alerts.log
else
    # Optional: for testing, you can uncomment the next line
    # echo "Storage is within limits."
    exit 0
fi
