#! /usr/bin/bash -v

###############################

# Configure and build tools-make

###############################

cd tools-make
./configure
make -j$(nproc)
