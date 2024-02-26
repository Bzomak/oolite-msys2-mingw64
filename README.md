# oolite-msys2
This repository sets up a developer environment in MSYS2 that is capable of building Oolite from scratch.

:warning: This is **not yet functional** but is a work-in-progress.

This is set up to be able to build Oolite both locally on your own computer, and remotely through the use of GitHub Actions.

It will install all tools and dependencies either from the package manager or from source that are needed to build Oolite, and then configure them if necessary.

## Instructions for building on your own computer

This script will download and install everything needed for a development environment for Oolite.

- First download MSYS2 from https://www.msys2.org/ and install it.
- Open MSYS2 Mingw64 and ensure that it is up-to-date by running `pacman -Syu`. You may need to do this twice.
- Clone this repository. If you do this within MSYS2 then you may need to install git (`pacman -S git`)
- `cd` into the repository's directory
- Run the `oolite-from-fresh-msys2-mingw64.sh` script. This calls the build scripts for each dependency sequentially. It finishes by building Oolite. By default, this is a release version of Oolite from the master branch of https://github.com/OoliteProject/oolite, but you can pass optional flags `-b` to change the build type and `-r` to provide an alternative git ref of either a different branch or a tag.

## GitHub Actions

This builds all Oolite Windows targets using a GitHub Actions matrix strategy, splitting each dependency into its own build job to parallise building where possible. Each stage only downloads what it needs. The workflow finishes by creating installers for the successful build of Oolite, which can then be downloaded and installed onto your computer.

### Caching

In order to try and speed up the builds, we use caching of dependencies from previous successful builds where possible.

If calling the workflow using `workflow dispatch` then there is the option to "build from fresh", and not use any pre-built caches at all. If a cache with the same key already exists, then it is deleted immediately before a new cache is saved. Theoretically, another job in another workflow could attempt to use the cache between it being deleted and between the new one being saved. This should be unlikely, and it would be a very small window in which this could happen. My recommendation if this happened would to be to re-run the workflow, which should hopefully then run without incident.

The Oolite builds themselves are cached, so that they can be used in the next job in the building of the installers. However, they are not intended to be used between workflows or workflow runs, and so are deleted at the end of the workflow run to save space.

Each dependency is cached so as to be able to be used between jobs in multiple workflow runs. They use a carefully crafted `cache-key` that contains a hash of both the workflow's action yaml file, and the any folder that contain's information for the dependency to build. Therefore, any time there is a change to either the dependency, or the workflow, the dependency's cache will need to be regenerated.

#### Examples

The tools-make cache-key is: `cache-tools-make-${{ hashFiles('**/.github/workflows/msys2-mingw64-actions-split.yml', '**/deps/tools-make/*') }}`

This cache will be rebuilt when either the workflow, or anything in the tools-make folder is changed.

The libs-base cache-key is: `cache-libs-base-${{ hashFiles('**/.github/workflows/msys2-mingw64-actions-split.yml', '**/deps/libs-base/*', '**/deps/tools-make/*') }}`

As libs-base depends on tools-make, we must include the tools-make folder in the cache key. This cache will therefore be rebuilt when there are any changes to either the workflow, anything in the libs-base folder, or anything in the tools-make folder.

#### Limitations

As per GitHub's [usage limits](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows#usage-limits-and-eviction-policy) any caches that have not been accessed in over 7 days will be removed. If more than 10GB of cache data is saved, then the oldest caches will be removed. Since the transient Oolite build caches are removed, I do not anticipate the data limit to be an issue. It is, however, quite possible that viable caches may not be used for more than 7 days - I work on this as and when I have the energy and the mood takes me.

Should the caches be removed, this will not be a problem - caching between builds is a useful speed-up, not a requirement.

## Differences between the two build processes

- The from-fresh script builds everything sequentially; the GitHub Actions workflow builds as much in parallel as possible.
- The from-fresh script downloads everything that it needs to build Oolite and all its dependencies; the GitHub Actions workflow will only download what it needs within each separate build job.
- Once the from-fresh script has finished, you will have a fully functional development environment for Oolite which you can work with; Once the GitHub Actions workflow has finished, you will only be able to download the installers and read the build logs.
- The from-fresh script does not generate the .pdf documentation from the .odt files; the GitHub Actions workflow generates these and they are included in the installed package.

## Roadmap

I have currently set four key milestones for development of this project, into which I sort any issues and ideas for new features I have. While in theory one would steadily work through each milestone sequentially, in practice I work on whatever I feel excited by and piques my interest at that moment in time. These milestones are:

1. Functional Build - We can successfully build and run Oolite.
2. Stable Build - The infrastructure is robust enough that it could be considered usable by the Oolite maintainers.
3. Additional Features - Fancy features not necessary for the building of Oolite
4. Ideas for the Future - These are not related to building Oolite on MSYS2 with mingw64, but building Oolite on other platforms with other compilers.

As noted above, if this project is ultimately successful, then there are ambitions to expand this modular build methodology to work with compilers and on other platforms. However, development is slow, and this is a long way off...
