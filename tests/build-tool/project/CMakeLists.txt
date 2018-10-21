cmake_minimum_required(VERSION 3.6)
project(build-lib)
include(../../../NiceMake.cmake)

nm_add_tool_compile_options(-DMAGIC_NUMBER=43)
add_subdirectory(tools)
