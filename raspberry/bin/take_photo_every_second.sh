#!/bin/bash

# Constants
PHOTO_WIDTH=1152
PHOTO_HEIGHT=648
PHOTO_DELAY=0.01  # seconds
SECONDS_PER_MINUTE=60
SAVE_INTERVAL_MINUTES=5

# Functions

take_photo() {
    start_capture_time=$(date +%s)
    rpicam-still -t "$PHOTO_DELAY" --width "$PHOTO_WIDTH" --height "$PHOTO_HEIGHT" -o "$1"
    capture_time=$(($(date +%s) - start_capture_time))
}

save_photo() {
    ./save_photos.sh "$1"
    echo "Photo taken and saved to $1"
}

check_motion() {
    python ../py/motion.py "$img2" "$img1"
    if [ $? -eq 0 ]; then
        echo "No motion, not saving image"
    else
        echo "Motion detected, saving image"
        save_photo "Motion"
    fi
}

save_image_every_interval() {
    if [ $((elapsed_time)) -ge $((SAVE_INTERVAL_MINUTES * SECONDS_PER_MINUTE)) ]; then
        save_photo "$img1"
        start_time=$(date +%s)
    fi
}

wait_for_next_seconds() {
    remaining_time=$((${1} - (elapsed_time % ${1})))
    if [ $remaining_time -gt 0 ]; then
        sleep $remaining_time
    fi
}

# Main script

outdir=~/tmp/photos
mkdir -p "$outdir"
img1="$outdir/img1.jpg"
img2="$outdir/img2.jpg"
start_time=$(date +%s)

while true; do
    # Check if img1.jpg exists
    if [ -e "$img1" ]; then
        # Rename img1.jpg to img2.jpg
        mv "$img1" "$img2"
    fi

    take_photo "$img1"

    # Calculate the actual time elapsed since the last iteration
    elapsed_time=$(($(date +%s) - start_time))
    echo $elapsed_time

    check_motion

    save_image_every_interval

    wait_for_next_seconds 3
done