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

if(NOT NM_DOXYGEN_CMAKE_INCLUDED)
  include(${CMAKE_CURRENT_LIST_DIR}/NiceMakeConfig.cmake)

  function(nm_add_doxygen)
    cmake_parse_arguments(
      P_ARGS
      ""
      "CONFIG_FILE;DOCS_BUILD_DIR"
      ""
      ${ARGN}
    )

    if(NOT P_ARGS_CONFIG_FILE)
      set(P_ARGS_CONFIG_FILE ${NM_SOURCE_DIR}/DoxygenGenericCfg.in)
    endif()
    if(NOT P_ARGS_DOCS_BUILD_DIR)
      set(P_ARGS_DOCS_BUILD_DIR ${CMAKE_BINARY_DIR}/doc)
    endif()

    find_package(Doxygen)

    if(DOXYGEN_FOUND)
      configure_file(${P_ARGS_CONFIG_FILE} ${P_ARGS_DOCS_BUILD_DIR}/DoxygenCfg)
      add_custom_target(doxygen ${DOXYGEN_EXECUTABLE} ${P_ARGS_DOCS_BUILD_DIR}/DoxygenCfg WORKING_DIRECTORY ${P_ARGS_DOCS_BUILD_DIR})
    else()
      message(WARNING "The target 'doxygen' could not be created because Doxygen could not be found.")
    endif()
  endfunction()

  set(NM_DOXYGEN_CMAKE_INCLUDED TRUE)
endif()
