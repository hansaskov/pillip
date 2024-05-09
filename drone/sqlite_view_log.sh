#!/bin/bash

# Path to the SQLite database file
DB_FILE="wifi_data.db"

# Print out all values of the wifi_data table
echo "Timestamp  Link Quality  Signal Level"
sqlite3 "$DB_FILE" "SELECT * FROM wifi_data;" | awk '{printf("%-12s %-12s %-12s\n", $1, $2, $3)}'