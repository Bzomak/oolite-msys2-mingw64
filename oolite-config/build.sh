#! /usr/bin/bash -x

###############################

# Configure and build Oolite

###############################

cd oolite
sed -i '36 s/$/ -fobjc-exceptions -fcommon/' GNUMakefile
sed -i '25 s/^#//' GNUMakefile
sed -i '33 s/-l$(JS_IMPORT_LIBRARY) /-L$(JS_LIB_DIR) &/' GNUMakefile
sed -i '452 s/objc.make/tool.make/' GNUMakefile
sed -i 's/OBJC_PROGRAM_NAME/TOOL_NAME/' GNUMakefile
sed -i 's/OBJC_PROGRAM_NAME/TOOL_NAME/' GNUmakefile.postamble 
sed -i '271 s/release //' Makefile
sed -i '275 s/release-deployment //' Makefile
sed -i '280 s/release-snapshot //' Makefile
sed -i 's/pkg-win/pkg-win-release/' Makefile
sed -i 's|/nsis/makensis.exe|/mingw64/bin/makensis.exe|' Makefile
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh
make -j $(nproc) -f Makefile $1
