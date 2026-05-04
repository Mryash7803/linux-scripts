#!/bin/bash

# Configuration
THRESHOLD=80
LOGFILE="/var/log/sys_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 1. Check Disk Usage on the root partition
# 'df /' gets disk info, 'awk' grabs the percentage, 'sed' removes the % sign
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "$TIMESTAMP [ALERT] Disk usage is CRITICAL at $USAGE%" >> $LOGFILE
else
    echo "$TIMESTAMP [OK] Disk usage is healthy at $USAGE%" >> $LOGFILE
fi

# 2. Check if Nginx is active
# 'systemctl is-active' returns 0 if running, non-zero if stopped
/usr/bin/systemctl is-active --quiet nginx

if [ $? -ne 0 ]; then
    echo "$TIMESTAMP [ERROR] Nginx service is DOWN. Attempting to restart..." >> $LOGFILE
    sudo systemctl start nginx
else
    echo "$TIMESTAMP [OK] Nginx is running normally." >> $LOGFILE
fi
