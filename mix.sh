#!/bin/bash

# Define the input file containing the list of CSS file names
input_file="mix.txt"

# Create a new combined CSS file named aram.css
output_file="./styles/aram.css"
> "$output_file"

# Read each file name from mix.txt and concatenate the content
while IFS= read -r css_file
do
  # Append the content of the CSS file to aram.css
  cat "./styles/$css_file" >> "$output_file"
done < "$input_file"

echo "Combined CSS files into $output_file"
