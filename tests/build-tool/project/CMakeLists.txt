cmake_minimum_required(VERSION 3.10)
project(build-lib)
include(../../../NiceMake.cmake)

nm_add_tool_compiler_flags(-DMAGIC_NUMBER=43)
add_subdirectory(tools)
