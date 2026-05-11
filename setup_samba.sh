#!/bin/bash

# Variables - Change these as needed
SHARE_PATH="/home/yashsingar/linux_share"
SHARE_NAME="LinuxShare"
SMB_USER="yashsingar"

echo "--- Starting Samba Automation ---"

# 1. Install Samba
sudo dnf install samba samba-common -y

# 2. Create Directory & Set Permissions
mkdir -p $SHARE_PATH
sudo chown -R $SMB_USER:$SMB_USER $SHARE_PATH
sudo chmod -R 0775 $SHARE_PATH

# 3. Configure SELinux (The 'Bouncer')
sudo setsebool -P samba_enable_home_dirs on
sudo chcon -t samba_share_t $SHARE_PATH

# 4. Create Samba Configuration
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo tee /etc/samba/smb.conf <<EOF
[global]
    workgroup = WORKGROUP
    server string = Samba Server %v
    netbios name = centos-srv
    security = user
    map to guest = bad user
    dns proxy = no

[$SHARE_NAME]
    path = $SHARE_PATH
    valid users = $SMB_USER
    browsable = yes
    writable = yes
    guest ok = no
    read only = no
EOF

# 5. Open Firewall
sudo firewall-cmd --add-service=samba --permanent
sudo firewall-cmd --reload

# 6. Start Services
sudo systemctl enable smb nmb
sudo systemctl restart smb nmb

echo "--- Setup Complete! ---"
echo "Now run: sudo smbpasswd -a $SMB_USER"
