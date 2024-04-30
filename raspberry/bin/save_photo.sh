#!/usr/bin/env bash

# Helper functions
create_dir() {
    mkdir -p "$1"
}

get_date() {
    date +%Y-%m-%d
}

get_time() {
    date +%H%M%S_%3N
}

join_path() {
    printf "%s/%s" "$1" "$2"
}

# Main script

main() {
    # Check if image path is provided
    if [ -z "$1" ]; then
        echo "Error: Please provide an image path as an argument." >&2
        echo "Usage: $0 <image_path>" >&2
        exit 1
    fi

    image_path="$1"
    photos_dir=~/photos
    create_dir "$photos_dir"

    current_date=$(get_date)
    folder_path=$(join_path "$photos_dir" "$current_date")
    create_dir "$folder_path"

    current_time=$(get_time)
    filename="${current_time}.jpg"
    new_image_path=$(join_path "$folder_path" "$filename")

    # Move the image to the new location
    cp "$image_path" "$new_image_path"

    echo "$new_image_path"
}

main "$@"