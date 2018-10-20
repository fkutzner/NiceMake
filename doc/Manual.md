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
