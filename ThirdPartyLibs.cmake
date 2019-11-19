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

nm_include_guard(NM_THIRDPARTYLIBS_CMAKE_INCLUDED)

set(NM_THIRDPARTY_LIBS)

macro(nm_add_thirdparty_libs)
  cmake_parse_arguments(
    P_ARGS
    ""
    "NAME"
    "LIBS;INTERFACE_INCLUDE_DIRS;INTERFACE_COMPILE_OPTIONS;INTERFACE_SYSTEM_INCLUDE_DIRECTORIES"
    ${ARGN}
  )

  if(NOT P_ARGS_LIBS)
    message(FATAL_ERROR "nm_add_thirdparty_lib: LIBS must be specified")
  endif()

  if(P_ARGS_NAME)
    set(nm_dummy_target_name ${P_ARGS_NAME})
    add_library(${nm_dummy_target_name} INTERFACE)
    target_link_libraries(${nm_dummy_target_name} INTERFACE ${P_ARGS_LIBS})
    target_compile_options(${nm_dummy_target_name} INTERFACE ${P_ARGS_INTERFACE_COMPILE_OPTIONS})
    if(P_ARGS_INTERFACE_INCLUDE_DIRS)
      target_include_directories(${nm_dummy_target_name} INTERFACE ${P_ARGS_INTERFACE_INCLUDE_DIRS})
    endif()

    if(P_ARGS_INTERFACE_SYSTEM_INCLUDE_DIRECTORIES)
      target_include_directories(${nm_dummy_target_name} SYSTEM INTERFACE ${P_ARGS_INTERFACE_SYSTEM_INCLUDE_DIRECTORIES})
    endif()

    list(APPEND NM_THIRDPARTY_LIBS ${nm_dummy_target_name})
  else()
    if(P_ARGS_INTERFACE_INCLUDE_DIRS OR P_ARGS_INTERFACE_COMPILE_OPTIONS)
      message(FATAL_ERROR "nm_add_thirdparty_lib: INTERFACE_INCLUDE_DIRS and INTERFACE_COMPILE_OPTIONS can only be specified in conjunction with NAME")
    endif()

    list(APPEND NM_THIRDPARTY_LIBS ${P_ARGS_LIBS})
  endif()
endmacro()
