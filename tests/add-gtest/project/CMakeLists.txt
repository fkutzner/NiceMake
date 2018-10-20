cmake_minimum_required(VERSION 3.10)
project(add-gtest)

include(../../../NiceMake.cmake)

nm_add_gtest()

add_executable(testbin Test.cpp)
target_link_libraries(testbin gtest gtest_main)
