#! /usr/bin/bash -x

###############################
#
# Configure and build Oolite
#
# Usage: ./build.sh [debug|release|release-deployment|release-snapshot]
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects tools-make, libs-base, and SDL to be downloaded and installed.
# It expects Oolite to be downloaded.
#
###############################

cd oolite || exit

# Add -fobjc-exceptions and -fcommon to OBJC flags in GNUMakefile, line 36
# Since gcc 10 -fno-common is default; add -fcommon to avoid 9425 (yes, 9425!) errors of the form
# C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: ./obj.win.spk/oolite.obj/OODebugSupport.m.o:C:\msys64\home\Robert\oolite/src/Core/OOOpenGLExtensionManager.h:280: multiple definition of `glClampColor'; ./obj.win.spk/oolite.obj/OODebugMonitor.m.o:C:\msys64\home\Robert\oolite/src/Core/OOOpenGLExtensionManager.h:280: first defined here
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=85678
sed -i '36 s/$/ -fobjc-exceptions -fcommon/' GNUMakefile

# Fix inability to find js lib
# Uncomment JS_LIB_DIR
sed -i '25 s/^#//' GNUMakefile
# Add JS_LIB_DIR to ADDITIONAL_OBJC_LIBS
# shellcheck disable=SC2016
sed -i '33 s/-l$(JS_IMPORT_LIBRARY) /-L$(JS_LIB_DIR) &/' GNUMakefile

# Use tool.make instead of objc.make
sed -i '452 s/objc.make/tool.make/' GNUMakefile
sed -i 's/OBJC_PROGRAM_NAME/TOOL_NAME/' GNUMakefile
sed -i 's/OBJC_PROGRAM_NAME/TOOL_NAME/' GNUmakefile.postamble 

# Rename targets to make clear what they do
sed -i '271 s/release //' Makefile
sed -i '275 s/release-deployment //' Makefile
sed -i '280 s/release-snapshot //' Makefile
sed -i 's/pkg-win/pkg-win-release/' Makefile

# Stop the installer from rebuilding Oolite
sed -i 's|/nsis/makensis.exe|/mingw64/bin/makensis.exe|' Makefile

# Stop copying Oolite's precompiled dlls
# sed needs to comment out lines 59 to 70
sed -i '59,70 s/^/#/' Gnumakefile.postamble

# Use pre-build MSYS2 png and openal
sed -i '33 s/-lopenal32.dll -lpng14.dll/-lopenal.dll -lpng16.dll/' GNUMakefile

# Remove the oolite-windows-dependencies repo's include & libs folders
# shellcheck disable=SC2016
sed -i '32 s/-I$(WIN_DEPS_DIR)\/include //' GNUMakefile
# shellcheck disable=SC2016
sed -i '33 s/-L$(WIN_DEPS_DIR)\/lib //' GNUMakefile

# Copy the espeak-data folder
sed -i '46 s/^/#/' Gnumakefile.postamble
sed -i '48 s/^/#/' Gnumakefile.postamble
sed -i '52 s/^/#/' Gnumakefile.postamble

# Link to espeak and portaudio
sed -i '45 s/-lespeak.dll/-lespeak -lportaudio.dll/' GNUMakefile

# Try to build
# shellcheck source=/dev/null
. /mingw64/standalone/Makefiles/GNUstep.sh
make -j "$(nproc)" -f Makefile "$1"

# Need to copy the correct dlls to the oolite.app folder
cd ..
if [ "$1" = "release" ] || [ "$1" = "release-deployment" ] || [ "$1" = "release-snapshot" ]; then
    # Copy the js lib from the oolite-windows-dependencies repo to the oolite.app folder
    # Once we can build it ourselves it can be copied with the other dlls
    cp ./oolite/deps/Windows-deps/x86_64/DLLs/js32ECMAv5.dll ./oolite/oolite.app/
    ./oolite-config/copy-dlls.sh ./oolite/oolite.app/oolite.exe
elif [ "$1" = "debug" ]; then
    # Copy the js lib from the oolite-windows-dependencies repo to the oolite.app folder
    # Once we can build it ourselves it can be copied with the other dlls
    cp ./oolite/deps/Windows-deps/x86_64/DLLs/js32ECMAv5dbg.dll ./oolite/oolite.app/
    ./oolite-config/copy-dlls.sh ./oolite/oolite.app/oolite.dbg.exe
fi
