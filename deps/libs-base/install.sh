#! /usr/bin/bash -x

###############################
#
# Install libs-base
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects tools-make to be installed, and for libs-base to be downloaded and built.
#
###############################

cd libs-base || exit
# shellcheck source=/dev/null
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
make -j "$(nproc)" install
