#!/bin/bash

# Set the output directory
outdir=~/tmp/photos

# Create the output directory if it doesn't exist
mkdir -p "$outdir"

# Define the image filenames
img1="$outdir/img1.jpg"
img2="$outdir/img2.jpg"

counter=0
start_time=$(date +%s)
while true; do
    # Check if img1.jpg exists
    if [ -e "$img1" ]; then
        # Rename img1.jpg to img2.jpg
        mv "$img1" "$img2"
    fi

    # Take a new image and save it as img1.jpg
    start_capture_time=$(date +%s)
    rpicam-still -t 0.01 -o "$img1"
    capture_time=$(($(date +%s) - start_capture_time))

    ls $outdir

    # Increment counter
    ((counter++))

    # Calculate the actual time elapsed since the last iteration
    elapsed_time=$(($(date +%s) - start_time - capture_time))

    # Save image every 5 minutes (300 seconds)
    if [ $((elapsed_time)) -ge 300 ]; then
        # Call save_photos.sh script
        ./save_photos.sh "$img1"
        start_time=$(date +%s)
    fi

    # Wait for the remaining time to reach 1 second
    remaining_time=$(1 - elapsed_time)
    if [ $remaining_time -gt 0 ]; then
        sleep $remaining_time
    fi
done