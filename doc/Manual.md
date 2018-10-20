# NiceMake Manual

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

## Using NiceMake in CMake projects

To use NiceMake in your CMake project, include the file
`NiceMake.cmake`.

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
> `nm_add_lib_compiler_flags` function are added to the
> created target.
>
> If the created target is not an `OBJECT` or `OBJECT-SHARED`
> library, all third-party libraries previously registered with
> `nm_add_thirdparty_libs` are linked to the target.
>
> Let `<path>` be the
> result of substituting all dot characters in `<name>`
> by path separators.
> All header files contained in `include/<path>` are added
> to the target as source files. The created target is added
> to the CMake folder `Libraries/<path>`.


## Using third-party libraries

## Sanitizers
