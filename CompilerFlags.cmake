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

nm_include_guard(NM_COMPILERFLAGS_CMAKE_INCLUDED)

include(${CMAKE_CURRENT_LIST_DIR}/Platform.cmake)

set(NM_LIB_COMPILE_OPTS_PRIVATE)
set(NM_LIB_COMPILE_OPTS_PUBLIC)
set(NM_LIB_COMPILE_OPTS_INTERFACE)
set(NM_TOOL_COMPILE_OPTS)

set(NM_LIB_COMPILER_DEFS_PRIVATE)
set(NM_LIB_COMPILER_DEFS_PUBLIC)
set(NM_LIB_COMPILER_DEFS_INTERFACE)
set(NM_TOOL_COMPILE_DEFS)


macro(nm_add_lib_compile_options SCOPE)
  if((NOT "${SCOPE}" STREQUAL "PRIVATE")
     AND (NOT "${SCOPE}" STREQUAL "PUBLIC")
     AND (NOT "${SCOPE}" STREQUAL "INTERFACE"))
    message(FATAL_ERROR "nm_add_compile_options: SCOPE must be one of PRIVATE, PUBLIC or INTERFACE (is: ${SCOPE})")
  endif()
  list(APPEND NM_LIB_COMPILE_OPTS_${SCOPE} ${ARGN})
endmacro()

macro(nm_add_tool_compile_options)
  list(APPEND NM_TOOL_COMPILE_OPTS ${ARGN})
endmacro()

macro(nm_add_compile_options SCOPE)
  nm_add_lib_compile_options(${SCOPE} ${ARGN})
  nm_add_tool_compile_options(${ARGN})
endmacro()


macro(nm_add_lib_compile_definitions SCOPE)
  if((NOT "${SCOPE}" STREQUAL "PRIVATE")
     AND (NOT "${SCOPE}" STREQUAL "PUBLIC")
     AND (NOT "${SCOPE}" STREQUAL "INTERFACE"))
    message(FATAL_ERROR "nm_add_compile_definitions: SCOPE must be one of PRIVATE, PUBLIC or INTERFACE (is: ${SCOPE})")
  endif()
  list(APPEND NM_LIB_COMPILER_DEFS_${SCOPE} ${ARGN})
endmacro()

macro(nm_add_tool_compile_definitions)
  list(APPEND NM_TOOL_COMPILE_DEFS ${ARGN})
endmacro()

macro(nm_add_compile_definitions SCOPE)
  nm_add_lib_compile_definitions(${SCOPE} ${ARGN})
  nm_add_tool_compile_definitions(${ARGN})
endmacro()


function(nm_enable_release_assertions)
  list(REMOVE_ITEM CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG" "/DNDEBUG")
  list(REMOVE_ITEM CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG" "/DNDEBUG")
  list(REMOVE_ITEM CMAKE_CXX_FLAGS_MINSIZEREL "-DNDEBUG" "/DNDEBUG")

  set(ndebug_regex "(^|\\ )[-/]DNDEBUG(\$|\\ )")

  string(REGEX REPLACE "${ndebug_regex}" "" CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
  string(REGEX REPLACE "${ndebug_regex}" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
  string(REGEX REPLACE "${ndebug_regex}" "" CMAKE_CXX_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL})

  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL}" PARENT_SCOPE)
endfunction()

macro(nm_enforce_lang_standard_adherence)
  if(NM_COMPILING_WITH_GNULIKE)
    nm_add_compile_options(PRIVATE -pedantic-errors)
  elseif(NM_COMPILING_WITH_MSVC)
    nm_add_compile_options(PRIVATE /permissive-)
  endif()
endmacro()

macro(nm_use_high_compiler_warning_level)
  if(NM_COMPILING_WITH_GNULIKE)
    nm_add_compile_options(PRIVATE -Wall -Wextra -Wpedantic)
  elseif(NM_COMPILING_WITH_MSVC)
    nm_add_compile_options(PRIVATE /W3)
  endif()
endmacro()

macro(nm_set_rtti_enabled enabledness)
  if(NM_COMPILING_WITH_GNULIKE)
    if(enabledness)
      nm_add_compile_options(PRIVATE -frtti)
    else()
      nm_add_compile_options(PRIVATE -fno-rtti)
    endif()
  elseif(NM_COMPILING_WITH_MSVC)
    if(enabledness)
      nm_add_compile_options(PRIVATE /GR)
    else()
      nm_add_compile_options(PRIVATE /GR-)
    endif()
  endif()
endmacro()
