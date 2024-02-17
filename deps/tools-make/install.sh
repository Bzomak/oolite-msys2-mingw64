#! /usr/bin/bash -x

###############################
#
# Install tools-make
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects tools-make to be downloaded and built.
#
###############################

cd tools-make || exit
make -j "$(nproc)" install
