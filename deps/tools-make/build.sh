#! /usr/bin/bash -x

###############################
#
# Configure and build tools-make
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects tools-make to be downloaded.
#
###############################

cd tools-make || exit
./configure
make -j "$(nproc)"
