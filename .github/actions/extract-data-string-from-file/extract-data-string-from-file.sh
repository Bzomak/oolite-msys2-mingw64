#! /usr/bin/bash

###############################
#
# Extract a data string from a file and store it in a GitHub output variable
#
# Usage: Call `bash copy-dlls.sh [input_path]` from the run step in the workflow file
#
###############################

# Check if the required argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_path>"
    exit 1
fi

# Store the path provided as argument
input_path=$1

if [ -z "$input_path" ]; then
    ERROR_MESSAGE="Path is required"
    echo "::error::$ERROR_MESSAGE"
    echo "error=$ERROR_MESSAGE" >> "$GITHUB_OUTPUT"
elif [ ! -e "$input_path" ]; then
    ERROR_MESSAGE="Path does not exist"
    echo "::error::$ERROR_MESSAGE"
    echo "error=$ERROR_MESSAGE" >> "$GITHUB_OUTPUT"
elif [ -d "$input_path" ]; then
    ERROR_MESSAGE="Path is a directory"
    echo "::error::$ERROR_MESSAGE"
    echo "error=$ERROR_MESSAGE" >> "$GITHUB_OUTPUT"
else
    DATA=$(cat "$input_path")
    {
    echo "data<<EOF"
    echo "$DATA"
    echo "EOF"
    } >> "$GITHUB_OUTPUT"
fi
