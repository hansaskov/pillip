#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <image_file> <model_name>"
    exit 1
fi

# Assign the provided arguments
image_file="$1"
model_name="$2"

# Check if the image file exists
if [ ! -f "$image_file" ]; then
    echo "Error: Image file $image_file not found."
    exit 1
fi

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick (convert) is not installed."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed."
    exit 1
fi

# Create a temporary file to store the resized image
temp_file=$(mktemp)

# Resize the image to 672x672 using ImageMagick
convert "$image_file" -resize 672x672 "$temp_file"

# Base64 encode the resized image
encoded_image=$(base64 -w 0 "$temp_file")

# Prepare the request payload
payload="{\"model\": \"$model_name\", \"prompt\": \"What is in this picture?\", \"stream\": false}"

# Call the OllaMa API with the base64-encoded image as a file
response=$(curl -s -X POST -d "$payload" --data-binary "@$temp_file;base64" http://192.168.0.48:11434/api/generate)

# Extract the response field from the JSON output
api_response=$(echo "$response" | jq -r '.response')

# Print the response
echo "$api_response"

# Clean up the temporary file
rm "$temp_file"