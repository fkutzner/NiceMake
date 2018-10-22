# Changelog

The format of this file is based on [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/).

## [unreleased]
### Added
- `nm_add_gtest`, a function downloading Google Test and
  adding it to the build
- `nm_add_header_only_library`, a function for defining header-only library
  targets
- Testing on Cygwin and Windows
- Added `nm_add_compile_definitions` and `nm_add_tool_compile_definitions`
- Add option for suppressing sanitizer CMake option exports

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
