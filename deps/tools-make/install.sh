#! /usr/bin/bash -x

###############################

# Install tools-make

###############################

cd tools-make
make -j $(nproc) install
