#! /usr/bin/bash -x

###############################

# Configure and build tools-make

###############################

cd tools-make
./configure
make -j$(nproc)
