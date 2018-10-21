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

if(NOT NM_SANITIZERS_CMAKE_INCLUDED)
  include(${CMAKE_CURRENT_LIST_DIR}/Options.cmake)
  include(${CMAKE_CURRENT_LIST_DIR}/CompilerFlags.cmake)
  include(${CMAKE_CURRENT_LIST_DIR}/Platform.cmake)


  if(NM_COMPILING_WITH_GNULIKE)
    set(sanitizer_flags)

    if(${NM_OPT_PREFIX}_ENABLE_ASAN)
      list(APPEND sanitizer_flags -fsanitize=address)
    endif()

    if(${NM_OPT_PREFIX}_ENABLE_MSAN)
      list(APPEND sanitizer_flags -fsanitize=memory)
    endif()

    if(${NM_OPT_PREFIX}_ENABLE_TSAN)
      list(APPEND sanitizer_flags -fsanitize=thread)
    endif()

    if(${NM_OPT_PREFIX}_ENABLE_UBSAN)
      list(APPEND sanitizer_flags -fsanitize=undefined)
    endif()

    if(sanitizer_flags)
      list(APPEND sanitizer_flags "-fno-omit-frame-pointer")
      nm_add_compile_options(${sanitizer_flags})

      string(REPLACE ";" " " SANITIZER_LINKER_FLAGS "${sanitizer_flags}")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${SANITIZER_LINKER_FLAGS}")
    endif()
  else()
    message(WARNING "NiceMake: no sanitizer support for MSVC. Sanitizer settings ignored.")
  endif()

  set(NM_SANITIZERS_CMAKE_INCLUDED TRUE)
endif()
