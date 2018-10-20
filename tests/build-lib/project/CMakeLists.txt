cmake_minimum_required(VERSION 3.10)
project(build-lib)
include(../../../NiceMake.cmake)

option(LIB_BUILD_MODE "The library build mode (STATIC, SHARED, OBJECT, OBJECT-STATIC or OBJECT-SHARED)" "STATIC")

nm_add_lib_compiler_flags(PUBLIC -DMAGIC_NUMBER=42)
add_subdirectory(lib)

if((LIB_BUILD_MODE STREQUAL "STATIC") OR (LIB_BUILD_MODE STREQUAL "SHARED"))
  add_executable(run run.cpp)
  target_link_libraries(run PRIVATE testlib.testmodule)
  target_compile_options(run PRIVATE -DHAVE_MAGIC_NUMBER)
else()
  add_executable(run run.cpp $<TARGET_OBJECTS:testlib.testmodule>)
  target_include_directories(run PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
endif()
