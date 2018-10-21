cmake_minimum_required(VERSION 3.6)
project(build-lib)
include(../../../NiceMake.cmake)

option(LIB_BUILD_MODE "The library build mode (STATIC, SHARED, OBJECT, OBJECT-STATIC or OBJECT-SHARED)" "STATIC")

nm_add_lib_compile_options(PUBLIC -DMAGIC_NUMBER_A=21)
nm_add_lib_compile_definitions(PUBLIC -DMAGIC_NUMBER_B=21)

if(LIB_BUILD_MODE STREQUAL "SHARED")
  nm_add_lib_compile_options(PUBLIC -DNM_SHARED_LIB)
  nm_add_lib_compile_options(PRIVATE -DBUILDING_NM_SHARED_LIB)
endif()

# For SymbolVisibility.h:
include_directories(../../include)

add_subdirectory(lib)

if((LIB_BUILD_MODE STREQUAL "STATIC") OR (LIB_BUILD_MODE STREQUAL "SHARED"))
  add_executable(run run.cpp)
  target_link_libraries(run PRIVATE testlib.testmodule)
  target_compile_options(run PRIVATE -DHAVE_MAGIC_NUMBER)
else()
  add_executable(run run.cpp $<TARGET_OBJECTS:testlib.testmodule>)
  target_include_directories(run PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
endif()
