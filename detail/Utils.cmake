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

if(NOT NM_UTILS_CMAKE_INCLUDED)

  #
  # nm_detail_list_subdirectories(<root-directory> <result-list-varname>)
  #
  # Collects the paths of all subdirectories of <root-directory> into
  # the list named by <result-list-varname>. The paths inserted into
  # the list named by <result-list-varname> are relative to <root-directory>.
  #
  function(nm_detail_list_subdirectories root_directory result_list)
    set(result_list "" PARENT_SCOPE)
    file(GLOB_RECURSE files LIST_DIRECTORIES true FOLLOW_SYMLINKS
         RELATIVE "${root_directory}" "${root_directory}" )
    foreach(file ${files})
      if(IS_DIRECTORY "${root_directory}/${file}"
         AND (NOT ${file} MATCHES "^\\.\\."))
        list(APPEND result_list ${file})
      endif()
    endforeach()
    set(${result_list} ${${result_list}} PARENT_SCOPE)
  endfunction()


  #
  # nm_detail_remove_strings_from_list(<list-varname> <regex>)
  #
  # Removes all strings matching <regex> from the list named by <list-varname>.
  #
  function(nm_detail_remove_strings_from_list list regex)
    set(result)
    foreach(str ${${list}})
      if(NOT "${str}" MATCHES "${regex}")
        list(APPEND result "${str}")
      endif()
    endforeach()
    set(${list} ${result} PARENT_SCOPE)
  endfunction()

  set(NM_UTILS_CMAKE_INCLUDED TRUE)
endif()
