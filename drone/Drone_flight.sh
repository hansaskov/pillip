#!/bin/bash

# Wi-Fi SSID
SSID="EMLI-TEAM-15"

# Wi-Fi Password
PASSWORD="pillip15"

# Sync time with drone
sync_time() {
    echo "Syncing time with PC..."
    # PC's IP address
    ip_address=$(ifconfig | grep 'inet ' | awk '{print $2}' | head -n 1) #if inet does not find the ip in ifconig change to correct line name

    date=$(date "+%Y-%m-%d %H:%M:%S")
    echo $date
    
    ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "~/pillip/raspberry/bin/sync_time.sh $date"
}

clone_photos() {
    # Define the path of the folder
    folderDrone="../photos"
    last_made_folder=$(ls -t $folderDrone | head -1)
    newest_folder="$folderDrone"/"$last_made_folder"

    jsonData=$(ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "find ~/photos/$last_made_folder | grep -i json") # json from camera
    photoData=$(ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "find ~/photos/$last_made_folder | grep -i jpg") # photos from camera
    folderData=$(ssh -i ~/.ssh/id_ed25519_rpi pi@10.0.0.10 "find ~/photos -type d | grep -i 2") # Folders from camera (only works consistently until year 3000)

    if [ ! -d "$folderDrone" ]; then
        echo "Error: Folder Drone does not exist."
        exit 1
    fi

    # Loop through each file in photo folders
    while IFS= read -r photoPi; do
        # Extract the filename without the path
        photoName=$(basename "$photoPi")
        
        # Check if the file exists in the newest folder
        if [ ! -e "$newest_folder/$photoName" ]; then
            # Move the file from folder Pi to folder Drone
            scp -i ~/.ssh/id_ed25519_rpi "pi@10.0.0.10:$photoPi" "$newest_folder"
            echo "Copied $photoName to $newest_folder"
        fi
    done <<< "$photoData"

    while IFS= read -r jsonPi; do
        jsonName=$(basename "$jsonPi")

        # Check if the file exists in the newest folder
        if [ ! -e "$newest_folder/$jsonName" ]; then
            # Move the file from folder Pi to folder Drone
            scp -i ~/.ssh/id_ed25519_rpi "pi@10.0.0.10:$jsonPi" "$newest_folder"
            echo "Copied $jsoName to $newest_folder"
        fi

    done <<< "$jsonData"

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

    # adds to json files
    jsonData=$(find $folderDrone | grep -i json) # json 

    while IFS= read -r jsonFile; do
        jsonName=$(basename "$jsonFile")
    
        epoc=$(date +%s)
        # add drone id and epoch to json file
        output=$(jq ". += {\"Drone ID\":\"WILDDRONE-001\",\"Downloaded Seconds Epoch\":$epoc}" <<< cat $jsonFile)

    done <<< "$jsonData"
}

# Enable Wi-Fi device
nmcli radio wifi on

# Scan for available Wi-Fi networks
echo "Scanning for available Wi-Fi networks..."
nmcli dev wifi rescan

# Check if the desired Wi-Fi network is available
SSID_AVAILABLE=$(nmcli dev wifi list | grep -c "$SSID")

while [ $SSID_AVAILABLE -eq 0 ]; do
    echo "Error: Wi-Fi network '$SSID' not found."
    nmcli dev wifi rescan
    SSID_AVAILABLE=$(nmcli dev wifi list | grep -c "$SSID")
done

# Connect to the Wi-Fi network
echo "Connecting to Wi-Fi network '$SSID'..."
nmcli dev wifi connect "$SSID" password "$PASSWORD"

# Check if the connection was successful
CONNECTED=$(nmcli dev status | grep -c "connected")

wifi_info=$(iwconfig 2>/dev/null | awk '/^[^ ]/ {iface=$1} /ESSID/ {print iface,$4}' | sed 's/ESSID:"\(.*\)"/\1/')
# Extract interface name and Wi-Fi network name (SSID)
interface_name=$(echo "$wifi_info" | awk '{print $1}')

if [ $CONNECTED -gt 0 ]; then
    echo "Successfully connected to Wi-Fi network '$SSID'."
    sync_time # syncs time on Pi with PC
    clone_photos
    while [ $CONNECTED -gt 0 ]; do
        sh ./log_wifi.sh $interface_name
    done
else
    echo "Error: Failed to connect to Wi-Fi network '$SSID'."
    exit 1
fi
