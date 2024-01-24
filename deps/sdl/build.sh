#! /usr/bin/bash -x

###############################

# Configure and build SDL

###############################

# Apply patch from Oolite
patch -s -d SDL-1.2.13 -p1 < Windows-deps/OOSDLWin32Patch/OOSDLdll_x64.patch
cd SDL-1.2.13
./autogen.sh
./configure
# Add flags back that configure seems to remove
sed -i '/^EXTRA_LDFLAGS/ s/$/ -ldxerr8 -ldinput8 -lole32/' Makefile
make -j$(nproc)
