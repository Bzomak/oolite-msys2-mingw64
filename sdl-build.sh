#! /usr/bin/bash -v

###############################

# Configure and build SDL

###############################

patch -s -d SDL-1.2.13 -p1 < Windows-deps/OOSDLWin32Patch/OOSDLdll_x64.patch
cd SDL-1.2.13
./autogen.sh
./configure
sed -i '/^EXTRA_LDFLAGS/ s/$/ -ldxerr8 -ldinput8 -lole32/' Makefile
make -j$(nproc)
