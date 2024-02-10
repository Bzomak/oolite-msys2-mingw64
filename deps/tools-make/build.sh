#! /usr/bin/bash -x

###############################

# Configure and build tools-make

###############################

cd tools-make || exit
./configure
make -j$(nproc)
