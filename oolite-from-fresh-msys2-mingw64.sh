#! /usr/bin/bash -x

###############################
#
# This script is for setting up a development environment for Oolite on MSYS2 MINGW64.
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It needs to be run from the root of the repository because it uses relative paths to find the build scripts for the dependencies and Oolite.
# It therefore needs the whole of the oolite-msys2 repository to be present in the MSYS2 MINGW64 environment.
# It will download everything that it needs to set up a development environment from a fresh MSYS2 install and build Oolite.
#
# Download and install MSYS2 from https://www.msys2.org/#installation
#
# Open MSYS2 MINGW64
#
# Update MSYS2 (May need to run twice. Not needed when using msys2/setup-msys2@v2 GitHub Action) by running the following command:
# pacman -Syu
#
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
wget "$SDL_VERSION"
tar -xf SDL-1.2.13.tar.gz

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
