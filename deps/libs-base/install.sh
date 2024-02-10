#! /usr/bin/bash -x

###############################

# Install libs-base

###############################

cd libs-base || exit
# shellcheck source=/dev/null
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
make -j "$(nproc)" install
