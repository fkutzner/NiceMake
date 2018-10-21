# Changelog

The format of this file is based on [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/).

## [unreleased]
### Added
- `nm_add_gtest`, a function downloading Google Test and
  adding it to the build
- `nm_add_header_only_library`, a function for defining header-only library
  targets
- Testing on Cygwin

### Changed
- `nm_add_lib_compiler_flags` now expects `PRIVATE`,
  `PUBLIC` or `INTERFACE` as its first argument, controlling
  the export of compiler flags.
- Lowered the required CMake version to 3.6
