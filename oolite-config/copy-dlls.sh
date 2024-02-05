#! /usr/bin/bash -x

###############################

# Copy the required dlls to the oolite.app folder

###############################

# Try asking Oolite what dlls it thinks it needs
echo "Checking dlls before copying"
ldd ./oolite/oolite.app/oolite.exe


cp /mingw64/bin/libobjc-4.dll ./oolite/oolite.app/
cp /mingw64/bin/gnustep-base-1_29.dll ./oolite/oolite.app/
cp /mingw64/bin/libopenal-1.dll ./oolite/oolite.app/
cp /mingw64/bin/libpng16-16.dll ./oolite/oolite.app/
cp /mingw64/bin/SDL.dll ./oolite/oolite.app/
cp /mingw64/bin/libvorbisfile-3.dll ./oolite/oolite.app/
cp /mingw64/bin/libgcc_s_seh-1.dll ./oolite/oolite.app/
cp /mingw64/bin/libwinpthread-1.dll ./oolite/oolite.app/
CP /mingw64/bin/libstdc++-6.dll ./oolite/oolite.app/
cp /mingw64/bin/libffi-8.dll ./oolite/oolite.app/
cp /mingw64/bin/libicuin74.dll ./oolite/oolite.app/
cp /mingw64/bin/libicuuc74.dll ./oolite/oolite.app/
cp /mingw64/bin/libiconv-2.dll ./oolite/oolite.app/
cp /mingw64/bin/libxml2-2.dll ./oolite/oolite.app/

###############################

# Copy the js lib from the oolite-windows-dependencies repo to the oolite.app folder
# Once we can build it ourselves it can be copied with the other dlls
cp ./oolite/deps/Windows-deps/x86_64/DLLs/js32ECMAv5.dll ./oolite/oolite.app/

###############################

# Try asking Oolite what dlls it thinks it needs
echo "Checking dlls after copying"
ldd ./oolite/oolite.app/oolite.exe

###############################

# Check if the required argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <application_name>"
    exit 1
fi

# Store the application name provided as argument
app_name=$1

# Get the list of DLLs for the application using 'ldd' command
dll_list=$(ldd $(which $app_name) | grep -oE '/[a-zA-Z0-9./_]+\.dll')

# Check if any DLLs are found
if [ -z "$dll_list" ]; then
    echo "No DLLs found for the application: $app_name"
    exit 1
fi

# If a directory path is provided as the second argument, filter the DLLs by that directory
if [ -n "$2" ]; then
    directory_path=$2
    filtered_dll_list=$(echo "$dll_list" | grep "$directory_path")
    if [ -z "$filtered_dll_list" ]; then
        echo "No DLLs found in directory: $directory_path"
        exit 1
    fi
    echo "Filtered DLLs in directory $directory_path used by $app_name:"
    echo "$filtered_dll_list"
else
    echo "DLLs used by $app_name:"
    echo "$dll_list"
fi
