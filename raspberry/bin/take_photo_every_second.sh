#!/usr/bin/env bash

# Main script
PHOTO_DIR=~/tmp/photos
mkdir -p "$PHOTO_DIR"

i=1
while true
do
    filename="img$i.jpg"
    filepath="$PHOTO_DIR/$filename"
    if [ -f "$filepath" ]; then
        if [ -f "$PHOTO_DIR/img$((i+1)).jpg" ]; then
            rm "$PHOTO_DIR/img$((i+1)).jpg"
        fi
        mv "$filepath" "$PHOTO_DIR/img$((i+1)).jpg"
    fi
    rpicam-still -t 0.01 -o "$filepath"
    i=1
    sleep 1
done