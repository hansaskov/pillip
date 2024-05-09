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

    folderData=$(ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "find ~/photos -type d | grep -i 2") # Folders from camera (only works consistently until year 3000)

    if [ ! -d "$folderDrone" ]; then
        echo "Error: Folder Drone does not exist."
        exit 1
    fi

    while IFS= read -r FolderPi; do
    # Extract the folder name without the path
    folderName=$(basename "$FolderPi")

    # Check if the folder exists in folderDrone 
    if [ ! -d "$folderDrone/$folderName" ]; then
        # Move the folder from folderPi to folderDrone
        scp -i ~/.ssh/id_ed25519_rpi -r "pi@10.0.0.10:$FolderPi" "$folderDrone"
        echo "Copied $folderName to $folderDrone"
    fi
    done <<< "$folderData"


    jsonData=$(find $folderDrone | grep -i json) # json 

    echo $jsonData

    while IFS= read -r jsonFile; do
        jsonName=$(basename "$jsonFile")

        echo $jsonName
    
        epoc=$(date +%s)
        # add drone id and epoch to json file
        output=$(jq ". += {\"Drone ID\":\"WILDDRONE-001\",\"Downloaded Seconds Epoch\":$epoc}" <<< cat $jsonFile)
        echo $output
        echo $output > $jsonFile

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
