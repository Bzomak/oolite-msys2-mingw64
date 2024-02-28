#! /usr/bin/bash -x

###############################
#
# Install eSpeak
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects eSpeak to be downloaded and built.
#
###############################

cd espeak-1.43.03-source/src || exit
make -j "$(nproc)" install
