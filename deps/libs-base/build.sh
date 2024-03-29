#! /usr/bin/bash -x

###############################
#
# Configure and build libs-base
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects tools-make to be installed, and for libs-base to be downloaded.
#
###############################

# shellcheck source=/dev/null
. /mingw64/standalone/Makefiles/GNUstep.sh
cd libs-base || exit
# Use OpenStep plist format
sed -i '330 s/NSPropertyListXMLFormat_v1_0/NSPropertyListOpenStepFormat/' Source/NSUserDefaults.m
./configure --disable-xslt --disable-tls --with-config-file=./GNUstep.conf --with-default-config=standalone.conf
make -j "$(nproc)"
