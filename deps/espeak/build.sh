#! /usr/bin/bash -x

###############################
#
# Configure and build eSpeak
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects eSpeak to be downloaded.
#
###############################

# Copy edited files from Oolite
cp ./deps/espeak/gettimeofday.c ./espeak-1.43.03-source/src/
cp ./deps/espeak/Makefile ./espeak-1.43.03-source/src/
cp ./deps/espeak/speak_lib.cpp ./espeak-1.43.03-source/src/
cp ./deps/espeak/speech.h ./espeak-1.43.03-source/src/

# Rename the file <espeakSourceFolder>/src/portaudio19.h to portaudio.h.
mv ./espeak-1.43.03-source/src/portaudio19.h ./espeak-1.43.03-source/src/portaudio.h

# Copy the file speak_lib.h from <espeakSourceFolder>/platforms/windows/windows_dll/src to <espeakSourceFolder>/src.
cp ./espeak-1.43.03-source/platforms/windows/windows_dll/src/speak_lib.h ./espeak-1.43.03-source/src/

# Fix compile error
# dictionary.cpp: In function 'void InitGroups(Translator*)':
# dictionary.cpp:163:48: error: cast from 'char*' to 'long int' loses precision [-fpermissive]
#   163 |                         pw = (unsigned int *)(((long)p+4) & ~3);  // advance to next word boundary
#       |                                                ^~~~~~~
sed -i '163 s/long/uintptr_t/' ./espeak-1.43.03-source/src/dictionary.cpp

# Build eSpeak
cd espeak-1.43.03-source/src || exit
make -j "$(nproc)" libespeak.dll
