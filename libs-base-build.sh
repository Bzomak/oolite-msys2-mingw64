#! /usr/bin/bash -v

###############################

# Configure and build libs-base

###############################

. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
cd libs-base
sed -i '330 s/NSPropertyListXMLFormat_v1_0/NSPropertyListOpenStepFormat/' Source/NSUserDefaults.m
./configure
make -j$(nproc)
