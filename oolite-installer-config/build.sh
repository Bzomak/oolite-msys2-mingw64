#! /usr/bin/bash -x

###############################

# Configure and build the Oolite installers

# Usage: ./build.sh [release|release-deployment|release-snapshot]

###############################

cd oolite
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
make -j $(nproc) -f Makefile pkg-win-$1
