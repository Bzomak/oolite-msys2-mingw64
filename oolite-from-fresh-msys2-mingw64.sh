#! /usr/bin/bash -v

###############################

# Download msys2 from https://www.msys2.org/
# Installer from page above links to https://github.com/msys2/msys2-installer/releases/download/2023-07-18/msys2-x86_64-20230718.exe

# Install msys2

# Open msys2 mingw64

# Update msys2 (May need to run twice. Not needed when using msys2/setup-msys2@v2 GitHub Action)
# pacman -Syu

###############################

# Install useful tools for building
pacman -S --noconfirm base-devel
pacman -S --noconfirm git
pacman -S --noconfirm mingw-w64-x86_64-gcc-objc

###############################

# Clone tools-make repo - latest release didn't seem to set the GNUSTEP variables properly so using v2.4.0
git clone https://github.com/gnustep/tools-make.git  --branch=make-2_4_0

# Make and Install gnumake
cd tools-make
./configure
make -j $(nproc)
make -j $(nproc) install
. /mingw64/System/Library/Makefiles/GNUstep.sh
cd ..

###############################

# Install build dependencies for GNUstep libs-base
pacman -S --noconfirm mingw-w64-x86_64-libffi
pacman -S --noconfirm mingw-w64-x86_64-libxml2
pacman -S --noconfirm mingw-w64-x86_64-gnutls
pacman -S --noconfirm mingw-w64-x86_64-icu

# Clone libs-base repo
git clone https://github.com/gnustep/libs-base.git --branch=base-1_29_0

# Make and install libs-base
cd libs-base
./configure
make -j $(nproc)
make -j $(nproc) install
cd ..

###############################

# Clone Oolite repo and submodules
git clone --recursive https://github.com/OoliteProject/oolite.git

###############################

# Download SDL 
wget https://sourceforge.net/projects/libsdl/files/SDL/1.2.13/SDL-1.2.13.tar.gz

# Extract from tarball
tar -xf SDL-1.2.13.tar.gz

# Apply patch from Oolite
patch -s -d SDL-1.2.13 -p1 < oolite/deps/Windows-deps/OOSDLWin32Patch/OOSDLdll_x64.patch

# Install autoconf
pacman -S --noconfirm autoconf

# Configure to hopefully find everything
cd SDL-1.2.13
./autogen.sh
./configure

# Add flags back that configure seems to remove
sed -i '/^EXTRA_LDFLAGS/ s/$/ -ldxerr8 -ldinput8 -lole32/' Makefile

# Make
make -j $(nproc)
make -j $(nproc) install
cd ..

###############################

# Now let's try to compile Oolite
cd oolite

# Add -fobjc-exceptions and -fcommon to OBJC flags in GNUMakefile, line 36
# Since gcc 10 -fno-common is default; add -fcommon to avoid 9425 (yes, 9425!) errors of the form
# C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: ./obj.win.spk/oolite.obj/OODebugSupport.m.o:C:\msys64\home\Robert\oolite/src/Core/OOOpenGLExtensionManager.h:280: multiple definition of `glClampColor'; ./obj.win.spk/oolite.obj/OODebugMonitor.m.o:C:\msys64\home\Robert\oolite/src/Core/OOOpenGLExtensionManager.h:280: first defined here
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=85678

sed -i '36 s/$/ -fobjc-exceptions -fcommon/' GNUMakefile

# Fix inability to find js lib
# Uncomment JS_LIB_DIR
sed -i '25 s/^#//' GNUMakefile
# Add JS_LIB_DIR to ADDITIONAL_OBJC_LIBS
sed -i '33 s/-l$(JS_IMPORT_LIBRARY) /-L$(JS_LIB_DIR) &/' GNUMakefile

# Try to build
make -j $(nproc) -f Makefile release

###############################
###############################
###############################
