#!/bin/bash
#Open the file:
#sudo vi /usr/local/bin/discord-alerts.sh

#Paste this content (replace YOUR_URL_HERE with the URL you copied):
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

---
#Make it executable:

#sudo chmod +x /usr/local/bin/discord-alerts.sh
#Create the service file:
#sudo vi /etc/systemd/system/discord-alerts.service

[Unit]
Description=Discord Log Monitoring Service
After=network.target

[Service]
ExecStart=/usr/local/bin/discord-alerts.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload
sudo systemctl enable discord-alerts
sudo systemctl start discord-alerts

---
