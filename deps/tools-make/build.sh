#! /usr/bin/bash -eux

###############################

# Configure and build tools-make

###############################

cd tools-make
./configure
make -j$(nproc)