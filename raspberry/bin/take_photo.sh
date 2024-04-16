#!/bin/bash

# Check if a directory is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a directory path as an argument."
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Create the directory if it doesn't exist
directory_path="$1"
if [ ! -d "$directory_path" ]; then
    mkdir -p "$directory_path"
fi

# Get the current date in the format "YYYY-MM-DD"
current_date=$(date +%Y-%m-%d)

# Create the folder for the current date if it doesn't exist
folder_path="$directory_path/$current_date"
if [ ! -d "$folder_path" ]; then
    mkdir -p "$folder_path"
fi

# Get the current time in the format "HHmmss_sss"
current_time=$(date +%H%M%S_%3N)

# Construct the filename in the desired format
filename="${current_time}.jpg"

# Join the folder path and filename
image_path="$folder_path/$filename"

# Call the rpicam-still command with the constructed path
rpicam-still -t 0.01 -o "$image_path"