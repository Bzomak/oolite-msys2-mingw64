#! /usr/bin/bash -eux

###############################

# Install libs-base

###############################

cd libs-base
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
make -j $(nproc) install
