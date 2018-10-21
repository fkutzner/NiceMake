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

    if(NOT ${simple_kind} STREQUAL "OBJECT")
      target_link_libraries(${NAME} ${NM_THIRDPARTY_LIBS})
    else()
      # Import interface definitions
      foreach(third_party_lib ${NM_THIRDPARTY_LIBS})
        get_target_property(interface_includes ${third_party_lib} INTERFACE_INCLUDE_DIRECTORIES)
        get_target_property(interface_comp_opts ${third_party_lib} INTERFACE_COMPILE_OPTIONS)
        get_target_property(interface_comp_defs ${third_party_lib} INTERFACE_COMPILE_DEFINITIONS)

        if(interface_includes)
          target_include_directories(${NAME} PRIVATE ${interface_includes})
        endif()

        if(interface_comp_opts)
          target_compile_options(${NAME} PRIVATE ${interface_comp_opts})
        endif()

        if(interface_comp_defs)
          target_compile_definitions(${NAME} PRIVATE ${interface_comp_defs})
        endif()
      endforeach()
    endif()

    # When building Linux shared objects with OBJECT libraries, -fPIC needs
    # to be passed to the compiler explicitly:
    if(${KIND} STREQUAL "OBJECT-SHARED"
       AND NM_COMPILING_WITH_GNULIKE AND NM_PLATFORM_REQUIRES_EXTRA_PIC_FOR_DSO)
      target_compile_options(${NAME} PRIVATE -fPIC)
    endif()

    foreach(scope IN ITEMS PUBLIC PRIVATE INTERFACE)
      target_compile_options(${NAME} ${scope} ${NM_LIB_COMPILER_FLAGS_${scope}})
      target_compile_definitions(${NAME} ${scope} ${NM_LIB_COMPILER_DEFS_${scope}})
    endforeach()

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
    target_compile_options(${NAME} PUBLIC ${NM_TOOL_COMPILER_FLAGS})
    target_compile_definitions(${NAME} PUBLIC ${NM_TOOL_COMPILER_DEFS})
    target_include_directories(${NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include)
    target_include_directories(${NAME} PUBLIC ${nm_target_include_dir})
  endfunction()

  set(NM_TARGETCREATION_CMAKE_INCLUDED TRUE)
endif()
