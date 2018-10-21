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

if(NOT NM_TARGETCREATION_CMAKE_INCLUDED)
  include(${CMAKE_CURRENT_LIST_DIR}/detail/TargetProperties.cmake)

  set(NM_EMPTY_CPP_FILE ${CMAKE_CURRENT_LIST_DIR}/empty.cpp)

  include(${CMAKE_CURRENT_LIST_DIR}/CompilerFlags.cmake)
  include(${CMAKE_CURRENT_LIST_DIR}/Platform.cmake)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)

  function(nm_add_library NAME KIND)
    string(REPLACE "." "/" FOLDER_NAME ${NAME})

    set(nm_target_include_dir "${PROJECT_SOURCE_DIR}/include/${FOLDER_NAME}")
    file(GLOB LIBRARY_HEADERS "${nm_target_include_dir}/*.h")

    if(${KIND} STREQUAL "OBJECT-STATIC" OR ${KIND} STREQUAL "OBJECT-SHARED")
      set(simple_kind "OBJECT")
    else()
      set(simple_kind ${KIND})
    endif()

    add_library(${NAME} ${simple_kind} ${LIBRARY_HEADERS} ${ARGN})
    set_property(TARGET "${NAME}" PROPERTY FOLDER "Libraries/${FOLDER_NAME}")
    set_property(TARGET "${NAME}" PROPERTY PROJECT_LABEL "Library")

    nm_detail_link_thirdpartylibs_to_lib(${NAME} ${simple_kind})
    nm_detail_add_compile_options_to_lib(${NAME} ${KIND})

    target_include_directories(${NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include)
  endfunction()

  function(nm_add_dummy_library NAME)
    nm_add_library(${NAME} STATIC ${NM_EMPTY_CPP_FILE})
  endfunction()

  function(nm_add_header_only_library NAME KIND)
    nm_add_library(${NAME} ${KIND} ${NM_EMPTY_CPP_FILE} ${ARGN})
  endfunction()

  function(nm_add_tool NAME)
    string(REPLACE "." "/" FOLDER_NAME ${NAME})

    set(nm_target_include_dir "${PROJECT_SOURCE_DIR}/tools/${FOLDER_NAME}")
    file(GLOB ${TOOL_HEADERS} "${nm_target_include_dir}/*.h")

    add_executable(${NAME} ${TOOL_HEADERS} ${ARGN})
    set_property(TARGET "${NAME}" PROPERTY FOLDER "Tools/${FOLDER_NAME}")
    set_property(TARGET "${NAME}" PROPERTY PROJECT_LABEL "Tool")

    target_link_libraries(${NAME} ${NM_THIRDPARTY_LIBS})
    target_compile_options(${NAME} PUBLIC ${NM_TOOL_COMPILE_OPTS})
    target_compile_definitions(${NAME} PUBLIC ${NM_TOOL_COMPILE_DEFS})
    target_include_directories(${NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include)
    target_include_directories(${NAME} PUBLIC ${nm_target_include_dir})
  endfunction()

  set(NM_TARGETCREATION_CMAKE_INCLUDED TRUE)
endif()
