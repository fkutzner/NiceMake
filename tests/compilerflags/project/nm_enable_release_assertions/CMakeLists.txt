function(print_release_compiler_options)
  message(STATUS "CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
  message(STATUS "CMAKE_CXX_FLAGS_RELWITHDEBINFO: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  message(STATUS "CMAKE_CXX_FLAGS_MINSIZEREL: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
endfunction()

function(check_ndebug_flag_presence presence_expected error_msg)
  if(presence_expected)
    if((NOT "${CMAKE_CXX_FLAGS_RELEASE}" MATCHES "NDEBUG")
       OR (NOT "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" MATCHES "NDEBUG")
       OR (NOT "${CMAKE_CXX_FLAGS_MINSIZEREL}" MATCHES "NDEBUG"))
      message(FATAL_ERROR ${error_msg})
    endif()
  else()
    if("${CMAKE_CXX_FLAGS_RELEASE}" MATCHES "NDEBUG"
       OR "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" MATCHES "NDEBUG"
       OR "${CMAKE_CXX_FLAGS_MINSIZEREL}" MATCHES "NDEBUG")
      message(FATAL_ERROR ${error_msg})
    endif()
  endif()

endfunction()

# Testing that the assertions are enabled only for the current
# directory and below:

add_subdirectory(SubDir)

# Release-mode assertions should not be enabled here:
check_ndebug_flag_presence(TRUE "nm_enable_release_assertions: The setting should only hold for the current directory and below")

nm_enable_release_assertions()
check_ndebug_flag_presence(FALSE "nm_enable_release_assertions: Failed to remove NDEBUG flag")
