#!/bin/bash

# Wi-Fi SSID
SSID="EMLI-TEAM-15"

# Wi-Fi Password
PASSWORD="pillip15"

# Sync time with drone
sync_time() {
    echo "Syncing time with PC..."
    
    ssh pi@10.0.0.10 "bash -s" < home/pi/pillip/raspberry/bin/sync_time.sh
}

# Enable Wi-Fi device
nmcli radio wifi on

# Scan for available Wi-Fi networks
echo "Scanning for available Wi-Fi networks..."
nmcli dev wifi rescan

# Check if the desired Wi-Fi network is available
SSID_AVAILABLE=$(nmcli dev wifi list | grep -c "$SSID")

if [ $SSID_AVAILABLE -eq 0 ]; then
    echo "Error: Wi-Fi network '$SSID' not found."
    exit 1
fi

# Connect to the Wi-Fi network
echo "Connecting to Wi-Fi network '$SSID'..."
nmcli dev wifi connect "$SSID" password "$PASSWORD"

# Check if the connection was successful
CONNECTED=$(nmcli dev status | grep -c "connected")

if [ $CONNECTED -gt 0 ]; then
    echo "Successfully connected to Wi-Fi network '$SSID'."
    sync_time # syncs time on Pi with PC

else
    echo "Error: Failed to connect to Wi-Fi network '$SSID'."
    exit 1
fi
