#! /usr/bin/bash -x

###############################

# Install tools-make

###############################

cd tools-make || exit
make -j "$(nproc)" install
