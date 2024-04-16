#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a file name as an argument."
    echo "Usage: $0 <filename>"
    exit 1
fi

# Extract the directory path from the provided file name
dir=$(dirname "$1")

# Check if the directory exists, and create it if it doesn't
if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
fi

# Call the rpicam-still command with the provided file name
rpicam-still -t 0.01 -o "$1"