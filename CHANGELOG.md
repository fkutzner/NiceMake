# Changelog

The format of this file is based on [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- `nm_add_doxygen`, a function for setting up a target for running Doxygen, optionally providing a simple default Doxygen configuration
- Experimental: `nm_collect_objs_from_subdirectories`, a
function for collecting objects of object libraries

### Changed
- The object library setup performed by `nm_add_library` now skips (and warns
  about) third-party-library targets whose exports contains
  `BUILD_INTERFACE` or `INSTALL_INTERFACE` generator expressions, since handling
  of `BUILD_INTERFACE` and `INSTALL_INTERFACE` generator expressions in this
  situation is a future feature.

### Fixed
- Fixed default setting of `NM_CONF_TOOLS_DIR`

## [0.2.0] - 2018-10-28
### Added
- `nm_add_gtest`, a function downloading Google Test and
  adding it to the build
- `nm_add_header_only_library`, a function for defining header-only library
  targets
- Testing on Cygwin and Windows
- Added `nm_add_compile_definitions` and `nm_add_tool_compile_definitions`
- Added option for suppressing sanitizer CMake option exports
- Added options for using custom toplevel directory names (i.e. other than
  `include`, `lib`, `tools`)

### Changed
- Renamed `nm_add_lib_compiler_flags` to `nm_add_lib_compile_options` and
  `nm_add_tool_compiler_flags` to `nm_add_tool_compile_options` to match
  CMake terminology
- `nm_add_lib_compile_options` now expects `PRIVATE`,
  `PUBLIC` or `INTERFACE` as its first argument, controlling the scope as
  with `target_compile_options`.
- Lowered the required CMake version to 3.6

### Fixed
- Fixed addition of sanitizer compile-options
- Fixed C++ header file globbing by also adding `*.hpp`,
  `*.hxx`, `*.hh` and `*.H` files
