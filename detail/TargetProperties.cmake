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

nm_include_guard(NM_TARGETPROPERTIES_CMAKE_INCLUDED)

#
# nm_detail_add_compile_options_to_lib(<target> <kind>)
#
# Adds NM_LIB_COMPILE_OPTS_{PUBLIC,PRIVATE,INTERFACE} to the compile options
# of <target> (with the respective scope).
# Adds NM_LIB_COMPILER_DEFS_{PUBLIC,PRIVATE,INTERFACE} to the compile
# definitions of <target> (with the respective scope).
#
# If <kind> is of type "OBJECT-SHARED", the library is set up to generate
# position-independent code if required by the platform. Otherwise, the <kind>
# argument is ignored.
#
function(nm_detail_add_compile_options_to_lib TARGET KIND)
  # When building Linux shared objects with OBJECT libraries, -fPIC needs
  # to be passed to the compiler explicitly:
  if(${KIND} STREQUAL "OBJECT-SHARED"
     AND NM_COMPILING_WITH_GNULIKE AND NM_PLATFORM_REQUIRES_EXTRA_PIC_FOR_DSO)
    # Alternatively, the POSITION_INDEPENDENT_CODE property could be set here
    # TODO: check reliability of POSITION_INDEPENDENT_CODE handling
    target_compile_options(${TARGET} PRIVATE -fPIC)
  endif()

  foreach(scope IN ITEMS PUBLIC PRIVATE INTERFACE)
    target_compile_options(${TARGET} ${scope} ${NM_LIB_COMPILE_OPTS_${scope}})
    target_compile_definitions(${TARGET} ${scope} ${NM_LIB_COMPILER_DEFS_${scope}})
  endforeach()
endfunction()
