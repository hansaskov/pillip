#!/bin/bash

# Functions
take_photo() {
    start_capture_time=$(date +%s)
    rpicam-still -t 0.01 -w 1152 -h 648 -o "$1"
    capture_time=$(($(date +%s) - start_capture_time))   
}

save_photo() {
    ./save_photos.sh "$1"
    echo "Photo taken and saved to $1"
}

save_image_every_5min() {
    if [ $((elapsed_time)) -ge 300 ]; then
        save_photo "$img1"
        start_time=$(date +%s)
    fi
}

wait_for_next_second() {
    remaining_time=$((1 - (elapsed_time % 1)))
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
    save_image_every_5min
    wait_for_next_second
done