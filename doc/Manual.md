# NiceMake Manual

Table of contents:

* [1. Supported platforms](#supported-platforms)
* [2. Project layout](#project-layout)
* [3. Configuring NiceMake](#configuring-nicemake)
* [4. Using NiceMake in CMake projects](#using-nicemake-in-cmake-projects)
* [5. Setting compiler options](#setting-compiler-options)
* [6. Defining libraries and tools](#defining-libraries-and-tools)
* [7. Compiler and platform detection helpers](#compiler-and-platform-detection-helpers)
* [8. Using third-party libraries](#using-third-party-libraries)
* [9. Sanitizers](#sanitizers)
* [10. Adding Google Test to your project](#adding-google-test-to-your-project)

## Supported platforms

NiceMake currently supports the following platforms:

* Apple macOS (clang, gcc)
* GNU/Linux (clang, gcc)
* Microsoft Windows (Visual C++)

Planned:

* Microsoft Windows: Cygwin, MinGW

## Project layout

NiceMake is geared for a project structure similar
to the structure used by the [LLVM
project](https://github.com/llvm-mirror/llvm): the project
defines a set of libraries within the toplevel directory
`lib`, with the corresponding public header files being
contained in the toplevel directory `include`. Executables
are defined in the toplevel directory `tools`.

Each library `<L>` is defined in the directory `lib/<L>`
and may be organized in _modules_ `<m1>, ..., <mN>`
(contained in `lib/<L>/<m1>, ...`).
Each module defines a library target, and modules may be
organized in further modules placed in
subdirectories. NiceMake uses a naming convention for
library targets defined in `lib`: the target's name
consists of the path to the module relative to `lib`,
with path separators replaced by dots. For example, the
library target defined in `lib/<a>/<b>/<c>` is named
`<a>.<b>.<c>`.

The directory structure of the `include` directory
mirrors the directory structure of `lib`, with
`include/<PATH>` containing the public headers of the
files contained in `lib/<PATH>`.

Finally, each executable `<x>` is defined in
the directory `tools/<x>`. Analogously to libraries,
executables may be organized in a module structure.
However, executables do not have public header files
and thus are not represented in the `include` directory.

Example:

```
lib/
  quux/                 # defines library target quux
    module1/            # defines library target quux.module1
      submodule1/       # defines library target quux.module1.submodule1
        src.cpp
        ...
      ...
    module2/            # defines library target quux.module2
      ...
    ...
  ...

include/                # not required to contain CMakeLists.txt files
  quux/
    module1/
      submodule1/
        src.h
        ...
      ...
    module2/
    ...
  ...

tools/
  quux-cli/            # defines executable target quux-cli
    quux-cli.cpp
    ...
  quux-fancy-cli/      # defines executable target quux-fancy-cli
    submodule1/        # defines library target quux-fancy-cli.submodule1
      ...
    ...
```

## Configuring NiceMake

To configure NiceMake, set the following variables before
including `NiceMake.cmake`:

| Variable | Description | Default value |
|----------------------------------------|
| `NM_CONF_OPTION_PREFIX` | Prefix for CMake options defined by NiceMake | `${CMAKE_PROJECT_NAME}` |
| `NM_CONF_GTEST_REPOSITORY` | The Google Test repository from which to download Google Test | `https://github.com/google/googletest.git` |
| `NM_CONF_GTEST_TAG` | The Google Test version tag to be fetched | `release-1.8.1` |

## Using NiceMake in CMake projects

To use NiceMake in your CMake project, include the file
`NiceMake.cmake`.

## Setting compiler options

Compiler options can be separately defined for
tools and libraries using the functions
`nm_add_lib_compiler_flags`, `nm_add_tool_compiler_flags`
and `nm_add_compiler_flags`:

> `nm_add_lib_compiler_flags(<flag1> [<flag2> ...])`
>
> Adds all arguments to the list of compiler flags
> to be used with library targets (see `nm_add_library()`)
> defined in the current directory and its subdirectories.
> The compiler flags are collected in the variable
> `NM_LIB_COMPILER_FLAGS`.

> `nm_add_tool_compiler_flags(<flag1> [<flag2> ...])`
>
> Adds all arguments to the list of compiler flags
> to be used with tool targets (see `nm_add_tool()`)
> defined in the current directory and its subdirectories.
> The compiler flags are collected in the variable
> `NM_TOOL_COMPILER_FLAGS`.

> `nm_add_compiler_flags(<flag1> [<flag2> ...])`
>
> Shorthand for invoking `nm_add_lib_compiler_flags`
> and `nm_add_tool_compiler_flags`, passing all arguments
> to both functions.

## Defining libraries and tools

NiceMake provides thin wrappers around
CMake's [add_library](https://cmake.org/cmake/help/v3.10/command/add_library.html)
and [add_executable](https://cmake.org/cmake/help/v3.10/command/add_executable.html)
functions, automatically adding public header files,
compiler options, include directories and links to
third-party libraries:

> `nm_add_library(<name> [STATIC | SHARED | MODULE | OBJECT |  OBJECT-SHARED] <source1> [<source2> ...])`
>
> Defines a library target `<name>` with the source
> files `<source1> [<source2> ...]` using CMake's
> `add_library` function.
>
> If the first argument is `STATIC`, `SHARED`,
> `MODULE` or `OBJECT`, the first argument is directly
> passed as the first argument to `add_library`.
> Otherwise, if it is `OBJECT-SHARED`, `OBJECT` is passed
> as the first argument to `add_library` and compiler flags
> are set up for the created target such that the objects
> can be used in a shared library.
>
> The compiler flags previously passed to the
> `nm_add_lib_compiler_flags()` function are added to the
> created target.
>
> If the created target is not an `OBJECT` or `OBJECT-SHARED`
> library, all third-party libraries previously registered via
> `nm_add_thirdparty_libs()` are linked to the target.
>
> Let `<path>` be the
> result of substituting all dot characters in `<name>`
> by path separators.
> All header files contained in `include/<path>` are added
> to the target as source files. The created target is added
> to the CMake folder `Libraries/<path>`.
>
> The toplevel directory `include` is added to the
> created target's include directories.

Following the project layout, invoke
`nm_add_library(<a>.<b>.<c> ...)` in `lib/<a>/<b>/<c>`.

Since CMake requires each library to have at least one non-header source file,
NiceMake provides a shorthand for creating libraries containing an empty C++
source file:

> `nm_add_header_only_library(<name> <kind> <header1> [<header2> ...])`
>
> Invokes `nm_add_library(<name> <kind> <E> <header1> [<header2> ...])`
> with `<E>` being the path of an empty C++ file provided by NiceMake.


Note: `nm_add_library` automatically adds the include files contained in the
directory within `include` corresponding to `<name>`. Thus, usually, invoking
`nm_add_library(somename somekind)` will suffice to create a header-only
library target. Even if you don't link the target to anything, this creates
a target exporting interface definitions. Plus, the header-only library
becomes visible in IDEs.

Add executable binaries using `nm_add_tool`:

> `nm_add_tool(<name> <source1> [<source2> ...])`
>
> Defines an executable target `<name>` with the source
> files `<source1> [<source2> ...]` using CMake's
> `add_executable` function.
>
> The compiler flags previously passed to the
> `nm_add_lib_compiler_flags()` function are added to the
> created target.
>
> All third-party libraries previously registered via
> `nm_add_thirdparty_libs()` are linked to the target.
>
> Let `<path>` be the
> result of substituting all dot characters in `<name>`
> by path separators.
> All header files contained in `tools/<path>` are added
> to the target as source files. The created target is added
> to the CMake folder `Tools/<path>`.
>
> The toplevel directory `include` is added to the
> created target's include directories.

Following the project layout, invoke
`nm_add_tool(<a> ...)` in `tools/<a>`.

## Compiler and platform detection helpers

NiceMake defines the following variables to facilitate
detecting the compiler:

* `NM_COMPILING_WITH_CLANG` is set to `true` iff the compiler
is `Clang` or `AppleClang`.
* `NM_COMPILING_WITH_GXX` is set to `true` iff the compiler
is `GNU` (i.e. `gcc`).
* `NM_COMPILING_WITH_GNULIKE` is set to `true` iff the compiler
is `GNU`, `Clang` or `AppleClang`.
* `NM_COMPILING_WITH_MSVC` is set to `true` iff the compiler
is Visual C++.

Furthermore, `NM_PLATFORM_REQUIRES_EXTRA_PIC_FOR_DSO` is set
to `true` iff the project is compiled on a Unix-like system
with Clang or GCC and the compiler option `-fPIC` is required
to be used with `OBJECT` targets which are used in shared
libraries.

## Using third-party libraries

NiceMake provides a function for adding third-party
libraries which need to be linked to all targets defined
via the `nm_add_library` and `nm_add_tool` functions.

The simpler variant can be used e.g. for libraries
looked up via CMake's `find_module` function and having
a modern module script (i.e. defining an interface library
target exporting the library's include directories and
compiler options):

> `nm_add_thirdparty_libs(LIBS <lib1> [<lib2> ...])`
>
> Adds all arguments to the list of libraries to be
> linked to tool or library targets (see the
> `nm_add_library` and `nm_add_tool` functions) defined in
> the current directory and its subdirectories. The added
> libraries are collected in the variable
> `NM_THIRDPARTY_LIBS`.
>
> Note: this variant of `nm_add_thirdparty_libs` should
> only be used for arguments `<lib1> [<lib2> ...]`
> specifying CMake targets exporting the rsp. library's
> include directories and compiler flags.

The second variant is useful for libraries that do not
have a CMake module script, or whose CMake module script
does not define an interface library target:

> `nm_add_thirdparty_libs(NAME <name> LIBS <lib1> [<lib2> ...] [INTERFACE_INCLUDE_DIRS <dir1> [<dir2> ...]] [INTERFACE_COMPILE_OPTIONS <opt1> [<opt2> ...]])`
>
> Creates an `INTERFACE` library target `<name>`
> and links `<name>` to `<lib1> [<lib2> ...]`.
> Adds the created target to the list of libraries to be
> linked to tool or library targets (see the
> `nm_add_library` and `nm_add_tool` functions) defined in
> the current directory and its subdirectories. The created
> interface library is added to `NM_THIRDPARTY_LIBS`.
>
> If `INTERFACE_INCLUDE_DIRS` is specified, adds
> `<dir1> [<dir2> ...]` to the interface target's
> interface include directories (causing CMake to add
> the include directories `<dir1> [<dir2> ...]` to all
>  targets linking to the interface library).
>
> If `INTERFACE_COMPILE_OPTIONS` is specified, adds
> `<opt1> [<opt2> ...]` to the interface target's
> interface compiler options (causing CMake to add
> the compiler options `<opt1> [<opt2> ...]` to all
> targets linking to the interface library).

## Sanitizers

NiceMake defines CMake options causing sanitizer compiler
options to be added for all targets created with
`nm_add_library` and `nm_add_tool`, and to the linker
invocation. The default value of all sanitizer options
is `OFF`.

* `${NM_OPT_PREFIX}_ENABLE_ASAN=ON` causes the address
  sanitizer to be enabled when compiling with Clang or GCC.
* `${NM_OPT_PREFIX}_ENABLE_MSAN=ON` causes the memory
  sanitizer to be enabled when compiling with Clang or GCC.
* `${NM_OPT_PREFIX}_ENABLE_TSAN=ON` causes the thread
  sanitizer to be enabled when compiling with Clang or GCC.
* `${NM_OPT_PREFIX}_ENABLE_UBSAN=ON` causes the
  undefined-behaviour sanitizer to be enabled when
  compiling with Clang or GCC.

## Adding Google Test to your project

NiceMake has a function for downloading [Google Test](https://github.com/google/googletest) and adding it to your project:

> `nm_add_gtest()`
>
> Downloads Google Test from ${NM_CONF_GTEST_REPOSITORY}
> at tag ${NM_CONF_GTEST_TAG} (see [Configuring
> NiceMake](#configuring-nicemake)) at configure time
> and adds its source directory via `add_subdirectory`.
> Google Test is compiled used the compiler flags set up
> via `nm_add_tool_compiler_flags()`.
>
> After executing this function, the targets `gtest` and
> `gtest_main` are available, exporting their include
> directories in their interface.
