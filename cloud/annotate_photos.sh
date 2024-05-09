#!/bin/bash

# Directory to search for JSON files
dir="../photos"

# Check if the directory exists
if [ -d "$dir" ]; then
  # Loop through all JSON files in the directory
  for file in "$dir"/*.json; do
    # Check if the file is a valid JSON file
    #if jsonlint "$file" >/dev/null 2>&1; then
      # Check if the JSON file contains the key "annotation"
      if jq -e '. | has("annotation")' "$file" >/dev/null 2>&1; then
        echo "$file: The key 'annotation' exists."
      else
        echo "$file: The key 'annotation' does not exist."
        #use the bash script annotate.sh and take the output and save in the json file in a new key called annotation?
        output=$(./annotate.sh ${file:0:-5}.jpg llava:13b)
        echo $output
        #use the bash script annotate.sh and take the output and save in the json file in a new key called annotation?
        newline="{\"Annotation\":{\"Source\": \"llama:13b\", \"Test\": \"$output\"}}"
        
        new_content=$(jq ". += $newline" <<< cat $file)
        echo "$new_content" > "$file"
        echo "annotaion added to json file"
      fi
   # else
    #  echo "$file: Invalid JSON format."
   # fi
  done
else
  echo "The directory $dir does not exist."
fi