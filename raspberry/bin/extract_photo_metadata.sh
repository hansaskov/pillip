#!/usr/bin/env bash

# Helper functions

get_filename() {
    basename "$1"
}

get_directory() {
    dirname "$1"
}

get_create_date() {
    exiftool -CreateDate -s3 -d "%Y-%m-%d %H:%M:%S" "$1"
}

get_create_seconds_epoch() {
    exiftool -CreateDate -s3 -d "%s.%C" "$1"
}

get_subject_distance() {
    exiftool -SubjectDistance -n -s3 "$1"
}

get_exposure_time() {
    exiftool -ExposureTime -s3 "$1"
}

get_iso() {
    exiftool -ISO -n -s3 "$1"
}

get_timezone() {
    TIMEZONE=$(date +%z)
    SIGN=${TIMEZONE:0:1}
    HOURS=${TIMEZONE:1:2}
    MINUTES=${TIMEZONE:3:2}
    echo "${SIGN}${HOURS}:${MINUTES}"
}

create_json_metadata() {
    local image_path="$1"
    local trigger="$2"
    local filename=$(get_filename "$image_path")
    local directory=$(get_directory "$image_path")
    local create_date=$(get_create_date "$image_path")
    local timezone=$(get_timezone)
    local create_seconds_epoch=$(get_create_seconds_epoch "$image_path")
    local subject_distance=$(get_subject_distance "$image_path")
    local exposure_time=$(get_exposure_time "$image_path")
    local iso=$(get_iso "$image_path")
    local json_path="$directory/${filename%.*}.json"

    cat << EOF > "$json_path"
{
    "File Name": "$filename",
    "Create Date": "$create_date$timezone",
    "Create Seconds Epoch": $create_seconds_epoch,
    "Trigger": "$trigger",
    "Subject Distance": $subject_distance,
    "Exposure Time": "$exposure_time",
    "ISO": $iso
}
EOF
}

# Main script

main() {
    if [ -z "$1" ]; then
        echo "Error: Please provide an image file path as an argument." >&2
        echo "Usage: $0 <image_file_path> <trigger>" >&2
        exit 1
    fi

    image_path="$1"
    trigger="$2"

    if [ -z "$trigger" ] || ! ([[ "$trigger" == "Time" ]] || [[ "$trigger" == "Motion" ]] || [[ "$trigger" == "External" ]]); then
        echo "Error: Please provide a valid trigger (Time/Motion/External) as the second argument." >&2
        echo "Usage: $0 <image_file_path> <trigger>" >&2
        exit 1
    fi

    create_json_metadata "$image_path" "$trigger"
}

main "$@"