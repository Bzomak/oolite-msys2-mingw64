#! /usr/bin/bash -x

###############################

# Configure and build libs-base

###############################

. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
cd libs-base
# Use OpenStep plist format
sed -i '330 s/NSPropertyListXMLFormat_v1_0/NSPropertyListOpenStepFormat/' Source/NSUserDefaults.m
./configure --disable-xslt --disable-tls
make -j$(nproc)
