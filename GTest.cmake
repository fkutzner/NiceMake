# Copyright (c) 2018 Felix Kutzner
#
# This file originated from the nicemake project
# (https://github.com/fkutzner/nicemake). See README.md for details
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Except as contained in this notice, the name(s) of the above copyright holders
# shall not be used in advertising or otherwise to promote the sale, use or
# other dealings in this Software without prior written authorization.

if(NOT NM_GTEST_CMAKE_INCLUDED)

  if(NOT NM_CONF_GTEST_TAG)
    set(NM_CONF_GTEST_TAG "release-1.8.1")
  endif()

  if(NOT NM_CONF_GTEST_REPOSITORY)
    set(NM_CONF_GTEST_REPOSITORY "https://github.com/google/googletest.git")
  endif()

  set(NM_GTEST_PROJECT_FILE ${CMAKE_CURRENT_LIST_DIR}/GTestDownload.cmake.in)
  set(NM_GTEST_SETUP_FILE ${CMAKE_CURRENT_LIST_DIR}/GTestBuild.cmake.in)

  function(nm_add_gtest)
    # Followed approach: https://github.com/google/googletest/blob/master/googletest/README.md#incorporating-into-an-existing-cmake-project

    configure_file(${NM_GTEST_PROJECT_FILE} gtest-download/CMakeLists.txt)
    configure_file(${NM_GTEST_SETUP_FILE} gtest-src-wrap/CMakeLists.txt)

    # Download gtest:
    execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
                    RESULT_VARIABLE result
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/gtest-download )
    if(result)
      message(FATAL_ERROR "Downloading gtest failed at configure step: ${result}")
    endif()

    execute_process(COMMAND ${CMAKE_COMMAND} --build .
                    RESULT_VARIABLE result
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/gtest-download )
    if(result)
      message(FATAL_ERROR "Downloading gtest failed at build step: ${result}")
    endif()

    # Add gtest to the build:
    add_subdirectory(${CMAKE_BINARY_DIR}/gtest-src-wrap
                     ${CMAKE_BINARY_DIR}/gtest-build
                     EXCLUDE_FROM_ALL)

  endfunction()

  set(NM_GTEST_CMAKE_INCLUDED TRUE)
endif()
