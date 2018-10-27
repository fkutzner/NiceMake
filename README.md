# NiceMake 0.1.0
A collection of commonly useful CMake functions for C and C++ projects

## Introduction

NiceMake is a collection of CMake scripts for quickly setting up C and C++
projects, providing generic functionality such as (so far):

* platform and compiler-family detection
* Clang/GCC sanitizer setup
* third-party library handling
* a thin wrapper for `add_library` which adds compiler flags,
  include directories and third-party library dependencies

NiceMake uses the convention-over-configuration approach, using default project
layout conventions close to those used by the [LLVM
project](https://github.com/llvm-mirror/llvm). See the
[examples](doc/Examples.md) or the [manual](doc/Manual.md) for further details.

NiceMake is free software distributed under the
[MIT license (X11 variant)](doc/License.md).

## Scope

NiceMake aims to provide the functionality useful for most CMake-based C and
C++ projects with a relatively simple project structure. It is non-intrusive
in the sense that it can be easily used with plain CMake code (for example,
targets defined using the `add_library` wrapper are regular CMake targets
with no new magic attached). NiceMake functions should be short, light on
dependencies and easy to understand. Thus, NiceMake is _not_ a framework that
is difficult to escape.

## Documentation

See the [NiceMake manual](doc/Manual.md). There is also
a [Changelog](CHANGELOG.md).

## Requirements

NiceMake 0.1.0 requires CMake version 3.6.

## Getting started

1. Copy NiceMake somewhere into your project, e.g. to the directory
   `cmake/nicemake` (such that `cmake/nicemake/NiceMake.cmake` exists). If you
   use git, you could simply dd the NiceMake repository as a submodule.
2. In your toplevel `CMakeLists.txt`, include NiceMake by inserting the line
   `include(cmake/nicemake/NiceMake.cmake)`
3. See the [examples](doc/Examples.md) or the [manual](doc/Manual.md).


## Versions

This project uses [semantic versioning](https://semver.org/). In short: as soon
as NiceMake has reached version 1.0.0,
* no breaking changes are introduced with minor-version or patchlevel updates,
  e.g. you can update the NiceMake from 1.2.2 to 1.3.1 without worrying about
  compatibility.
* breaking changes (e.g. increasing the required CMake version) may be
  introduced with major-version updates, e.g. with version 2.0.0.
