# oolite-msys2-mingw64
Sets up a developer environment and builds oolite from scratch

:warning: This is **not yet functional** but is a work-in-progress.

## Instructions for building on your own computer

Download MSYS2 from https://www.msys2.org/ and install it.

Open MSYS2 Mingw64 and ensure that it is up-to-date by running `pacman -Syu` You may need to do this twice.

Download the oolite-from-fresh-msys2-mingw64.sh script from this repository into your home directory and run it. This script will then install all needed dependencies and configure them if necessary. It will then attempt to build Oolite.

...Success?

## GitHub Actions

We also try to build all Oolite Windows targets using GitHub Actions, splitting each dependency into its own build job.
