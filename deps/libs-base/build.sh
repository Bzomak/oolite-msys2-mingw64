#! /usr/bin/bash -x

###############################

# Configure and build libs-base

###############################

# shellcheck source=/dev/null
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
cd libs-base || exit
# Use OpenStep plist format
sed -i '330 s/NSPropertyListXMLFormat_v1_0/NSPropertyListOpenStepFormat/' Source/NSUserDefaults.m
./configure --disable-xslt --disable-tls
make -j "$(nproc)"
