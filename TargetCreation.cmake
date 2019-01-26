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

nm_include_guard(NM_TARGETCREATION_CMAKE_INCLUDED)

include(${CMAKE_CURRENT_LIST_DIR}/NiceMakeConfig.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/detail/TargetProperties.cmake)

set(NM_EMPTY_CPP_FILE ${CMAKE_CURRENT_LIST_DIR}/empty.cpp)

include(${CMAKE_CURRENT_LIST_DIR}/CompilerFlags.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/Platform.cmake)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

function(nm_add_library NAME KIND)
  if((KIND MATCHES "OBJECT") AND (CMAKE_VERSION VERSION_LESS "3.12"))
    # Pre-3.12 CMake has incomplete support for object libraries, e.g.
    # no way of importing compile options and include dirs via
    # target_link_libraries:
    message(FATAL_ERROR "NiceMake supports object libraries only with CMake 3.12 and later")
  endif()

  string(REPLACE "." "/" FOLDER_NAME ${NAME})

  set(nm_target_include_dir "${PROJECT_SOURCE_DIR}/${NM_CONF_INCLUDE_DIR}/${FOLDER_NAME}")
  file(GLOB LIBRARY_HEADERS "${nm_target_include_dir}/*.h"
                            "${nm_target_include_dir}/*.hh"
                            "${nm_target_include_dir}/*.hpp"
                            "${nm_target_include_dir}/*.hxx"
                            "${nm_target_include_dir}/*.H")

  if(${KIND} STREQUAL "OBJECT-STATIC" OR ${KIND} STREQUAL "OBJECT-SHARED")
    set(simple_kind "OBJECT")
  else()
    set(simple_kind ${KIND})
  endif()

  add_library(${NAME} ${simple_kind} ${LIBRARY_HEADERS} ${ARGN})
  set_property(TARGET "${NAME}" PROPERTY FOLDER "Libraries/${FOLDER_NAME}")
  set_property(TARGET "${NAME}" PROPERTY PROJECT_LABEL "Library")

  target_link_libraries(${NAME} ${NM_THIRDPARTY_LIBS})
  nm_detail_add_compile_options_to_lib(${NAME} ${KIND})

  target_include_directories(${NAME} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/${NM_CONF_INCLUDE_DIR}>)
endfunction()

function(nm_add_dummy_library NAME)
  nm_add_library(${NAME} STATIC ${NM_EMPTY_CPP_FILE})
endfunction()

function(nm_add_header_only_library NAME KIND)
  nm_add_library(${NAME} ${KIND} ${NM_EMPTY_CPP_FILE} ${ARGN})
endfunction()

function(nm_add_tool NAME)
  string(REPLACE "." "/" FOLDER_NAME ${NAME})

  set(nm_target_include_dir "${PROJECT_SOURCE_DIR}/${NM_CONF_TOOLS_DIR}/${FOLDER_NAME}")
  file(GLOB ${TOOL_HEADERS} "${nm_target_include_dir}/*.h")

  add_executable(${NAME} ${TOOL_HEADERS} ${ARGN})
  set_property(TARGET "${NAME}" PROPERTY FOLDER "Tools/${FOLDER_NAME}")
  set_property(TARGET "${NAME}" PROPERTY PROJECT_LABEL "Tool")

  target_link_libraries(${NAME} PRIVATE ${NM_THIRDPARTY_LIBS})
  target_compile_options(${NAME} PRIVATE ${NM_TOOL_COMPILE_OPTS})
  target_compile_definitions(${NAME} PRIVATE ${NM_TOOL_COMPILE_DEFS})
  target_include_directories(${NAME} PRIVATE ${PROJECT_SOURCE_DIR}/${NM_CONF_INCLUDE_DIR})
  target_include_directories(${NAME} PRIVATE ${nm_target_include_dir})
endfunction()
