#! /usr/bin/bash -x

###############################
#
# Install SDL
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects SDL to be downloaded and built.
#
###############################

cd SDL-1.2.13 || exit
make -j "$(nproc)" install
