#! /usr/bin/bash -eux

###############################

# Install SDL

###############################

cd SDL-1.2.13
make -j $(nproc) install
