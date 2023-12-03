#! /usr/bin/bash -v

###############################

# Configure and build SpiderMonkey

###############################

cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/WINNT4.0.mk
cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/WINNT5.0.mk
cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/WINNT5.1.mk
cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/WINNT5.2.mk
cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/WINNT6.1.mk
cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/WINNT10.0.mk
cd mozilla-2.0/js/src
#sed -i '106 s/$(OS_ARCH)$(OS_OBJTYPE)$(OS_RELEASE)/WINNT6.0/' config.mk
./configure
make -j$(nproc)
