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

if(NOT NM_THIRDPARTYLIBS_CMAKE_INCLUDED)

  set(NM_THIRDPARTY_LIBS)

  macro(nm_add_thirdparty_lib NAME)
    set(nm_libs "TODO")
    set(nm_include_dirs "TODO")
    set(nm_public_compile_opts "TODO")


    set(nm_dummy_target_name nm_${NAME})

    add_library(${nm_dummy_target_name} STATIC ${CMAKE_CURRENT_LIST_DIR}/empty.cpp)
    target_link_libraries(${nm_dummy_target_name} PUBLIC ${nm_libs})
    target_include_directories(${nm_dummy_target_name} PUBLIC ${nm_include_dirs})
    target_compile_options(${nm_dummy_target_name} PUBLIC ${nm_public_compile_opts})
    list(APPEND NM_THIRDPARTY_LIBS ${nm_dummy_target_name})
  endmacro()

  set(NM_THIRDPARTYLIBS_CMAKE_INCLUDED TRUE)
endif()
