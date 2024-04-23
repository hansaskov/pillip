#!/usr/bin/env bash

# Helper functions

get_filename() {
  basename "$1"
}

get_directory() {
  dirname "$1"
}

get_create_date() {
  exiftool -CreateDate -d "%Y-%m-%d %H:%M:%S.%%%C%+03c" "$1"
}

get_create_seconds_epoch() {
  exiftool -CreateDate -d "%s.%C" "$1"
}

get_subject_distance() {
  exiftool -SubjectDistance -n "$1"
}

get_exposure_time() {
  exiftool -ExposureTime "$1"
}

get_iso() {
  exiftool -ISO "$1"
}

create_json_metadata() {
  local image_path="$1"
  local trigger="$2"
  local filename=$(get_filename "$image_path")
  local directory=$(get_directory "$image_path")
  local create_date=$(get_create_date "$image_path")
  local create_seconds_epoch=$(get_create_seconds_epoch "$image_path")
  local subject_distance=$(get_subject_distance "$image_path")
  local exposure_time=$(get_exposure_time "$image_path")
  local iso=$(get_iso "$image_path")
  local json_path="$directory/${filename%.*}.json"

  cat << EOF > "$json_path"
{
  "File Name": "$filename",
  "Create Date": "$create_date",
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

  if [ -z "$trigger" ] || ! ([ "$trigger" == "Time" ] || [ "$trigger" == "Motion" ] || [ "$trigger" == "External" ]); then
    echo "Error: Please provide a valid trigger (Time/Motion/External) as the second argument." >&2
    echo "Usage: $0 <image_file_path> <trigger>" >&2
    exit 1
  fi

  create_json_metadata "$image_path" "$trigger"
}

main "$@"