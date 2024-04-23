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

take_photo() {
    rpicam-still -t 0.01 -o "$1"
}

extract_metadata() {
    local image_path="$1"
    local trigger="$2"
    local metadata_script="./extract_photo_metadata.sh"

    if [ -f "$metadata_script" ]; then
        "$metadata_script" "$image_path" "$trigger"
    else
        echo "Error: $metadata_script not found." >&2
    fi
}

# Main script

main() {
    # Check if a directory is provided
    if [ -z "$1" ]; then
        echo "Error: Please provide a directory path as an argument." >&2
        echo "Usage: $0 <directory_path>" >&2
        exit 1
    fi

    directory_path="$1"
    create_dir "$directory_path"

    current_date=$(get_date)
    folder_path=$(join_path "$directory_path" "$current_date")
    create_dir "$folder_path"

    current_time=$(get_time)
    filename="${current_time}.jpg"
    image_path=$(join_path "$folder_path" "$filename")

    take_photo "$image_path"

    # Call the extract_metadata script
    extract_metadata "$image_path" "$2"
}

main "$@"