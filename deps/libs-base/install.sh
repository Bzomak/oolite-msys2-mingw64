#! /usr/bin/bash -x

###############################

# Install libs-base

###############################

cd libs-base || exit
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
make -j "$(nproc)" install
