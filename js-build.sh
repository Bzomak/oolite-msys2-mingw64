#! /usr/bin/bash -v

###############################

# Configure and build SpiderMonkey

###############################

cp msys2-mingw64.mk mozilla-2.0/js/src/ref-config/
cd mozilla-2.0/js/src
sed -i '106 s/$(OS_ARCH)$(OS_OBJTYPE)$(OS_RELEASE)/msys2-ming64/' config.mk
./configure
make -j$(nproc)
