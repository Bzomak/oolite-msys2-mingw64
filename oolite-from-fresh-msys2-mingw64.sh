#! /usr/bin/bash -x

###############################

# Download msys2 from https://www.msys2.org/
# Installer from page above links to https://github.com/msys2/msys2-installer/releases/download/2023-07-18/msys2-x86_64-20230718.exe

# Install msys2

# Open msys2 mingw64

# Update msys2 (May need to run twice. Not needed when using msys2/setup-msys2@v2 GitHub Action)
# pacman -Syu

###############################

# Install useful tools for building
pacman -S --noconfirm git

###############################

# Install build dependencies for GNUstep make
TOOLS_MAKE_MSYS2_DEPS=$(cat ./deps/tools-make/msys2-deps)
pacman -S --noconfirm --needed $TOOLS_MAKE_MSYS2_DEPS

# Clone tools-make repo
TOOLS_MAKE_VERSION=$(cat ./deps/tools-make/version)
git clone https://github.com/gnustep/tools-make.git --branch=$TOOLS_MAKE_VERSION

# Make and Install gmake
./deps/tools-make/build.sh
./deps/tools-make/install.sh

###############################

# Install build dependencies for GNUstep libs-base
. ./deps/libs-base/msys2-deps
pacman -S --noconfirm --needed $LIBS_BASE_MSYS2_DEPS

# Clone libs-base repo - Needs https://github.com/gnustep/libs-base/pull/295
. ./deps/libs-base/version
git clone https://github.com/gnustep/libs-base.git
cd libs-base 
git checkout $LIBS_BASE_VERSION
cd ..

# Make and install libs-base
./deps/libs-base/build.sh
./deps/libs-base/install.sh

###############################

# Download Oolite SDL patch
git clone https://github.com/OoliteProject/oolite-windows-dependencies.git Windows-deps --sparse
cd Windows-deps
git sparse-checkout set OOSDLWin32Patch
git checkout
cd ..

# Install build dependencies for SDL
. ./deps/sdl/msys2-deps
pacman -S --noconfirm --needed $SDL_MSYS2_DEPS

# Download SDL and extract from tarball
. ./deps/sdl/version
wget $SDL_VERSION
tar -xf SDL-1.2.13.tar.gz

# Make and install SDL
./deps/sdl/build.sh
./deps/sdl/install.sh

###############################

# Clone Oolite repo and submodules
git clone --recursive https://github.com/OoliteProject/oolite.git

# Now let's try to compile Oolite
./oolite-config/build.sh release

###############################
###############################
###############################

# Copy these dlls to the oolite.app folder
cp /mingw64/bin/libobjc-4.dll ./oolite/oolite.app/
cp /mingw64/bin/gnustep-base-1_29.dll ./oolite/oolite.app/
cp /mingw64/bin/libgcc_s_seh-1.dll ./oolite/oolite.app/
cp /mingw64/bin/libffi-8.dll ./oolite/oolite.app/
cp /mingw64/bin/libgnutls-30.dll ./oolite/oolite.app/
cp /mingw64/bin/libwinpthread-1.dll ./oolite/oolite.app/
cp /mingw64/bin/libicuin74.dll ./oolite/oolite.app/
cp /mingw64/bin/libicuuc74.dll ./oolite/oolite.app/
cp /mingw64/bin/libxslt-1.dll ./oolite/oolite.app/
cp /mingw64/bin/libbrotlidec.dll ./oolite/oolite.app/
cp /mingw64/bin/libbrotlienc.dll ./oolite/oolite.app/
cp /mingw64/bin/libgmp-10.dll ./oolite/oolite.app/
cp /mingw64/bin/libhogweed-6.dll ./oolite/oolite.app/
cp /mingw64/bin/libidn2-0.dll ./oolite/oolite.app/
cp /mingw64/bin/libintl-8.dll ./oolite/oolite.app/
cp /mingw64/bin/libnettle-8.dll ./oolite/oolite.app/
cp /mingw64/bin/libtasn1-6.dll ./oolite/oolite.app/
cp /mingw64/bin/libp11-kit-0.dll ./oolite/oolite.app/
cp /mingw64/bin/libunistring-5.dll ./oolite/oolite.app/
cp /mingw64/bin/libzstd.dll ./oolite/oolite.app/
cp /mingw64/bin/libstdc++-6.dll ./oolite/oolite.app/
cp /mingw64/bin/libicudt74.dll ./oolite/oolite.app/
cp /mingw64/bin/libbrotlicommon.dll ./oolite/oolite.app/
cp /mingw64/bin/liblzma-5.dll ./oolite/oolite.app/

# Copy these dlls to the oolite.app folder, overwriting the ones that are already there
cp /mingw64/bin/SDL.dll ./oolite/oolite.app/
cp /mingw64/bin/libxml2-2.dll ./oolite/oolite.app/
cp /mingw64/bin/libiconv-2.dll ./oolite/oolite.app/
cp /mingw64/bin/zlib1.dll  ./oolite/oolite.app/
