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

if(NOT NM_COLLECT_OBJS_FROM_SUBDIRECTORIES_CMAKE_INCLUDED)
  include(${CMAKE_CURRENT_LIST_DIR}/../detail/Utils.cmake)

  #
  # nm_collect_objs_from_subdirectories(COLLECT_IN <var> [DIRECTORY <basedir>]
  #   [TARGET_NAME_PREFIX <pre>] [TARGET_NAME_SUFFIX <suf>] [EXCLUDE_REGEX <r>])
  #
  # For each subdirectory `<x>` of `<basedir>`, this function collects the
  # objects of all object library targets named `<pre><y><suf>`, where `<y>` is
  # derived from `<x>` by replacing all inner path separators by a dot. Unless
  # specified via arguments, `<pre>` and `<suf>` are empty. If `<pre><y><suf>`
  # is not an object library target, a warning message is printed and the
  # offending target name is ignored.
  #
  # If `<basedir>` is not specified, it is set to the value of
  # `CMAKE_CURRENT_SOURCE_DIR`.
  #
  # This function is experimental. Whether it will be added to regular NiceMake
  # remains to be determined.
  #
  function(nm_collect_objs_from_subdirectories)
    cmake_parse_arguments(
      P_ARGS
      ""
      "TARGET_NAME_PREFIX;TARGET_NAME_SUFFIX;COLLECT_IN;DIRECTORY;EXCLUDE_REGEX"
      ""
      ${ARGN}
    )

    if(NOT P_ARGS_DIRECTORY)
      set(P_ARGS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    if(NOT P_ARGS_COLLECT_IN)
      message(FATAL_ERROR "Missing required argument COLLECT_IN")
    endif()

    if(NOT P_ARGS_EXCLUDE_REGEX)
      set(P_ARGS_EXCLUDE_REGEX "$^")
    endif()

    if(NOT P_ARGS_TARGET_NAME_PREFIX)
      set(P_ARGS_TARGET_NAME_PREFIX "")
    endif()

    if(NOT P_ARGS_TARGET_NAME_SUFFIX)
      set(P_ARGS_TARGET_NAME_SUFFIX "")
    endif()

    nm_detail_list_subdirectories(${P_ARGS_DIRECTORY} subdirs)
    if(P_ARGS_EXCLUDE_REGEX)
      nm_detail_remove_strings_from_list(subdirs ${P_ARGS_EXCLUDE_REGEX})
    endif()

    foreach(subdir ${subdirs})
      string(REPLACE "/" "." target ${subdir})
      string(PREPEND target ${P_ARGS_TARGET_NAME_PREFIX})
      string(APPEND target ${P_ARGS_TARGET_NAME_SUFFIX})
      if(TARGET ${target})
        get_target_property(type ${target} TYPE)
        if("${type}" STREQUAL "OBJECT_LIBRARY")
          list(APPEND ${P_ARGS_COLLECT_IN} $<TARGET_OBJECTS:${target}>)
        else()
          message(WARNING "nm_collect_objs_from_subdirectories: target '${target}' is not an OBJECT library. This target is ignored.")
        endif()
      else()
        message(WARNING "nm_collect_objs_from_subdirectories: subdirectory ${subdir} of ${P_ARGS_DIRECTORY} has no corresponding target '${target}'. This target is ignored.")
      endif()
    endforeach()

    set(${P_ARGS_COLLECT_IN} ${${P_ARGS_COLLECT_IN}} PARENT_SCOPE)
  endfunction()

  set(NM_COLLECT_OBJS_FROM_SUBDIRECTORIES_CMAKE_INCLUDED TRUE)
endif()
