#!/bin/bash

# Set the output directory
outdir=~/tmp/photos

# Create the output directory if it doesn't exist
mkdir -p "$outdir"

# Define the image filenames
img1="$outdir/img1.jpg"
img2="$outdir/img2.jpg"

while true; do
    # Check if img1.jpg exists
    if [ -e "$img1" ]; then
        # Rename img1.jpg to img2.jpg
        mv "$img1" "$img2"
    fi

    # Take a new image and save it as img1.jpg
    rpicam-still -t 0.01 -o "$img1"

    # Wait for 1 second
    sleep 1
done