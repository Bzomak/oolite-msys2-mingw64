#! /usr/bin/bash

###############################
#
# Extract a data string from a file and store it in a GitHub output variable
#
# Usage: Call `bash copy-dlls.sh [input_path]` from the run step in the workflow file
#
###############################

# Check if the required argument is provided and store it in a named variable
if [ $# -ne 1 ]; then
    ERROR_MESSAGE="Path is required"
    echo "::error::$ERROR_MESSAGE"
    echo "error=$ERROR_MESSAGE" >> "$GITHUB_OUTPUT"
else
    input_path=$1
fi

# Check if the path provided is valid and if so extract the data string
if [ ! -e "$input_path" ]; then
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
