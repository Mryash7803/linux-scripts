#!/bin/bash

# Configuration
WEBHOOK_URL="your discord server url"

# Monitor logs
tail -Fn0 /var/log/messages /var/log/secure | while read -r line ; do
    # Filter for keywords
    if echo "$line" | grep -Ei "Failed|Accepted|error|pam_faillock|sudo" > /dev/null; then
        
        # We use a simple message format to ensure Discord accepts it
        MSG="Security Alert: $line"
        
        # Send to Discord
        curl -s -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"$MSG\"}" \
             "$WEBHOOK_URL"
    fi
done
