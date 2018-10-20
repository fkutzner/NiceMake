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

if(NOT NM_COMPILERFLAGS_CMAKE_INCLUDED)
  set(NM_LIB_COMPILER_FLAGS_PRIVATE)
  set(NM_LIB_COMPILER_FLAGS_PUBLIC)
  set(NM_LIB_COMPILER_FLAGS_INTERFACE)
  set(NM_TOOL_COMPILER_FLAGS)

  macro(nm_add_lib_compiler_flags KIND)
    if((NOT "${KIND}" STREQUAL "PRIVATE")
       AND (NOT "${KIND}" STREQUAL "PUBLIC")
       AND (NOT "${KIND}" STREQUAL "INTERFACE"))
      message(FATAL_ERROR "nm_add_compiler_flags: KIND must be one of PRIVATE, PUBLIC or INTERFACE (is: ${KIND})")
    endif()
    list(APPEND NM_LIB_COMPILER_FLAGS_${KIND} ${ARGN})
  endmacro()

  macro(nm_add_tool_compiler_flags)
    list(APPEND NM_TOOL_COMPILER_FLAGS ${ARGN})
  endmacro()

  macro(nm_add_compiler_flags KIND)
    nm_add_lib_compiler_flags(${KIND} ${ARGN})
    nm_add_tool_compiler_flags(${ARGN})
  endmacro()

  set(NM_COMPILERFLAGS_CMAKE_INCLUDED TRUE)
endif()
