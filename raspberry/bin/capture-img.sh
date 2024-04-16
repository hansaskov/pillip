#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a file name as an argument."
    echo "Usage: $0 <filename>"
    exit 1
fi

# Call the rpicam-still command with the provided file name
rpicam-still -t 0.01 -o "$1"