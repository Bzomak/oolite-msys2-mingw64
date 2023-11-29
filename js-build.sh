#! /usr/bin/bash -v

###############################

# Configure and build SpiderMonkey

###############################

cd mozilla-2.0/js/src
./configure
make -j$(nproc)
