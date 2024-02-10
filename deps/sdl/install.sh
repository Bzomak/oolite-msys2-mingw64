#! /usr/bin/bash -x

###############################

# Install SDL

###############################

cd SDL-1.2.13 || exit
make -j $(nproc) install
