cmake_minimum_required(VERSION 3.6)
project(add-gtest)

include(../../../NiceMake.cmake)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
nm_add_gtest()

add_executable(testbin Test.cpp)
target_link_libraries(testbin gtest gtest_main)
