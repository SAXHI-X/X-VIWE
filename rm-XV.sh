#!/bin/bash

# @fileOverview Check usage stats of SAXHI-X
# @author MasterHide
# @Copyright © 2025 x404 MASTER™
# @license MIT
#
# You may not reproduce or distribute this work, in whole or in part, 
# without the express written consent of the copyright owner.
#
# For more information, visit: https://t.me/X_x_x_xzZ


# Ask user for confirmation
echo "This script will uninstall X-VIWE and all associated files. Are you sure you want to proceed? (y/n)"
read CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Uninstallation canceled."
    exit 0
fi

# Stop and disable the systemd service
echo "Stopping and disabling the X-VIWE service..."
sudo systemctl stop X-VIWE
sudo systemctl disable X-VIWE

# Remove the systemd service file
echo "Removing the X-VIWE systemd service file..."
sudo rm -f /etc/systemd/system/X-VIWE.service

# Reload systemd to reflect changes
sudo systemctl daemon-reload

# Ask for the OS username used during installation
echo "Enter the OS username used during installation (e.g., ubuntu):"
read USERNAME

# Remove the X-VIWE directory and its contents
echo "Removing the X-VIWE directory..."
sudo rm -rf /home/$USERNAME/X-VIWE

# Remove SSL certificates
echo "Removing SSL certificates..."
sudo rm -rf /var/lib/X-VIWE/certs

# Remove acme.sh (optional, if it was installed specifically for X-VIWE)
echo "Removing acme.sh (SSL certificate tool)..."
sudo rm -rf /root/.acme.sh

# Remove cron job added by acme.sh (if any)
echo "Removing acme.sh cron job..."
sudo crontab -l | grep -v "/root/.acme.sh/acme.sh --cron" | sudo crontab -

# Remove log files
echo "Removing X-VIWE log files..."
sudo rm -f /var/log/X-VIWE.log

# Optional: Remove Python dependencies (if no longer needed)
echo "Do you want to uninstall Python dependencies installed for X-VIWE? (y/n)"
read REMOVE_DEPS

if [ "$REMOVE_DEPS" == "y" ]; then
    echo "Uninstalling Python dependencies..."
    sudo apt remove -y python3-pip python3-venv git sqlite3 socat
    sudo apt autoremove -y
else
    echo "Skipping Python dependency removal."
fi

# Final message
echo "X-VIWE has been successfully uninstalled."
