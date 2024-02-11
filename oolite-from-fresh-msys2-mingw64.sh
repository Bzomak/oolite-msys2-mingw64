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
read -r -a TOOLS_MAKE_MSYS2_DEPS <<< "$(cat ./deps/tools-make/msys2-deps)"
pacman -S --noconfirm --needed "${TOOLS_MAKE_MSYS2_DEPS[@]}"

# Clone tools-make repo
TOOLS_MAKE_VERSION=$(cat ./deps/tools-make/version)
git clone https://github.com/gnustep/tools-make.git --branch="$TOOLS_MAKE_VERSION"

# Make and Install gmake
./deps/tools-make/build.sh
./deps/tools-make/install.sh

###############################

# Install build dependencies for GNUstep libs-base
read -r -a LIBS_BASE_MSYS2_DEPS <<< "$(cat ./deps/libs-base/msys2-deps)"
pacman -S --noconfirm --needed "${LIBS_BASE_MSYS2_DEPS[@]}"

# Clone libs-base repo - Needs https://github.com/gnustep/libs-base/pull/295
LIBS_BASE_VERSION=$(cat ./deps/libs-base/version)
git clone https://github.com/gnustep/libs-base.git
cd libs-base || exit 
git checkout "$LIBS_BASE_VERSION"
cd ..

# Make and install libs-base
./deps/libs-base/build.sh
./deps/libs-base/install.sh

###############################

# Install build dependencies for SDL
read -r -a SDL_MSYS2_DEPS <<< "$(cat ./deps/sdl/msys2-deps)"
pacman -S --noconfirm --needed "${SDL_MSYS2_DEPS[@]}"

# Download SDL and extract from tarball
SDL_VERSION=$(cat ./deps/sdl/version)
git clone https://github.com/libsdl-org/SDL-1.2.git --branch="$SDL_VERSION" SDL-1.2.13

# Make and install SDL
./deps/sdl/build.sh
./deps/sdl/install.sh

###############################

# Install build dependencies for Oolite
# Some of these are already installed, but we're reusing the list from the build Oolite job on GitHub Actions

read -r -a OOLITE_MSYS2_DEPS <<< "$(cat ./oolite-config/msys2-deps)"
pacman -S --noconfirm --needed "${OOLITE_MSYS2_DEPS[@]}"

# Clone Oolite repo and submodules
git clone --recursive https://github.com/OoliteProject/oolite.git

# Now let's try to compile Oolite
./oolite-config/build.sh release

###############################
###############################
###############################
