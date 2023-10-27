#!/bin/bash

# Define the directory where you want to save the files
output_dir="./styles"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Check if rec.txt file exists
if [ -e "rec.txt" ]; then
  # Read each URL from the rec.txt file and download the associated CSS file
  while read -r url; do
    filename=$(basename "$url")
    # Ensure that the filename ends with .css
    filename="${filename%.css?*}.css"
    curl -o "$output_dir/$filename" "$url"
  done < "rec.txt"
else
  echo "rec.txt file not found."
fi
