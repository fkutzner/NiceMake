cmake_minimum_required(VERSION 3.10)
project(build-lib)
include(../../../NiceMake.cmake)

add_subdirectory(dummy-thirdparty-libs)

nm_add_thirdparty_libs(LIBS modern-thirdparty-lib)
nm_add_thirdparty_libs(NAME tradlib LIBS traditional-thirdparty-lib
                       INTERFACE_INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/dummy-thirdparty-libs/traditional
                       INTERFACE_COMPILE_OPTIONS -DHAVE_TRADITIONAL_TPL)

add_subdirectory(lib)
add_subdirectory(tools)
