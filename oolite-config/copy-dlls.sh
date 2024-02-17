#! /usr/bin/bash

###############################
#
# Copy the required dlls to the oolite.app folder
#
# Usage: ./copy-dlls.sh [application_name]
#
# The script expects to be called by oolite-config/build.sh, being run from the root of the oolite-msys2 repository.
# It expects Oolite to have been built.
#
###############################

# Check if the required argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <application_name>"
    exit 1
fi

# Store the application name provided as argument
app_name=$1

# Get the list of DLLs for the application using 'ldd' command
dll_list=$(ldd "$app_name")
echo "DLLs used by $app_name:"
echo "$dll_list"

# Check if any DLLs are found
if [ -z "$dll_list" ]; then
    echo "No DLLs found for the application: $app_name"
    exit 1
fi

# Filter the DLLs by those in /mingw64/bin
    filtered_dll_list=$(echo "$dll_list" | grep "/mingw64/bin" | awk '{print $3}')
    if [ -z "$filtered_dll_list" ]; then
        echo "No DLLs found in directory: /mingw64/bin"
        exit 1
    fi
    echo "Filtered DLLs in directory /mingw64/bin used by $app_name:"
    echo "$filtered_dll_list"


# Copy the required dlls to the oolite.app folder using the filtered list
app_location="$(dirname "$app_name")/"
for dll in $filtered_dll_list; do
    echo "Copying $dll"
    cp "$dll" "$app_location"
done

###############################

# Try asking Oolite again what dlls it thinks it needs after copying
echo "Checking dlls after copying"
post_copy_dll_list=$(ldd "$app_name")
echo "$post_copy_dll_list"

###############################
