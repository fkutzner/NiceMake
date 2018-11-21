# Thest that nm_add_library actually creates the desired libraries
# and sets up include paths.

function(add_build_lib_test mode)
  add_test(
    NAME build-lib-${mode}
    COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
                 ${mode}
                 ${CMAKE_CURRENT_SOURCE_DIR}/project
                 ${CMAKE_CURRENT_SOURCE_DIR}/../CheckResults.bash
                 ${CMAKE_GENERATOR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
endfunction()

foreach(mode IN ITEMS STATIC SHARED)
  add_build_lib_test(${mode})
endforeach()

if (NOT (CMAKE_VERSION VERSION_LESS "3.12"))
  foreach(mode IN ITEMS OBJECT OBJECT-STATIC OBJECT-SHARED)
    add_build_lib_test(${mode})
  endforeach()
endif()
