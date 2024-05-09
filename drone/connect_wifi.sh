#!/bin/bash

# Wi-Fi SSID
SSID="EMLI-TEAM-15"

# Wi-Fi Password
PASSWORD="pillip15"

# get user
USER=$(whoami)
echo "Current user: $USER"

# Sync time with drone
sync_time() {
    echo "Syncing time with PC..."
    # PC's IP address
    ip_address=$(ifconfig | grep 'inet ' | awk '{print $2}' | head -n 1) #if inet does not find the ip in ifconig change to correct line name (maybe wlan0?)

    date=$(date "+%Y-%m-%d %H:%M:%S")
    echo $date
    
    ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "~/pillip/raspberry/bin/sync_time.sh $date"
}

check_for_photos() {
    # Define the path of the folder
    folderDrone="../photos"

    jsonData=$(ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "find ~/photos | grep -i json") # json from camera
    photoData=$(ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "find ~/photos | grep -i jpg") # photos from camera

    if [ ! -d "$folderDrone" ]; then
        echo "Error: Folder Drone does not exist."
        exit 1
    fi

    
    # Loop through each file in camera
    while IFS= read -r photoPi; do
        # Extract the filename without the path
        photoName=$(basename "$photoPi")
        
        # Check if the file exists in folder2
        if [ ! -e "$folderDrone/$photoName" ]; then
            # Move the file from folder Pi to folder Drone
            scp -i ~/.ssh/id_ed25519_rpi "pi@10.0.0.10:$photoPi" "$folderDrone"
            echo "Copied $photoName to $folderDrone"
        fi
    done <<< "$photoData"

    while IFS= read -r jsonPi; do
        jsonName=$(basename "$jsonPi")

        if [ ! -e "$folderDrone/$jsonName" ]; then
            # Move the file from folder Pi to folder Drone
            scp -i ~/.ssh/id_ed25519_rpi "pi@10.0.0.10:$jsonPi" "$folderDrone"
            epoc= date +%s
            sed -i '$s/}/,\n"Drone ID":"WILDDRONE-001",}/' $jsoName
            sed -i '$s/}/,\n"Downloaded Seconds Epoch":'$epoc'}/' $jsoName
            echo "Copied $jsoName to $folderDrone"
        fi

    done <<< "$jsonData"
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
    #sync_time # syncs time on Pi with PC
    check_for_photos

else
    echo "Error: Failed to connect to Wi-Fi network '$SSID'."
    exit 1
fi
