#!/bin/bash

#check the folder ../photos for json files and check if they contain the key annotation?

# Directory to search for JSON files
dir="../photos"

# Check if the directory exists
if [ -d "$dir" ]; then
  # Loop through all JSON files in the directory
  for file in "$dir"/*.json; do
    # Check if the file is a valid JSON file
    if jsonlint "$file" >/dev/null 2>&1; then
      # Check if the JSON file contains the key "annotation"
      if jq -e '. | has("annotation")' "$file" >/dev/null 2>&1; then
        echo "$file: The key 'annotation' exists."
      else
        echo "$file: The key 'annotation' does not exist."
        ./annotate.sh #write the correct format to call 
      fi
    else
      echo "$file: Invalid JSON format."
    fi
  done
else
  echo "The directory $dir does not exist."
fi