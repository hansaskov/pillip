#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <wireless_name>, example wlan0"
    exit 1
fi

# Path to the SQLite database file
DB_FILE="wifi_data.db"
wireless="$1"

# Create the database and table if they don't exist
sqlite3 "$DB_FILE" "CREATE TABLE IF NOT EXISTS wifi_data (
    timestamp INTEGER PRIMARY KEY,
    link_quality INTEGER,
    signal_level INTEGER
);"

# Get the WiFi link quality and signal level
WIFI_INFO=$(cat /proc/net/wireless | grep "$wireless" | awk '{print $3, $4}')

if [ -n "$WIFI_INFO" ]; then
    LINK_QUALITY=$(echo "$WIFI_INFO" | awk '{print $1}')
    SIGNAL_LEVEL=$(echo "$WIFI_INFO" | awk '{print $2}')
else
    LINK_QUALITY=0
    SIGNAL_LEVEL=0
fi

# Get the current timestamp
TIMESTAMP=$(date +%s)

# Insert the data into the SQLite database
sqlite3 "$DB_FILE" "INSERT INTO wifi_data (timestamp, link_quality, signal_level) VALUES ($TIMESTAMP, $LINK_QUALITY, $SIGNAL_LEVEL);"

echo "Data logged at $TIMESTAMP: Link Quality=$LINK_QUALITY, Signal Level=$SIGNAL_LEVEL"