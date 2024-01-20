#! /usr/bin/bash -eux

###############################

# Install tools-make

###############################

cd tools-make
make -j $(nproc) install
